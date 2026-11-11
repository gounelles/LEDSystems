# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Stéphane Gounelle
# This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
# If a copy of the MPL was not distributed with this file, You can obtain one at
# https://mozilla.org/MPL/2.0/.
"""Références datasheet des cas d'usage, utilisées par tester_cas_usage.py.

=============================================================================
RÈGLE ABSOLUE : ces valeurs viennent des DATASHEETS, pas du modèle.
Ne jamais les modifier, ni élargir les tolérances, pour faire passer un test.
Si une référence semble fausse, il faut la revérifier sur le datasheet.
=============================================================================

Les datasheets eux-mêmes (PDF) sont dans datasheets/, exclu de Git (droit d'auteur).
Les courbes de ces trois datasheets sont vectorielles : les points ont été extraits
des tracés (erreur de lecture négligeable devant la tolérance du datasheet).

Chaque point a un rôle :
  - "calage"     : la valeur sert aussi à paramétrer le record (le test vérifie
                   seulement que le modèle reproduit ses données d'entrée) ;
  - "validation" : la valeur n'entre PAS dans le record (vraie validation).

Températures : "T" en °C ; "T_mesuree" indique OÙ cette température est mesurée
(rien à voir avec les températures de référence du record, Tj_refIV, Tj_refLight) :
  - "jonction" : T est la température de jonction Tj (en particulier, mesure pulsée
                 sur carte thermostatée : la jonction ne chauffe pas, Tj = Tsp) ;
  - "soudure"  : T est la température du point de soudure Tsp, mesurée en continu ;
                 le banc impose Tj = T + "decalage_Tsp_Tj" (en K, fixé avec le record).
                 Un tel point n'est testé qu'une fois ce décalage fixé.

Écart probable du datasheet : un point peut porter "ecart_datasheet" (texte court).
Ce marquage est posé sur une PLAGE de points, d'après l'analyse du datasheet (données
contradictoires entre deux figures ou tableaux), jamais d'après le résultat du test.
Un tel point est toujours simulé, affiché avec son écart réel et compté dans le bilan ;
s'il sort de la tolérance, il est signalé « ÉCART DS » au lieu de « ÉCHEC » et ne fait
pas échouer le code de retour. Valeur et tolérance restent celles du datasheet.

Grandeurs : "Vf" (V, tension d'une LED), "Phi_v" (lm), "Iv" (cd).
Tolérances : ("abs", valeur) en unité de la grandeur, ou ("rel", fraction).
"""

# ---------------------------------------------------------------------------
# Outils de saisie
# ---------------------------------------------------------------------------
def _p(grandeur, I, valeur, role, source, T=25.0, T_mesuree="jonction",
       ecart_datasheet=None):
    return {"grandeur": grandeur, "I": I, "valeur": valeur, "role": role,
            "source": source, "T": T, "T_mesuree": T_mesuree,
            "ecart_datasheet": ecart_datasheet}


def _serie(grandeur, couples, roles, source, echelle=1.0, **kw):
    """couples : [(I en A, valeur)] ; roles : ensemble des courants (A) de calage."""
    return [_p(grandeur, I, v*echelle, "calage" if I in roles else "validation",
               source, **kw) for I, v in couples]


LEDS = []

# ---------------------------------------------------------------------------
# Vishay VLMW41S1T1 : contrôle de l'outil (mêmes points que tester_datasheet.py)
# ---------------------------------------------------------------------------
LEDS.append({
    "nom": "Vishay",
    "record": "Vishay_VLMW41S1T1",
    "titre": "Vishay VLMW41S1T1-5K8L-08 (contrôle de l'outil, = tester_datasheet.py)",
    "decalage_Tsp_Tj": 0.0,
    "tolerances": {"Vf": ("rel", 0.03), "Iv": ("rel", 0.15)},
    "banc": {"I_max": 0.12, "intervalle": 0.0005},
    "points":
        _serie("Vf", [(1e-3, 2.75), (20e-3, 3.30), (100e-3, 4.50)],
               {1e-3, 20e-3, 100e-3}, "Fig. 4")
        + _serie("Iv", [(1e-3, 0.12), (3e-3, 0.25), (10e-3, 1.00), (30e-3, 2.20),
                        (100e-3, 6.50)],
                 {1e-3, 3e-3, 10e-3, 30e-3, 100e-3}, "Fig. 5", echelle=0.275),
})

