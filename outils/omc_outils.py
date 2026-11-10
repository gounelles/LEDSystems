# SPDX-License-Identifier: BSD-3-Clause
# Copyright (c) 2026 Stéphane Gounelle
"""Fonctions communes pour piloter OpenModelica (omc) depuis Python.

Utilisé par verifier.py, tester_datasheet.py et tester_cas_usage.py.
Aucune dépendance en dehors de la bibliothèque standard de Python.
"""
from __future__ import annotations

import csv
import os
import re
import shutil
import subprocess
import time
from dataclasses import dataclass, field
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
DOSSIER_BUILD = RACINE / "build"

# Messages d'omc en anglais (format stable, plus facile à analyser) ;
# fichiers toujours lus en UTF-8.
ENV_OMC = {**os.environ, "LC_ALL": "C.UTF-8", "LANG": "C.UTF-8"}


# ---------------------------------------------------------------------------
# Contrôles préalables
# ---------------------------------------------------------------------------
def verifier_omc() -> str:
    """Vérifie que omc est disponible et renvoie sa version."""
    if shutil.which("omc") is None:
        raise SystemExit(
            "ERREUR : la commande 'omc' est introuvable.\n"
            "Installez OpenModelica ou ajoutez le dossier de omc au PATH."
        )
    sortie = subprocess.run(["omc", "--version"], capture_output=True,
                            text=True, env=ENV_OMC)
    return sortie.stdout.strip() or sortie.stderr.strip()


def nom_bibliotheque(dossier_lib: Path) -> str:
    """Lit le nom du package racine et vérifie qu'il correspond au dossier."""
    package_mo = dossier_lib / "package.mo"
    if not package_mo.exists():
        raise SystemExit(
            f"ERREUR : {package_mo} introuvable.\n"
            "L'option --lib doit désigner le dossier qui contient package.mo."
        )
    texte = package_mo.read_text(encoding="utf-8", errors="replace")
    m = re.search(r"^\s*package\s+(\w+)", texte, re.M)
    if not m:
        raise SystemExit(f"ERREUR : aucune déclaration 'package' dans {package_mo}.")
    nom = m.group(1)
    if nom != dossier_lib.name:
        raise SystemExit(
            f"ERREUR : le dossier s'appelle '{dossier_lib.name}' mais le package "
            f"s'appelle '{nom}'.\nOpenModelica exige que les deux soient identiques."
        )
    return nom


# ---------------------------------------------------------------------------
# Recherche des exemples
# ---------------------------------------------------------------------------
def lister_exemples(dossier_lib: Path, nom_lib: str,
                    sous_package: str = "Examples") -> list[str]:
    """Liste les modèles (non partiels) du package d'exemples, dans l'ordre
    de package.order, en descendant dans les sous-packages."""
    resultats: list[str] = []

    def parcourir(dossier: Path, prefixe: str) -> None:
        ordre = dossier / "package.order"
        noms = []
        if ordre.exists():
            noms = [l.strip() for l in ordre.read_text(encoding="utf-8").splitlines()
                    if l.strip()]
        # Éléments présents mais absents de package.order : ajoutés à la fin
        for f in sorted(dossier.glob("*.mo")):
            if f.name != "package.mo" and f.stem not in noms:
                noms.append(f.stem)
        for d in sorted(x for x in dossier.iterdir()
                        if x.is_dir() and (x / "package.mo").exists()):
            if d.name not in noms:
                noms.append(d.name)

        for n in noms:
            if (dossier / n / "package.mo").exists():
                parcourir(dossier / n, f"{prefixe}.{n}")
            elif (dossier / f"{n}.mo").exists():
                texte = (dossier / f"{n}.mo").read_text(encoding="utf-8",
                                                         errors="replace")
                # "partial model X" ne correspond pas : seuls les modèles complets
                if re.search(rf"^\s*model\s+{re.escape(n)}\b", texte, re.M):
                    resultats.append(f"{prefixe}.{n}")

    dossier_ex = dossier_lib / sous_package
    if (dossier_ex / "package.mo").exists():
        parcourir(dossier_ex, f"{nom_lib}.{sous_package}")
    return resultats


