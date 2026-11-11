#!/usr/bin/env python3
# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Stéphane Gounelle
# This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
# If a copy of the MPL was not distributed with this file, You can obtain one at
# https://mozilla.org/MPL/2.0/.
"""Compare le modèle de LED aux valeurs lues sur le datasheet.

Principe : une rampe de courant (0 -> 120 mA en 1 s) traverse la LED, dont la
jonction est maintenue à 25 °C. On relève Vf et Iv aux courants du datasheet
et on compare avec une tolérance.

Usage (depuis la racine du projet) :
    python3 outils/tester_datasheet.py
    python3 outils/tester_datasheet.py --lib LEDLib

Code de retour : 0 si tous les points sont dans la tolérance, 1 sinon.

=============================================================================
RÈGLE ABSOLUE : les valeurs de REFERENCES viennent du DATASHEET, pas du modèle.
Ne jamais les modifier, ni élargir les tolérances, pour faire passer un test.
Si une référence semble fausse, il faut la revérifier sur le datasheet.
=============================================================================
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from omc_outils import (DOSSIER_BUILD, RACINE, executer_modele,  # noqa: E402
                        interpoler, lire_csv, nom_bibliotheque, verifier_omc)

# ---------------------------------------------------------------------------
# 1) RÉFÉRENCES DATASHEET (ne pas modifier sans revérifier le datasheet)
# ---------------------------------------------------------------------------
REFERENCES = {
    "titre": "Vishay VLMW41S1T1-5K8L-08 (blanc froid), jonction à 25 °C",
    # Fig. 4 du datasheet : tension directe en fonction du courant
    "tension": [  # (courant A, tension V)
        (1e-3, 2.75),
        (20e-3, 3.30),
        (100e-3, 4.50),
    ],
    # Fig. 5 : intensité relative x Iv nominale (275 mcd à 10 mA)
    "intensite": [  # (courant A, intensité lumineuse cd)
        (1e-3, 0.12 * 0.275),
        (3e-3, 0.25 * 0.275),
        (10e-3, 1.00 * 0.275),
        (30e-3, 2.20 * 0.275),
        (100e-3, 6.50 * 0.275),
    ],
}
TOLERANCE_TENSION = 0.03    # ±3 % (lecture d'une courbe)
TOLERANCE_INTENSITE = 0.15  # ±15 % (courbe en échelle log, dispersion)

# ---------------------------------------------------------------------------
# 2) BANC DE TEST MODELICA
#    À ADAPTER quand l'interface du composant LED change (nom de classe,
#    record de données, choix du mode thermique). Le reste du script, lui,
#    ne doit pas changer.
# ---------------------------------------------------------------------------
COURANT_MAX = 0.12  # A, doit dépasser le plus grand courant des références

def banc_de_test(nom_lib: str) -> str:
    return f"""model TestDatasheet
  "Généré par outils/tester_datasheet.py : ne pas modifier à la main"
  {nom_lib}.Components.LED led(
    redeclare {nom_lib}.Data.Vishay_VLMW41S1T1 data);
  {nom_lib}.Thermal.FixedTemperature jonction(T = 298.15)
    "Jonction maintenue à 25 °C, condition des datasheets";
  Modelica.Electrical.Analog.Sources.RampCurrent source(
    I = {COURANT_MAX}, duration = 1, offset = 0, startTime = 0);
  Modelica.Electrical.Analog.Basic.Ground masse;
equation
  connect(source.n, led.p);
  connect(led.n, masse.p);
  connect(source.p, masse.p);
  connect(jonction.port, led.heatPort);
  annotation(experiment(StartTime = 0, StopTime = 1, Interval = 0.0005));
end TestDatasheet;
"""

# Noms des variables dans les résultats (à adapter avec le banc de test)
VAR_COURANT = "led.i"
VAR_TENSION = "led.v"
VAR_INTENSITE = "led.Iv"


# ---------------------------------------------------------------------------
def main() -> int:
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--lib", default="LEDSystems", help="dossier de la bibliothèque (défaut : LEDSystems)")
    p.add_argument("--msl", default="4.1.0", help="version de la MSL (défaut : 4.1.0)")
    args = p.parse_args()

    version = verifier_omc()
    dossier_lib = (RACINE / args.lib).resolve()
    nom_lib = nom_bibliotheque(dossier_lib)
    dossier = DOSSIER_BUILD / "tests_datasheet"

    print(f"Test datasheet : {REFERENCES['titre']}")
    print(f"Bibliothèque {nom_lib} — {version}\n")

    # Le fichier du banc est écrit hors du dossier de travail (vidé par executer_modele)
    fichier_banc = DOSSIER_BUILD / "TestDatasheet.mo"
    DOSSIER_BUILD.mkdir(exist_ok=True)
    fichier_banc.write_text(banc_de_test(nom_lib), encoding="utf-8")

    r = executer_modele("TestDatasheet", [dossier_lib / "package.mo", fichier_banc],
                        args.msl, dossier)
    if not r.ok or r.fichier_resultat is None:
        print("ÉCHEC : le banc de test n'a pas pu être simulé.")
        for m in r.erreurs[:5]:
            print("   " + m[:800].replace("\n", "\n   "))
        print(f"\nDétails : {(dossier / 'sortie_omc.txt').relative_to(RACINE)}")
        print("Si l'interface du composant LED a changé, adapter la partie 2) du script.")
        return 1

    donnees = lire_csv(r.fichier_resultat)
    manquantes = [v for v in (VAR_COURANT, VAR_TENSION, VAR_INTENSITE) if v not in donnees]
    if manquantes:
        print(f"ÉCHEC : variables absentes des résultats : {', '.join(manquantes)}")
        print("Adapter VAR_COURANT / VAR_TENSION / VAR_INTENSITE dans le script.")
        return 1

    courant = donnees[VAR_COURANT]
    lignes = []
    for grandeur, var, unite, refs, tol in (
        ("Tension Vf", VAR_TENSION, "V", REFERENCES["tension"], TOLERANCE_TENSION),
        ("Intensité Iv", VAR_INTENSITE, "cd", REFERENCES["intensite"], TOLERANCE_INTENSITE),
    ):
        for i_ref, y_ref in refs:
            y_mod = interpoler(i_ref, courant, donnees[var])
            if y_mod is None:
                lignes.append((grandeur, i_ref, y_ref, None, None, tol, unite, False))
                continue
            ecart = (y_mod - y_ref) / y_ref
            lignes.append((grandeur, i_ref, y_ref, y_mod, ecart, tol, unite, abs(ecart) <= tol))

    print(f"{'Grandeur':<13} {'Courant':>8} {'Datasheet':>11} {'Modèle':>11} "
          f"{'Écart':>8} {'Tolér.':>7}  Verdict")
    print("-" * 72)
    for g, i_ref, y_ref, y_mod, ecart, tol, u, ok in lignes:
        mod = f"{y_mod:.4g} {u}" if y_mod is not None else "hors plage"
        ec = f"{ecart:+.1%}" if ecart is not None else "-"
        print(f"{g:<13} {i_ref*1e3:>6.1f}mA {y_ref:>8.4g} {u:<2} {mod:>11} "
              f"{ec:>8} {'±'+format(tol, '.0%'):>7}  {'OK' if ok else 'ÉCHEC'}")
    nb_ok = sum(1 for l in lignes if l[-1])
    print("-" * 72)
    print(f"Bilan : {nb_ok}/{len(lignes)} point(s) dans la tolérance")
    return 0 if nb_ok == len(lignes) else 1


if __name__ == "__main__":
    sys.exit(main())