# ---------------------------------------------------------------------------
# Spot solaire : Bridgelux SMD 2835 0,2 W 3 V, BXEN-57E-11L-3A (DS55 Rev. B, 07/2016)
# ---------------------------------------------------------------------------
_PHI_DS55 = 26.0  # lm, 60 mA, pulsé, Tj = Tsp = 25 °C, 5700 K (Tab. 1 p. 3)
LEDS.append({
    "nom": "DS55",
    "record": "Bridgelux_BXEN_57E_11L",
    "titre": "Bridgelux SMD 2835 0,2 W 3 V BXEN-57E-11L-3A (DS55 Rev. B) - spot solaire",
    # Fig. 4 et Tab. 2 (continu, axe Tsp) : Tj = Tsp + Rth j-sp x P_elec
    # = Tsp + 29 K/W x 3,1 V x 0,060 A = Tsp + 5,4 K à 60 mA
    "decalage_Tsp_Tj": 5.4,
    "tolerances": {"Vf": ("abs", 0.1), "Phi_v": ("rel", 0.075)},
    "points":
        # If = f(Vf), Fig. 2 p. 10, « Tsp = 25 °C », mode non précisé.
        # HYPOTHÈSE : mesure pulsée (Tj = Tsp = 25 °C), pratique courante des fabricants.
        # Non démontrable : en continu, Tj - Tsp = Rth j-sp x P vaudrait 0,8 K à 10 mA et
        # 7,4 K à 80 mA, soit au plus -14 mV sur Vf et -1 % sur le flux, sous les arrondis
        # de la Tab. 1 et très en deçà des tolérances (±0,1 V, ±7,5 %).
        [_p("Vf", I, V, "calage" if I in (9.9e-3, 33.5e-3, 79.3e-3) else "validation",
            "Fig. 2 p. 10", T=25.0, T_mesuree="jonction")
         for V, I in [(2.68, 9.9e-3), (2.70, 12.0e-3), (2.75, 16.9e-3), (2.80, 22.1e-3),
                      (2.85, 27.6e-3), (2.90, 33.5e-3), (2.95, 39.6e-3), (3.00, 46.0e-3),
                      (3.05, 52.7e-3), (3.10, 59.8e-3), (3.15, 67.0e-3), (3.20, 74.6e-3),
                      (3.23, 79.3e-3)]]
        # Vf typique, Tab. 3 p. 4, Tsp = 25 °C, mode non précisé : même hypothèse (pulsé)
        # (valeurs arrondies à 0,1 V)
        + _serie("Vf", [(20e-3, 2.8), (30e-3, 2.9), (40e-3, 2.9), (60e-3, 3.1), (80e-3, 3.2)],
                 set(), "Tab. 3 p. 4", T=25.0, T_mesuree="jonction")
        # Flux relatif = f(If), Fig. 3 p. 10, normalisé à 60 mA, Tsp = 25 °C, mode non
        # précisé : même hypothèse (pulsé, Tj = 25 °C)
        + _serie("Phi_v", [(10e-3, 0.19), (15e-3, 0.275), (20e-3, 0.363), (25e-3, 0.45),
                           (30e-3, 0.532), (40e-3, 0.694), (50e-3, 0.852), (60e-3, 1.001),
                           (70e-3, 1.143), (79e-3, 1.264)],
                 {10e-3, 20e-3, 30e-3, 50e-3, 60e-3, 79e-3}, "Fig. 3 p. 10",
                 echelle=_PHI_DS55, T=25.0, T_mesuree="jonction")
        # Flux typique 4000 K (5700 K identique à 60 mA), Tab. 3 p. 4, pulsé, Tsp = 25 °C
        + _serie("Phi_v", [(20e-3, 10), (30e-3, 14), (40e-3, 18), (60e-3, 26), (80e-3, 34)],
                 set(), "Tab. 3 p. 4", T=25.0, T_mesuree="jonction")
        # Flux relatif = f(Tsp), Fig. 4 p. 11, continu, 60 mA (normalisé au point pulsé 25 °C)
        + [_p("Phi_v", 60e-3, r*_PHI_DS55,
              "calage" if T in (17, 30, 52, 72, 85, 105) else "validation",
              "Fig. 4 p. 11", T=float(T), T_mesuree="soudure")
           for T, r in [(17, 1.00), (20, 0.997), (30, 0.984), (40, 0.967), (52, 0.949),
                        (60, 0.935), (72, 0.915), (85, 0.892), (95, 0.873), (105, 0.854)]]
        # Flux continu à Tsp = 85 °C, 60 mA, 5700 K (Tab. 2 p. 3)
        + [_p("Phi_v", 60e-3, 23.0, "validation", "Tab. 2 p. 3", T=85.0, T_mesuree="soudure")],
})

