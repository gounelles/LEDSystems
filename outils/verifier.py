#!/usr/bin/env python3
# SPDX-License-Identifier: BSD-3-Clause
# Copyright (c) 2026 Stéphane Gounelle
"""Vérifie, compile et simule tous les exemples de la bibliothèque.

Usage (depuis la racine du projet) :
    python3 outils/verifier.py                      # tous les exemples
    python3 outils/verifier.py --sans-simulation    # vérification seule (rapide)
    python3 outils/verifier.py --modele LEDSystems.Examples.Basics.LEDSimplePhoto
    python3 outils/verifier.py --lib AutreNom       # si la bibliothèque est renommée

Rapport complet : build/rapport_verification.txt
Code de retour : 0 si tout passe, 1 sinon.
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from omc_outils import (DOSSIER_BUILD, RACINE, executer_modele,  # noqa: E402
                        lister_exemples, nom_bibliotheque, verifier_omc)


def statut(ok: bool, fait: bool = True) -> str:
    if not fait:
        return "  -  "
    return " OK  " if ok else "ÉCHEC"


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--lib", default="LEDSystems",
                   help="dossier de la bibliothèque, relatif à la racine du projet (défaut : LEDSystems)")
    p.add_argument("--msl", default="4.1.0", help="version de la MSL (défaut : 4.1.0)")
    p.add_argument("--sans-simulation", action="store_true",
                   help="vérification (checkModel) seulement, sans compiler ni simuler")
    p.add_argument("--modele", action="append",
                   help="nom complet d'un modèle à traiter (option répétable)")
    p.add_argument("--timeout", type=int, default=600,
                   help="durée max par modèle et par phase, en s (défaut : 600)")
    args = p.parse_args()

    version = verifier_omc()
    dossier_lib = (RACINE / args.lib).resolve()
    nom_lib = nom_bibliotheque(dossier_lib)
    modeles = args.modele or lister_exemples(dossier_lib, nom_lib)
    simuler = not args.sans_simulation

    print(f"Bibliothèque : {nom_lib}  ({dossier_lib})")
    print(f"omc : {version}   MSL : {args.msl}")
    print(f"{len(modeles)} modèle(s) à traiter"
          f"{'' if simuler else ' (vérification seule)'}\n")
    if not modeles:
        print("Aucun exemple trouvé : le package Examples existe-t-il ?")
        return 1

    resultats = []
    for i, nom in enumerate(modeles, 1):
        print(f"[{i}/{len(modeles)}] {nom} ...", flush=True)
        dossier = DOSSIER_BUILD / "verification" / nom
        r = executer_modele(nom, [dossier_lib / "package.mo"], args.msl,
                            dossier, simuler=simuler, timeout=args.timeout)
        resultats.append(r)
        bilan = "OK" if r.ok else "ÉCHEC"
        detail = f"{len(r.erreurs)} erreur(s), {len(r.avertissements)} avertissement(s)"
        if r.simu_ok:
            detail += f", simulation {r.duree_simulation:.1f} s"
        print(f"      {bilan} — {detail}")

    # ----- Résumé -----
    largeur = max(len(r.nom) for r in resultats)
    print("\n" + "=" * (largeur + 40))
    print(f"{'Modèle':<{largeur}}  Vérif  Compil  Simu   Avert.")
    print("-" * (largeur + 40))
    for r in resultats:
        print(f"{r.nom:<{largeur}}  {statut(r.check_ok)}  "
              f"{statut(r.build_ok, simuler and r.check_ok)}  "
              f"{statut(r.simu_ok, simuler and r.build_ok)}  {len(r.avertissements):>4}")
    print("=" * (largeur + 40))

    # ----- Rapport détaillé -----
    DOSSIER_BUILD.mkdir(exist_ok=True)
    rapport = DOSSIER_BUILD / "rapport_verification.txt"
    with rapport.open("w", encoding="utf-8") as f:
        f.write(f"Bibliothèque {nom_lib} — {version} — MSL {args.msl}\n\n")
        for r in resultats:
            f.write("#" * 78 + f"\n# {r.nom} : {'OK' if r.ok else 'ÉCHEC'}\n" + "#" * 78 + "\n")
            if r.message_check:
                f.write("\n--- checkModel ---\n" + r.message_check + "\n")
            for titre, liste in (("ERREURS", r.erreurs), ("AVERTISSEMENTS", r.avertissements)):
                if liste:
                    f.write(f"\n--- {titre} ({len(liste)}) ---\n")
                    for m in liste:
                        f.write(m + "\n\n")
            if r.sortie_simulation:
                f.write("\n--- sortie de la simulation (fin) ---\n"
                        + r.sortie_simulation[-1500:] + "\n")
            f.write("\n")

    echecs = [r for r in resultats if not r.ok]
    for r in echecs:
        print(f"\n>>> {r.nom}")
        for m in r.erreurs[:3]:
            print("   " + m[:600].replace("\n", "\n   "))
        if len(r.erreurs) > 3:
            print(f"   ... {len(r.erreurs) - 3} autre(s) erreur(s) dans le rapport")

    print(f"\nRapport complet : {rapport.relative_to(RACINE)}")
    print(f"Bilan : {len(resultats) - len(echecs)}/{len(resultats)} modèle(s) OK")
    return 0 if not echecs else 1


if __name__ == "__main__":
    sys.exit(main())
