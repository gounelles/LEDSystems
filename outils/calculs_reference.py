#!/usr/bin/env python3
# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Stéphane Gounelle
# This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
# If a copy of the MPL was not distributed with this file, You can obtain one at
# https://mozilla.org/MPL/2.0/.
"""Calculs de référence indépendants de Modelica (bibliothèque standard uniquement).

Sert à préparer les records de données et à prévoir les valeurs attendues :
  - calage exact de la loi de Shockley + Rs sur 3 points (même méthode que
    LEDSystems.Functions.fitShockley3Points) ;
  - modèle Python simplifié de la LED (Vf(I, Tj), intensité relative) ;
  - efficacité lumineuse du rayonnement (LER) à partir d'un spectre ;
  - conversion de la température du point de soudure (Tsp) en température de jonction.

Usage (depuis la racine du projet) :
    python3 outils/calculs_reference.py      # calages des LED et contrôle de V(lambda)
"""
from __future__ import annotations

import math
import sys
from pathlib import Path

K_BOLTZMANN = 1.380649e-23   # J/K
Q_ELECTRON = 1.602176634e-19  # C
KM = 683.0                    # lm/W, efficacité lumineuse maximale (555 nm)


# ---------------------------------------------------------------------------
# Calage I-V
# ---------------------------------------------------------------------------
def tension_thermique(T: float) -> float:
    """kT/q (V) à la température T (K)."""
    return K_BOLTZMANN*T/Q_ELECTRON


def calage_3_points(points: list[tuple[float, float]], T: float = 298.15) -> dict:
    """Calage exact de V = A ln(I) + B + Rs I sur 3 points (V, I) ; renvoie n, Is, Rs, A, B.

    Même méthode que fitShockley3Points : différences (B disparaît), Cramer, puis B."""
    (V1, I1), (V2, I2), (V3, I3) = sorted(points, key=lambda p: p[1])
    L21, L32 = math.log(I2/I1), math.log(I3/I2)
    D21, D32 = I2 - I1, I3 - I2
    det = L21*D32 - L32*D21
    A = ((V2 - V1)*D32 - (V3 - V2)*D21)/det
    Rs = (L21*(V3 - V2) - L32*(V2 - V1))/det
    B = V1 - A*math.log(I1) - Rs*I1
    return {"n": A/tension_thermique(T), "Is": math.exp(-B/A), "Rs": Rs, "A": A, "B": B}


def tension_calage(I: float, c: dict) -> float:
    """Tension donnée par le calage (sans fuite ni effet de température)."""
    return c["A"]*math.log(I) + c["B"] + c["Rs"]*I


# ---------------------------------------------------------------------------
# Interpolations (mêmes règles que les fonctions Modelica de la bibliothèque)
# ---------------------------------------------------------------------------
def intensite_relative(table: list[tuple[float, float]], I: float, loglog: bool = True) -> float:
    """Comme Functions.relativeIntensity : log-log, proportionnelle sous la table."""
    if I <= 0:
        return 0.0
    if I <= table[0][0]:
        return table[0][1]*I/table[0][0]
    j = 1
    while j < len(table) - 1 and I > table[j][0]:
        j += 1
    (x0, y0), (x1, y1) = table[j - 1], table[j]
    if loglog:
        s = math.log(y1/y0)/math.log(x1/x0)
        return y0*(I/x0)**s
    return y0 + (y1 - y0)*(I - x0)/(x1 - x0)


def interpolation_bornee(table: list[tuple[float, float]], x: float) -> float:
    """Comme Functions.interpolateClamped."""
    if x <= table[0][0]:
        return table[0][1]
    if x >= table[-1][0]:
        return table[-1][1]
    j = 1
    while x > table[j][0]:
        j += 1
    (x0, y0), (x1, y1) = table[j - 1], table[j]
    return y0 + (y1 - y0)*(x - x0)/(x1 - x0)