# ---------------------------------------------------------------------------
# Exécution d'un modèle : vérification, compilation, simulation
# ---------------------------------------------------------------------------
@dataclass
class ResultatModele:
    nom: str
    chargement_ok: bool = False
    check_ok: bool = False
    build_ok: bool = False
    simu_ok: bool = False
    simule: bool = False
    message_check: str = ""
    erreurs: list[str] = field(default_factory=list)
    avertissements: list[str] = field(default_factory=list)
    sortie_simulation: str = ""
    fichier_resultat: Path | None = None
    duree_simulation: float = 0.0

    @property
    def ok(self) -> bool:
        return self.check_ok and (not self.simule or (self.build_ok and self.simu_ok))


def _chemin_mos(chemin: Path) -> str:
    return str(chemin).replace("\\", "/").replace('"', '\\"')


def _script_mos(nom_modele: str, fichiers: list[Path], msl: str,
                simuler: bool) -> str:
    lignes = [
        "echo(false);",
        f'ok := loadModel(Modelica, {{"{msl}"}});',
        'print("@@MSL@@" + String(ok) + "@@FIN@@");',
    ]
    for f in fichiers:
        lignes += [
            f'ok := loadFile("{_chemin_mos(f)}");',
            'print("@@CHARGE@@" + String(ok) + "@@FIN@@");',
        ]
    lignes += [
        'print("@@ERR_CHARGEMENT@@" + getErrorString() + "@@FIN@@");',
        f"res := checkModel({nom_modele});",
        'print("@@CHECK@@" + res + "@@FIN@@");',
        'print("@@ERR_CHECK@@" + getErrorString() + "@@FIN@@");',
    ]
    if simuler:
        lignes += [
            f'b := buildModel({nom_modele}, outputFormat="csv");',
            'print("@@ERR_BUILD@@" + getErrorString() + "@@FIN@@");',
        ]
    return "\n".join(lignes) + "\n"


def _trier_messages(texte: str, res: ResultatModele) -> None:
    """Répartit les messages d'omc en erreurs / avertissements."""
    bloc: list[str] = []

    def vider():
        if bloc:
            msg = "\n".join(bloc).strip()
            premiere = bloc[0]
            if re.search(r"\bNotification\b", premiere):
                pass  # simple information d'omc (chargement automatique, etc.)
            elif re.search(r"\bWarning\b", premiere):
                res.avertissements.append(msg)
            elif msg:
                res.erreurs.append(msg)
            bloc.clear()

    for ligne in texte.splitlines():
        # Un nouveau message commence par "[fichier:ligne...]" ou "Error:"/"Warning:"
        if re.match(r"^\s*(\[.*\]\s*)?(Error|Warning|Notification)\b", ligne):
            vider()
        if ligne.strip():
            bloc.append(ligne)
    vider()


