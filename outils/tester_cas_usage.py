#!/usr/bin/env python3
# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Stéphane Gounelle
# This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
# If a copy of the MPL was not distributed with this file, You can obtain one at
# https://mozilla.org/MPL/2.0/.
"""Compare les LED des cas d'usage à leurs datasheets (points de calage et de validation).

Principe : pour chaque LED dont le record existe, une rampe de courant traverse
plusieurs instances de la LED en série, chacune avec sa jonction maintenue à une
température du datasheet. On relève Vf et le flux (ou l'intensité) aux courants
du datasheet et on compare avec les tolérances du datasheet.

Les références sont dans outils/references_cas_usage.py. On distingue :
  - les points de CALAGE (ils servent aussi à paramétrer le record : le test vérifie
    seulement que le modèle reproduit ses données d'entrée) ;
  - les points de VALIDATION (hors record : vraie validation).

Usage (depuis la racine du projet) :
    python3 outils/tester_cas_usage.py
    python3 outils/tester_cas_usage.py --led FX2L

Code de retour : 0 si tous les points testés sont dans la tolérance, 1 sinon.
Exception : un point marqué « écart probable du datasheet » (clé "ecart_datasheet"
des références, posée d'après l'analyse du datasheet) qui sort de la tolérance est
signalé « ÉCART DS », reste compté hors tolérance dans le bilan, mais ne fait pas
échouer le code de retour. Une simulation impossible reste toujours un échec.

=============================================================================
RÈGLE ABSOLUE : les valeurs de references_cas_usage.py viennent des DATASHEETS.
Ne jamais les modifier, ni élargir les tolérances, pour faire passer un test.
=============================================================================
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from omc_outils import (DOSSIER_BUILD, RACINE, executer_modele,  # noqa: E402
                        interpoler, lire_csv, nom_bibliotheque, verifier_omc)
from references_cas_usage import LEDS  # noqa: E402

UNITES = {"Vf": "V", "Phi_v": "lm", "Iv": "cd"}


# ---------------------------------------------------------------------------
# Banc de test Modelica (à adapter si l'interface du composant LED change)
# ---------------------------------------------------------------------------
def banc_de_test(nom_modele: str, nom_lib: str, record: str, temperatures: list[float],
                 I_max: float, intervalle: float) -> str:
    """Une source de courant en rampe et une LED par température, toutes en série."""
    lignes = [f'model {nom_modele}',
              '  "Généré par outils/tester_cas_usage.py : ne pas modifier à la main"',
              f'  Modelica.Electrical.Analog.Sources.RampCurrent source(I = {I_max}, '
              'duration = 1, offset = 0, startTime = 0);',
              '  Modelica.Electrical.Analog.Basic.Ground masse;']
    for k, T in enumerate(temperatures, 1):
        lignes += [f'  {nom_lib}.Components.LED led{k}(redeclare {nom_lib}.Data.{record} data);',
                   f'  {nom_lib}.Thermal.FixedTemperature jonction{k}(T = {T + 273.15});']
    lignes.append('equation')
    lignes.append('  connect(source.n, led1.p);')
    for k in range(1, len(temperatures)):
        lignes.append(f'  connect(led{k}.n, led{k + 1}.p);')
    lignes.append(f'  connect(led{len(temperatures)}.n, masse.p);')
    lignes.append('  connect(source.p, masse.p);')
    for k in range(1, len(temperatures) + 1):
        lignes.append(f'  connect(jonction{k}.port, led{k}.heatPort);')
    lignes.append(f'  annotation(experiment(StartTime = 0, StopTime = 1, Interval = {intervalle}));')
    lignes.append(f'end {nom_modele};')
    return "\n".join(lignes) + "\n"


VAR = {"Vf": "v", "Phi_v": "Phi_v", "Iv": "Iv"}  # variables lues sur chaque instance


# ---------------------------------------------------------------------------
def temperature_jonction(point: dict, led: dict) -> float | None:
    """Température de jonction du point (°C), ou None si la conversion n'est pas fixée."""
    if point["T_mesuree"] == "jonction":
        return point["T"]
    if led["decalage_Tsp_Tj"] is None:
        return None
    return point["T"] + led["decalage_Tsp_Tj"]


def tester_led(led: dict, nom_lib: str, dossier_lib: Path, msl: str) -> tuple[list, int]:
    """Renvoie (lignes de résultat, nombre de points en attente)."""
    testables = [(p, temperature_jonction(p, led)) for p in led["points"]]
    attente = sum(1 for _, t in testables if t is None)
    testables = [(p, t) for p, t in testables if t is not None]
    if not testables:
        return [], attente

    temperatures = sorted({t for _, t in testables})
    I_max = led.get("banc", {}).get("I_max", 1.1*max(p["I"] for p, _ in testables))
    intervalle = led.get("banc", {}).get("intervalle", 1/5000)
    nom_modele = f"TestCasUsage_{led['nom']}"
    dossier = DOSSIER_BUILD / "tests_cas_usage" / led["nom"]
    fichier_banc = DOSSIER_BUILD / "tests_cas_usage" / f"{nom_modele}.mo"
    fichier_banc.parent.mkdir(parents=True, exist_ok=True)
    fichier_banc.write_text(banc_de_test(nom_modele, nom_lib, led["record"], temperatures,
                                         I_max, intervalle), encoding="utf-8")

    r = executer_modele(nom_modele, [dossier_lib / "package.mo", fichier_banc], msl, dossier)
    if not r.ok or r.fichier_resultat is None:
        print(f"   ÉCHEC : le banc de test de {led['nom']} n'a pas pu être simulé.")
        for m in r.erreurs[:5]:
            print("      " + m[:800].replace("\n", "\n      "))
        print(f"   Détails : {(dossier / 'sortie_omc.txt').relative_to(RACINE)}")
        return [("ERREUR",)], attente

    donnees = lire_csv(r.fichier_resultat)
    lignes = []
    for p, t in testables:
        k = temperatures.index(t) + 1
        var = f"led{k}.{VAR[p['grandeur']]}"
        courant = donnees.get(f"led{k}.i")
        if courant is None or var not in donnees:
            lignes.append((p, t, None, None, False))
            continue
        y_mod = interpoler(p["I"], courant, donnees[var])
        if y_mod is None:
            lignes.append((p, t, None, None, False))
            continue
        genre, tol = led["tolerances"][p["grandeur"]]
        ecart = (y_mod - p["valeur"]) if genre == "abs" else (y_mod - p["valeur"])/p["valeur"]
        lignes.append((p, t, y_mod, ecart, abs(ecart) <= tol))
    return lignes, attente