# ---------------------------------------------------------------------------
# Photométrie : sensibilité de l'œil V(lambda) et LER
# ---------------------------------------------------------------------------
def _gauss_par_morceaux(x: float, mu: float, s1: float, s2: float) -> float:
    s = s1 if x < mu else s2
    return math.exp(-0.5*((x - mu)/s)**2)


def V_lambda(lam_nm: float) -> float:
    """Approximation analytique de la fonction d'efficacité lumineuse photopique V(lambda).

    Fonction y-barre de Wyman, Sloan et Shirley, « Simple Analytic Approximations to
    the CIE XYZ Color Matching Functions », Journal of Computer Graphics Techniques,
    vol. 2, n° 2, 2013 (somme de deux gaussiennes par morceaux). Ce n'est PAS la table
    officielle de la CIE : voir controle_V_lambda() pour l'écart."""
    return (0.821*_gauss_par_morceaux(lam_nm, 568.8, 46.9, 40.5)
            + 0.286*_gauss_par_morceaux(lam_nm, 530.9, 16.3, 31.1))


# Quelques valeurs de la table CIE 1924 de V(lambda), pour contrôler l'approximation
V_CIE = {450: 0.038, 500: 0.323, 510: 0.503, 555: 1.000, 600: 0.631, 650: 0.107, 700: 0.0041}


def controle_V_lambda() -> list[tuple[int, float, float]]:
    return [(lam, V_CIE[lam], V_lambda(lam)) for lam in sorted(V_CIE)]


def LER(spectre: list[tuple[float, float]]) -> float:
    """Efficacité lumineuse du rayonnement (lm/W) d'un spectre relatif [(lambda nm, S)].

    LER = 683 * integrale(S V) / integrale(S) (méthode des trapèzes, pas quelconque)."""
    num = den = 0.0
    for (l0, s0), (l1, s1) in zip(spectre, spectre[1:]):
        dl = l1 - l0
        num += 0.5*(s0*V_lambda(l0) + s1*V_lambda(l1))*dl
        den += 0.5*(s0 + s1)*dl
    return KM*num/den


# Spectres relatifs extraits des tracés vectoriels des datasheets (pdftocairo -svg, puis
# coordonnées des courbes ramenées aux axes ; erreur de lecture négligeable).
# Échantillonnage : 380 à 780 nm par pas de 5 nm (valeurs négatives des bords mises à 0).
SPECTRES = {
    # DS55 Rev. B, Fig. 9 p. 14 : blanc froid 6500 K, IRC 80 (seule variante froide tracée)
    "DS55 6500 K": [(380 + 5*k, s) for k, s in enumerate([
        0, 0, 0, 0, 0, 0, 0.005, 0.017, 0.046, 0.105, 0.206, 0.382, 0.691, 0.978,
        0.841, 0.525, 0.379, 0.281, 0.203, 0.178, 0.191, 0.218, 0.253, 0.302, 0.335,
        0.356, 0.377, 0.389, 0.396, 0.396, 0.411, 0.417, 0.423, 0.434, 0.43, 0.437,
        0.435, 0.437, 0.43, 0.424, 0.418, 0.412, 0.397, 0.387, 0.376, 0.357, 0.345,
        0.325, 0.306, 0.281, 0.26, 0.239, 0.22, 0.195, 0.177, 0.158, 0.139, 0.123,
        0.106, 0.092, 0.083, 0.069, 0.059, 0.053, 0.043, 0.037, 0.033, 0.022, 0.021,
        0.016, 0.016, 0.011, 0.007, 0.008, 0.005, 0.003, 0.002, 0, 0, 0, 0])],
    # DS242 Rev. F, Fig. 9 p. 17 : blanc chaud 3000 K, IRC 90
    "DS242 3000 K": [(380 + 5*k, s) for k, s in enumerate([
        0.004, 0.002, 0.004, 0.004, 0.004, 0.006, 0.011, 0.019, 0.032, 0.055, 0.09,
        0.14, 0.221, 0.331, 0.427, 0.413, 0.348, 0.312, 0.277, 0.25, 0.252, 0.271,
        0.304, 0.346, 0.394, 0.436, 0.475, 0.511, 0.539, 0.567, 0.595, 0.618, 0.641,
        0.659, 0.681, 0.703, 0.725, 0.749, 0.769, 0.789, 0.812, 0.843, 0.872, 0.899,
        0.922, 0.943, 0.963, 0.983, 0.992, 0.996, 0.984, 0.965, 0.939, 0.905, 0.865,
        0.821, 0.769, 0.716, 0.656, 0.596, 0.544, 0.488, 0.44, 0.391, 0.346, 0.305,
        0.266, 0.233, 0.203, 0.175, 0.152, 0.132, 0.115, 0.098, 0.085, 0.073, 0.063,
        0.053, 0.046, 0.039, 0.032])],
    # DS394 (20231206), Fig. 2 p. 5 : LUXEON FX2-L Plus Cool White (5850 K), monopulse, 85 °C
    "DS394 5850 K": [(380 + 5*k, s) for k, s in enumerate([
        0.012, 0.01, 0.009, 0.011, 0.017, 0.033, 0.07, 0.153, 0.312, 0.558, 0.835,
        0.98, 0.809, 0.503, 0.275, 0.147, 0.084, 0.052, 0.036, 0.028, 0.028, 0.031,
        0.045, 0.068, 0.106, 0.156, 0.215, 0.274, 0.33, 0.367, 0.4, 0.418, 0.426,
        0.43, 0.433, 0.429, 0.424, 0.419, 0.41, 0.398, 0.389, 0.374, 0.356, 0.34,
        0.32, 0.297, 0.278, 0.258, 0.237, 0.216, 0.198, 0.179, 0.161, 0.145, 0.13,
        0.115, 0.103, 0.091, 0.081, 0.072, 0.064, 0.057, 0.05, 0.044, 0.039, 0.034,
        0.03, 0.027, 0.024, 0.021, 0.018, 0.016, 0.014, 0.013, 0.011, 0.01, 0.008,
        0.007, 0.007, 0.005, 0.005])],
}


