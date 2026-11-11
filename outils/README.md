# Outils de vérification

Scripts Python qui vérifient la bibliothèque LEDSystems avec OpenModelica (`omc`) :
compilation et simulation de tous les exemples, comparaison des LED à leurs datasheets,
calculs de référence faits hors Modelica.

## Prérequis

- OpenModelica (testé avec la version 1.26.1), avec la Modelica Standard Library 4.1.0 ;
  la commande `omc` doit être accessible dans le `PATH`.
- Python 3 (testé avec la version 3.10), **bibliothèque standard seulement** : rien à
  installer.

Tous les scripts se lancent **depuis la racine du dépôt**.

## Scripts

| Commande | Rôle |
|---|---|
| `python3 outils/verifier.py` | Vérifie (`checkModel`), compile et simule tous les exemples de la bibliothèque ; compte les erreurs et les avertissements |
| `python3 outils/verifier.py --sans-simulation` | Vérification seule, rapide |
| `python3 outils/verifier.py --modele LEDSystems.Examples.Basics.LEDSimplePhoto` | Un seul modèle (option répétable) |
| `python3 outils/tester_cas_usage.py` | Compare les LED des cas d'usage à leurs datasheets : points de calage et de validation |
| `python3 outils/tester_cas_usage.py --led DS242` | Une seule LED (`Vishay`, `DS55`, `DS242`, `FX2L` ; option répétable) |
| `python3 outils/tester_datasheet.py` | Contrôle de la LED Vishay VLMW41S1T1 (8 points de son datasheet) |
| `python3 outils/calculs_reference.py` | Calculs hors Modelica : calages exacts I-V, approximation de V(λ), LER des spectres des datasheets |

Options communes : `--lib` (dossier de la bibliothèque, défaut `LEDSystems`), `--msl`
(version de la MSL, défaut `4.1.0`). `--help` sur chaque script donne le détail.

Fichiers de support :

- `omc_outils.py` : fonctions communes pour piloter `omc` (chargement, simulation,
  lecture des résultats) ;
- `references_cas_usage.py` : valeurs de référence des datasheets, chacune avec sa source
  (page, figure ou tableau), son rôle (calage ou validation) et la température à laquelle
  elle a été mesurée.

## Résultats

- Fichiers produits par `omc` : dossier `build/` (ignoré par Git), un sous-dossier par
  modèle ; sortie d'`omc` dans `sortie_omc.txt`.
- Rapport détaillé de `verifier.py` : `build/rapport_verification.txt`.
- Code de retour : 0 si tout est correct, 1 sinon (utilisable en intégration continue).
- `tester_cas_usage.py` : un point hors tolérance est signalé `ÉCHEC`. Exception : un
  point marqué « écart probable du datasheet » dans les références (données
  contradictoires dans le datasheet lui-même, constatées avant le test) est signalé
  `ÉCART DS` : il reste compté hors tolérance dans le bilan, mais ne fait pas échouer le
  code de retour (résumé `OK*`).

## Règle

Les valeurs de référence et les tolérances viennent des datasheets. **Ne jamais les
modifier, ni élargir une tolérance, pour faire passer un test.** Si une référence semble
fausse, la revérifier sur le datasheet.

---

© 2026 Stéphane Gounelle. Scripts sous licence MPL-2.0 ([LICENSE](../LICENSE)),
ce texte sous licence CC BY-SA 4.0 ([LICENSE-CC-BY-SA-4.0.txt](../LICENSE-CC-BY-SA-4.0.txt)).