def afficher(led: dict, lignes: list, attente: int) -> tuple[dict, bool]:
    bilan = {"calage": [0, 0], "validation": [0, 0]}
    if lignes and lignes[0] == ("ERREUR",):
        return bilan, False
    print(f"{'Grandeur':8} {'Courant':>9} {'Tj':>7} {'Datasheet':>11} {'Modèle':>11} "
          f"{'Écart':>9} {'Tolér.':>8}  {'Verdict':8} {'Rôle':10} Source")
    print("-"*105)
    ecarts_ds = []      # points hors tolérance marqués « écart probable du datasheet »
    echecs = 0          # points hors tolérance non excusés (ou non simulés)
    for p, t, y, ecart, ok in sorted(lignes, key=lambda l: (l[0]["role"], l[0]["grandeur"], l[1], l[0]["I"])):
        genre, tol = led["tolerances"][p["grandeur"]]
        u = UNITES[p["grandeur"]]
        if ecart is None:
            ec, ym = "-", "-"
        elif genre == "abs":
            ec, ym = f"{ecart*1e3:+.0f} m{u}", f"{y:.4g} {u}"
        else:
            ec, ym = f"{ecart:+.1%}", f"{y:.4g} {u}"
        tl = f"±{tol*1e3:.0f} m{u}" if genre == "abs" else f"±{tol:.1%}"
        if ok:
            verdict = "OK"
        elif ecart is not None and p.get("ecart_datasheet"):
            verdict = "ÉCART DS"
            ecarts_ds.append(p["ecart_datasheet"])
        else:
            verdict = "ÉCHEC"
            echecs += 1
        print(f"{p['grandeur']:8} {p['I']*1e3:7.1f}mA {t:5.0f}°C {p['valeur']:9.4g} {u:<2}"
              f"{ym:>11} {ec:>9} {tl:>8}  {verdict:8} {p['role']:10} {p['source']}")
        bilan[p["role"]][1] += 1
        bilan[p["role"]][0] += ok
    print("-"*105)
    for role in ("calage", "validation"):
        n_ok, n = bilan[role]
        if n:
            print(f"Bilan {role:10} : {n_ok}/{n} point(s) dans la tolérance")
    if ecarts_ds:
        print(f"Dont {len(ecarts_ds)} point(s) hors tolérance marqué(s) « écart probable du "
              f"datasheet » (sans effet sur le code de retour) :")
        for motif in dict.fromkeys(ecarts_ds):
            print(f"   - {motif}")
    if attente:
        print(f"En attente : {attente} point(s) en Tsp (conversion Tsp -> Tj non encore fixée)")
    bilan["ecarts_ds"] = len(ecarts_ds)
    return bilan, echecs == 0


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--lib", default="LEDSystems", help="dossier de la bibliothèque (défaut : LEDSystems)")
    p.add_argument("--msl", default="4.1.0", help="version de la MSL (défaut : 4.1.0)")
    p.add_argument("--led", action="append", help="nom court d'une LED à tester (option répétable)")
    args = p.parse_args()

    version = verifier_omc()
    dossier_lib = (RACINE / args.lib).resolve()
    nom_lib = nom_bibliotheque(dossier_lib)
    print(f"Test des cas d'usage — bibliothèque {nom_lib} — {version}\n")

    tout_ok = True
    resume = []
    for led in LEDS:
        if args.led and led["nom"] not in args.led:
            continue
        print(f"=== {led['nom']} : {led['titre']}")
        if not (dossier_lib / "Data" / f"{led['record']}.mo").exists():
            print(f"   En attente : record Data.{led['record']} pas encore créé "
                  f"({len(led['points'])} points de référence prêts).\n")
            resume.append((led["nom"], "en attente", None))
            continue
        lignes, attente = tester_led(led, nom_lib, dossier_lib, args.msl)
        bilan, ok = afficher(led, lignes, attente)
        tout_ok &= ok
        etat = "ÉCHEC" if not ok else ("OK*" if bilan.get("ecarts_ds") else "OK")
        resume.append((led["nom"], etat, bilan))
        print()

    print("=== Résumé")
    for nom, etat, bilan in resume:
        detail = "" if bilan is None else "  ".join(
            f"{r} {bilan[r][0]}/{bilan[r][1]}" for r in ("calage", "validation") if bilan[r][1])
        if bilan and bilan.get("ecarts_ds"):
            detail += f"  (dont {bilan['ecarts_ds']} écart(s) probable(s) du datasheet)"
        print(f"   {nom:8} {etat:10} {detail}")
    if any(etat == "OK*" for _, etat, _ in resume):
        print("   * hors tolérance seulement sur des points marqués « écart probable du datasheet »")
    return 0 if tout_ok else 1


if __name__ == "__main__":
    sys.exit(main())