# ---------------------------------------------------------------------------
# Thermique
# ---------------------------------------------------------------------------
def decalage_Tsp_Tj(Rth_j_sp: float, P: float) -> float:
    """Écart Tj - Tsp (K) : Rth j-sp (K/W) multipliée par la puissance de sa définition (W)."""
    return Rth_j_sp*P


# ---------------------------------------------------------------------------
def main() -> int:
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    from references_cas_usage import LEDS

    print("Contrôle de l'approximation de V(lambda) (Wyman, Sloan, Shirley 2013) :")
    for lam, cie, approx in controle_V_lambda():
        print(f"   {lam} nm : CIE {cie:.4f}  approximation {approx:.4f}  écart {approx - cie:+.4f}")
    print()
    print("LER des spectres des datasheets (V(lambda) approchée) :")
    for nom, spectre in SPECTRES.items():
        print(f"   {nom:13} : LER = {LER(spectre):.1f} lm/W")
    print()
    print("Calage exact sur les 3 points de calage I-V de chaque LED :")
    for led in LEDS:
        pts = [p for p in led["points"] if p["grandeur"] == "Vf" and p["role"] == "calage"]
        if len(pts) != 3 or len({p["T"] for p in pts}) != 1:
            print(f"   {led['nom']:7} : pas exactement 3 points de calage à une même température")
            continue
        T = pts[0]["T"] + 273.15
        c = calage_3_points([(p["valeur"], p["I"]) for p in pts], T)
        autres = [p for p in led["points"] if p["grandeur"] == "Vf" and p["T"] == pts[0]["T"]
                  and p["source"] == pts[0]["source"]]
        ecart = max(abs(tension_calage(p["I"], c) - p["valeur"]) for p in autres)
        print(f"   {led['nom']:7} ({pts[0]['T']:.0f} °C) : n = {c['n']:.4f}  Is = {c['Is']:.4e} A  "
              f"Rs = {c['Rs']:.4f} Ohm ; écart max sur la courbe ({len(autres)} points) "
              f"{ecart*1e3:.1f} mV")
    return 0


if __name__ == "__main__":
    sys.exit(main())
