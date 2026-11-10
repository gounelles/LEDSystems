within LEDSystems.Data;
record Bridgelux_BXEN_30G_11M
  "LED blanc chaud Bridgelux SMD 2835 0,5 W 3 V BXEN-30G-11M-3C (3000 K, IRC 90) : lampe domestique"

  // Source : Bridgelux, « SMD 2835 0.5W 3V Product Data Sheet DS242 », Rev. F (04/2024).
  // Les pages citées sont les pages imprimées du document.
  // Seules les données de CALAGE sont ici ; les points de validation sont dans
  // outils/references_cas_usage.py (ils ne doivent pas entrer dans ce record).
  //
  // Conditions de mesure du datasheet :
  //  - Tab. 1 à 4 : courant pulsé (impulsions de 10 ms), Tj = Tsp ;
  //  - Fig. 2 et Fig. 3 : « Tsp = 25 °C », mode non précisé. HYPOTHÈSE : pulsé
  //    (Tj = 25 °C), comme les tableaux. Indice : à 150 mA, la Fig. 2 (3,000 V) et la
  //    Tab. 3 (3,00 V, pulsé) coïncident ; en continu, la Fig. 2 lirait environ 15 mV de
  //    moins (jonction 11 K au-dessus de Tsp). Effet maximal si l'hypothèse est fausse :
  //    +25 mV sur les 3 points de calage I-V à 240 mA ;
  //  - Fig. 4 : flux relatif en fonction de Tsp, à 150 mA, mode non précisé.
  //    HYPOTHÈSE : pulsé (Tj = Tsp). Indice : la Tab. 2, explicitement pulsée à Tsp = 85 °C,
  //    donne 55/61 = 0,902 (0,894 à 0,910 avec l'arrondi) ; la Fig. 4 lue en pulsé donne
  //    0,897, lue en continu (Tj = Tsp + 10,8 K) 0,917, hors de l'intervalle.
  //  - Incohérence du datasheet : la Tab. 3 à Tsp = 85 °C donne, de 42 à 120 mA, un flux
  //    d'environ 0,83 fois celui à 25 °C, contre 0,90 à 150 mA (Tab. 2, Fig. 4). Aucun
  //    modèle dont le facteur thermique ne dépend que de Tj ne peut suivre les deux : le
  //    modèle suit la Fig. 4 et surestime ces points de 5 à 9 % (validation, non calés) ;
  //    dans le test des cas d'usage, ils sont marqués « écart probable du datasheet ».
  //    Vérifié le 2026-11-09 : la Rev. F est la version en ligne chez Bridgelux (fichier
  //    identique), sans historique de révision ni erratum.

  extends LEDData(
    // ==========================================================
    // 1) VALEURS DE BASE (Tab. 1 p. 3, pulsé, Tj = 25 °C)
    // ==========================================================
    colorName = "Warm white 3000 K, CRI 90",
    Vf_typ = 3.0,
    If_typ = 150e-3,

    // ============================================================
    // 2) MODÈLE ÉLECTRIQUE : Shockley + Rs, calé sur 3 points de la Fig. 2 p. 13
    //    (supposée pulsée, Tj = 25 °C : voir en tête)
    // ============================================================
    /* La courbe couvre 10 à 240 mA (240 mA = courant maximal en continu, Tab. 5).
       Calage exact : n = 1,47 ; Rs = 1,69 Ohm. Sous 10 mA, le modèle extrapole.
       La Tab. 3 donne des Vf plus basses à faible courant (jusqu'à -46 mV à 30 mA,
       identiques à 150 mA) : elle sert de validation secondaire. */
    Tj_refIV = 298.15,
    V1_fit = 2.663,
    I1_fit = 10e-3,
    V2_fit = 2.881,
    I2_fit = 90e-3,
    V3_fit = 3.171,
    I3_fit = 240e-3,
    ivCurveModel = LEDSystems.Types.IVCurveModel.ThreePointFit,

    // Variation de Vf avec la température : seul un coefficient est donné (Tab. 4 p. 6)
    vfTemperatureModel = LEDSystems.Types.VfTemperatureModel.Linear,
    TCVf = -1.35e-3,
    Tj_refVf = 298.15,
    // (Vf_T_table : absente du datasheet, non utilisée)

    // =========================================================================
    // 3) THERMIQUE (Tab. 4 p. 6)
    // =========================================================================
    /* Rth j-sp = 24 K/W, jonction -> point de soudure, CALCULÉE PAR BRIDGELUX AVEC LA
       PUISSANCE ÉLECTRIQUE TOTALE (note 3 de la Tab. 4 : « optical power was not
       subtracted »). La vraie résistance au sens du flux de chaleur est
       RthJC_heat = 24/(1 - rendement), calculée par LEDData (environ 45 K/W). */
    RthJC = 24,
    RthJC_onElectricalPower = true,
    // RthJA : ABSENTE du datasheet : valeur par défaut 0 (« non fournie ») de LEDData.
    // Modéliser la carte avec Thermal.Plate, ou LEDWithPlate avec useDatasheetRth
    // décochée et R_plate.

    // ============================================================
    // 4) ÉMISSION LUMINEUSE
    // ============================================================
    // Flux typique 61 lm à 150 mA, pulsé, Tj = 25 °C, variante 3000 K (Tab. 1 p. 3).
    photometricInput = LEDSystems.Types.PhotometricInput.LuminousFlux,
    Phi_nom = 61,
    If_nom = 150e-3,
    Tj_refLight = 298.15,

    // Angle de vue 2 x phi_half = 120° (Fig. 7 p. 16, note 1)
    phi_half = Modelica.Units.Conversions.from_deg(60),

    /* LER : absente du datasheet. Calculée (outils/calculs_reference.py) à partir du
       spectre 3000 K, IRC 90 de la Fig. 9 p. 17 : 290 lm/W (plus basse qu'un IRC 80 :
       l'IRC 90 demande davantage de rouge profond, peu visible). Incertitude de
       l'approximation de V(lambda) et de la lecture : environ +/- 3 %.
       Rendement qui en découle à 150 mA : 136 lm/W / 290 lm/W = 0,47 (Tab. 1). */
    LER = 290.5,

    // --- Fig. 3 p. 13 : flux relatif = f(If), normalisé à 150 mA, Tj = 25 °C (supposée pulsée) ---
    /* Points de calage seulement (les autres servent à la validation). La courbe
       commence à 10 mA : en dessous, le flux est pris proportionnel au courant. */
    useLogLogInterpolation = true,
    IvRel_If_table = [10e-3, 0.072; 30e-3, 0.217; 90e-3, 0.626; 150e-3, 1.000;
                      240e-3, 1.522],

    // --- Fig. 4 p. 14 : flux relatif = f(Tsp), blanc chaud, 150 mA ---
    /* Supposée pulsée (voir en tête) : Tj = Tsp, abscisses reprises telles quelles.
       Points de calage : Tsp = 25, 65 et 105 °C (45 et 85 °C servent à la validation).
       Hors de 25 à 105 °C, la table est bornée (par temps froid : valeur de 25 °C). */
    lightTemperatureModel = LEDSystems.Types.LightTemperatureModel.Table,
    IvRel_T_table = [25, 1.000; 65, 0.936; 105, 0.851],
    T_minTable = 298.15, // 25 °C
    T_maxTable = 378.15  // 105 °C
  );

  annotation (Documentation(info = "<html>
<p><b>Bridgelux SMD 2835 0,5&nbsp;W 3&nbsp;V, BXEN-30G-11M-3C</b> (blanc chaud 3000&nbsp;K,
IRC 90) : données du datasheet DS242 Rev. F (04/2024). LED moyenne puissance typique
des ampoules et des lampes domestiques.</p>
<p>Dispersion de fabrication (pour <code>LEDMatrix</code> et <code>Functions.dispersion</code>) :
Vf de 2,8 à 3,2&nbsp;V à 150&nbsp;mA (Tab. 1 ; classes de 0,1&nbsp;V de 2,7 à 3,2&nbsp;V,
Tab. 7) ; flux de 35 à 75&nbsp;lm à 150&nbsp;mA (8 classes de 5&nbsp;lm, Tab. 6, toutes
teintes confondues).</p>
<p>Limites : courbes de 10 à 240&nbsp;mA et de Tsp = 25 à 105&nbsp;°C seulement ; RthJA
absente.</p>
</html>"));
end Bridgelux_BXEN_30G_11M;