# ---------------------------------------------------------------------------
# Lampe domestique : Bridgelux SMD 2835 0,5 W 3 V, BXEN-30G-11M-3C (DS242 Rev. F, 04/2024)
# ---------------------------------------------------------------------------
_PHI_DS242 = 61.0  # lm, 150 mA, pulsé, Tsp = 25 °C, 3000 K (Tab. 1 p. 3)
LEDS.append({
    "nom": "DS242",
    "record": "Bridgelux_BXEN_30G_11M",
    "titre": "Bridgelux SMD 2835 0,5 W 3 V BXEN-30G-11M-3C (DS242 Rev. F) - lampe domestique",
    # Toutes les données sont supposées pulsées (Tj = Tsp), Fig. 4 comprise : la Tab. 2,
    # explicitement pulsée (55/61 = 0,902 à 85 °C), concorde avec la Fig. 4 lue en pulsé
    # (0,897) et non en continu (Tj = Tsp + 10,8 K : 0,917).
    "decalage_Tsp_Tj": 0.0,
    "tolerances": {"Vf": ("abs", 0.1), "Phi_v": ("rel", 0.075)},
    "points":
        # If = f(Vf), Fig. 2 p. 13, « Tsp = 25 °C », mode non précisé.
        # HYPOTHÈSE : mesure pulsée (Tj = 25 °C), comme les Tab. 1 à 4. Indice : à 150 mA,
        # Fig. 2 (3,000 V) = Tab. 3 (3,00 V, pulsé) ; en continu, la Fig. 2 lirait ~15 mV
        # de moins. Si l'hypothèse est fausse : au plus +25 mV (240 mA), dans ±0,1 V.
        _serie("Vf", [(10e-3, 2.663), (30e-3, 2.736), (60e-3, 2.813), (90e-3, 2.881),
                      (120e-3, 2.942), (150e-3, 3.000), (180e-3, 3.056), (210e-3, 3.109),
                      (240e-3, 3.171)],
               {10e-3, 90e-3, 240e-3}, "Fig. 2 p. 13", T=25.0, T_mesuree="jonction")
        # Vf typique, Tab. 3 p. 5, pulsé stabilisé, Tsp = 25 °C (écart à la Fig. 2 : -46 mV à 30 mA)
        + _serie("Vf", [(30e-3, 2.69), (42e-3, 2.74), (60e-3, 2.78), (90e-3, 2.86),
                        (120e-3, 2.93), (150e-3, 3.00)],
                 set(), "Tab. 3 p. 5", T=25.0, T_mesuree="jonction")
        # Flux relatif = f(If), Fig. 3 p. 13, normalisé à 150 mA, Tsp = 25 °C, mode non
        # précisé : même hypothèse (pulsé, Tj = 25 °C)
        + _serie("Phi_v", [(10e-3, 7.2), (30e-3, 21.7), (60e-3, 42.5), (90e-3, 62.6),
                           (120e-3, 81.7), (150e-3, 100.0), (180e-3, 117.1), (210e-3, 134.2),
                           (240e-3, 152.2)],
                 {10e-3, 30e-3, 90e-3, 150e-3, 240e-3}, "Fig. 3 p. 13",
                 echelle=_PHI_DS242/100, T=25.0, T_mesuree="jonction")
        # Flux 30G, Tab. 3 p. 5, pulsé, Tsp = 25 °C et 85 °C.
        # INCOHÉRENCE DU DATASHEET : à 85 °C, de 42 à 120 mA, le rapport
        # Phi(85 °C)/Phi(25 °C) vaut environ 0,83, contre 0,90 à 150 mA (= Tab. 2 et
        # Fig. 4) ; même motif pour les autres teintes de la Tab. 3. Le modèle suit la
        # Fig. 4. Points de 42 à 120 mA à 85 °C marqués « écart probable du datasheet »
        # (décision du 2026-11-09) : valeurs inchangées, écarts toujours affichés.
        # DS242 Rev. F (04/2024) vérifié le 2026-11-09 : c'est la version en ligne chez
        # Bridgelux (fichier identique), sans historique de révision ni erratum. Le
        # DS242-3 (BXEN-..-3C3, Rev. E 11/2024) est un autre produit (Vf typ. 3,1 V).
        + _serie("Phi_v", [(30e-3, 13), (42e-3, 18), (60e-3, 26), (90e-3, 38), (120e-3, 50),
                           (150e-3, 61)], set(), "Tab. 3 p. 5", T=25.0, T_mesuree="jonction")
        + _serie("Phi_v", [(30e-3, 12), (150e-3, 55)], set(), "Tab. 3 p. 5",
                 T=85.0, T_mesuree="jonction")
        + _serie("Phi_v", [(42e-3, 15), (60e-3, 22), (90e-3, 32), (120e-3, 41)], set(),
                 "Tab. 3 p. 5", T=85.0, T_mesuree="jonction",
                 ecart_datasheet="Tab. 3 à 85 °C : Phi(85)/Phi(25) ≈ 0,83, contre 0,90 "
                                 "à 150 mA (Tab. 2, Fig. 4)")
        # Flux relatif = f(Tsp), Fig. 4 p. 14, blanc chaud, normalisé à 25 °C (150 mA supposé),
        # mode non précisé : supposée pulsée (voir decalage_Tsp_Tj)
        + [_p("Phi_v", 150e-3, r*_PHI_DS242/100,
              "calage" if T in (25, 65, 105) else "validation",
              "Fig. 4 p. 14", T=float(T), T_mesuree="jonction")
           for T, r in [(25, 100.0), (45, 96.9), (65, 93.6), (85, 89.7), (105, 85.1)]]
        # Vf et flux à Tsp = 85 °C, 150 mA, pulsé (Tab. 2 p. 3)
        + [_p("Vf", 150e-3, 2.9, "validation", "Tab. 2 p. 3", T=85.0, T_mesuree="jonction"),
           _p("Phi_v", 150e-3, 55.0, "validation", "Tab. 2 p. 3", T=85.0, T_mesuree="jonction")],
})