def executer_modele(nom_modele: str, fichiers: list[Path], msl: str,
                    dossier: Path, simuler: bool = True,
                    timeout: int = 600) -> ResultatModele:
    """Charge les fichiers, vérifie, compile et simule un modèle.

    Tout se passe dans `dossier` (fichiers générés par omc compris)."""
    res = ResultatModele(nom=nom_modele, simule=simuler)
    if dossier.exists():
        shutil.rmtree(dossier)
    dossier.mkdir(parents=True)

    script = dossier / "script.mos"
    script.write_text(_script_mos(nom_modele, fichiers, msl, simuler),
                      encoding="utf-8")
    try:
        proc = subprocess.run(["omc", script.name], cwd=dossier,
                              capture_output=True, text=True,
                              timeout=timeout, env=ENV_OMC)
    except subprocess.TimeoutExpired:
        res.erreurs.append(f"omc n'a pas répondu en {timeout} s (vérification/compilation).")
        return res

    sortie = proc.stdout + proc.stderr
    (dossier / "sortie_omc.txt").write_text(sortie, encoding="utf-8")
    marqueurs: dict[str, list[str]] = {}
    for cle, valeur in re.findall(r"@@(\w+)@@(.*?)@@FIN@@", sortie, re.S):
        marqueurs.setdefault(cle, []).append(valeur)

    if marqueurs.get("MSL", ["false"])[0].strip() != "true":
        res.erreurs.append(
            f"Impossible de charger la Modelica Standard Library {msl}.\n"
            "Pour l'installer :  echo 'installPackage(Modelica, \"" + msl +
            "\"); getErrorString();' > /tmp/msl.mos && omc /tmp/msl.mos"
        )
    res.chargement_ok = all(v.strip() == "true" for v in marqueurs.get("CHARGE", ["false"]))
    if not marqueurs:
        res.erreurs.append("Sortie d'omc inattendue :\n" + sortie[-3000:])
        return res

    for cle in ("ERR_CHARGEMENT", "ERR_CHECK", "ERR_BUILD"):
        for texte in marqueurs.get(cle, []):
            _trier_messages(texte, res)

    res.message_check = marqueurs.get("CHECK", [""])[0].strip()
    res.check_ok = res.chargement_ok and "completed successfully" in res.message_check
    if not simuler or not res.check_ok:
        return res

    executable = dossier / nom_modele
    res.build_ok = executable.exists()
    if not res.build_ok:
        if not res.erreurs:
            res.erreurs.append("La compilation n'a pas produit d'exécutable "
                               "(voir build/.../sortie_omc.txt).")
        return res

    debut = time.monotonic()
    try:
        simu = subprocess.run([f"./{nom_modele}"], cwd=dossier,
                              capture_output=True, text=True,
                              timeout=timeout, env=ENV_OMC)
    except subprocess.TimeoutExpired:
        res.erreurs.append(f"La simulation a dépassé {timeout} s.")
        return res
    res.duree_simulation = time.monotonic() - debut
    res.sortie_simulation = (simu.stdout + simu.stderr).strip()

    for ligne in res.sortie_simulation.splitlines():
        if "| warning |" in ligne:
            res.avertissements.append("[simulation] " + ligne.strip())
        elif "| error |" in ligne or "| assert |" in ligne:
            res.erreurs.append("[simulation] " + ligne.strip())

    fichier = dossier / f"{nom_modele}_res.csv"
    res.simu_ok = simu.returncode == 0 and fichier.exists()
    if fichier.exists():
        res.fichier_resultat = fichier
    if not res.simu_ok and not any(e.startswith("[simulation]") for e in res.erreurs):
        res.erreurs.append("[simulation] échec (code retour "
                           f"{simu.returncode}) :\n" + res.sortie_simulation[-2000:])
    return res


# ---------------------------------------------------------------------------
# Lecture des résultats
# ---------------------------------------------------------------------------
def lire_csv(fichier: Path) -> dict[str, list[float]]:
    """Lit un fichier de résultats CSV d'OpenModelica : {variable: valeurs}."""
    with fichier.open(encoding="utf-8", newline="") as f:
        lecteur = csv.reader(f)
        entetes = [h.strip() for h in next(lecteur)]
        colonnes: dict[str, list[float]] = {h: [] for h in entetes}
        for ligne in lecteur:
            for h, v in zip(entetes, ligne):
                try:
                    colonnes[h].append(float(v))
                except ValueError:
                    colonnes[h].append(float("nan"))
    return colonnes


def interpoler(x_cible: float, xs: list[float], ys: list[float]) -> float | None:
    """Interpolation linéaire de y pour x = x_cible (xs croissant)."""
    for i in range(1, len(xs)):
        x0, x1 = xs[i - 1], xs[i]
        if x0 <= x_cible <= x1:
            if x1 == x0:
                return ys[i]
            return ys[i - 1] + (ys[i] - ys[i - 1]) * (x_cible - x0) / (x1 - x0)
    return None