# ---------------------------------------------------------------------------
# Automobile : Lumileds LUXEON FX2-L Plus Cool White, A1F2-5850F3C003800 (DS394, 20231206)
# Toutes les courbes : monopulse (MP), Tj = Tsp.
# ---------------------------------------------------------------------------
_PHI_FX2 = 380.0  # lm, 1000 mA, MP, 85 °C (minimum de la référence ...003800, Tab. 1 p. 3)
_IV85 = [(50e-3, 2.661), (100e-3, 2.710), (200e-3, 2.783), (350e-3, 2.856), (500e-3, 2.923),
         (700e-3, 3.004), (1000e-3, 3.113), (1200e-3, 3.181), (1500e-3, 3.277)]
_IV25 = [(50e-3, 2.764), (100e-3, 2.817), (200e-3, 2.898), (350e-3, 2.983), (500e-3, 3.059),
         (700e-3, 3.151), (1000e-3, 3.273), (1200e-3, 3.349), (1500e-3, 3.455)]
_PI85 = [(50e-3, 0.060), (100e-3, 0.121), (200e-3, 0.238), (300e-3, 0.347), (500e-3, 0.551),
         (700e-3, 0.738), (1000e-3, 1.000), (1200e-3, 1.164), (1500e-3, 1.395)]
_PI25 = [(50e-3, 0.064), (100e-3, 0.126), (200e-3, 0.245), (300e-3, 0.355), (500e-3, 0.562),
         (700e-3, 0.751), (1000e-3, 1.015), (1200e-3, 1.178), (1500e-3, 1.407)]
_PT = [(-40, 0.961), (-20, 0.983), (0, 1.000), (25, 1.015), (50, 1.021), (70, 1.014),
       (85, 1.000), (100, 0.977), (110, 0.956), (125, 0.919), (135, 0.890), (150, 0.841)]
LEDS.append({
    "nom": "FX2L",
    "record": "Lumileds_LUXEON_FX2L_Plus_CW",
    "titre": "Lumileds LUXEON FX2-L Plus Cool White A1F2-5850F3C003800 (DS394) - phare automobile",
    "decalage_Tsp_Tj": 0.0,  # mesures en monopulse : Tj = Tsp
    "tolerances": {"Vf": ("abs", 0.06), "Phi_v": ("rel", 0.065)},
    "points":
        _serie("Vf", _IV85, {100e-3, 500e-3, 1500e-3}, "Fig. 5 p. 6", T=85.0)
        + _serie("Vf", _IV25, set(), "Fig. 5 p. 6", T=25.0)
        + _serie("Phi_v", _PI85, {50e-3, 200e-3, 500e-3, 1000e-3, 1500e-3}, "Fig. 4 p. 6",
                 echelle=_PHI_FX2, T=85.0)
        + _serie("Phi_v", _PI25, set(), "Fig. 4 p. 6", echelle=_PHI_FX2, T=25.0)
        + [_p("Phi_v", 1.0, r*_PHI_FX2,
              "calage" if T in (-40, 0, 25, 50, 85, 125, 150) else "validation",
              "Fig. 3 p. 5", T=float(T))
           for T, r in _PT],
})
