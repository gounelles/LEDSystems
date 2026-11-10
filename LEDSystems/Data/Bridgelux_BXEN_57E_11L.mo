within LEDSystems.Data;
record Bridgelux_BXEN_57E_11L
  "LED blanc froid Bridgelux SMD 2835 0,2 W 3 V BXEN-57E-11L-3A (5700 K, IRC 80) : spot solaire"

  // Source : Bridgelux, « SMD 2835 0.2W 3V Product Data Sheet DS55 », Rev. B (07/2016).
  // Les pages citées sont les pages imprimées du document.
  // Seules les données de CALAGE sont ici ; les points de validation sont dans
  // outils/references_cas_usage.py (ils ne doivent pas entrer dans ce record).
  //
  // Conditions de mesure du datasheet :
  //  - Tab. 1 : courant pulsé, Tj = Tsp = 25 °C ;
  //  - Fig. 2 et Fig. 3 : « Tsp = 25 °C », mode non précisé. HYPOTHÈSE : pulsé
  //    (Tj = 25 °C), comme la Tab. 1. En continu, la jonction serait au plus 7,4 K
  //    au-dessus de Tsp (à 80 mA) : au plus -14 mV sur Vf et -1 % sur le flux ;
  //  - Fig. 4 et Tab. 2 : courant continu, en fonction de Tsp (point de soudure) :
  //    Tj = Tsp + Rth j-sp x P_elec = Tsp + 29 x 3,1 x 0,060 = Tsp + 5,4 K à 60 mA.

  extends LEDData(
    // ==========================================================
    // 1) VALEURS DE BASE (Tab. 1 p. 3, pulsé, Tj = 25 °C)
    // ==========================================================
    colorName = "Cool white 5700 K",
    Vf_typ = 3.1,
    If_typ = 60e-3,

    // ============================================================
    // 2) MODÈLE ÉLECTRIQUE : Shockley + Rs, calé sur 3 points de la Fig. 2 p. 10
    //    (supposée pulsée, Tj = 25 °C : voir en tête)
    // ============================================================
    /* La courbe If = f(Vf) du datasheet ne couvre que 10 à 80 mA. Elle est presque
       droite (la résistance série domine) : en dessous de 10 mA, le modèle extrapole
       (non validé). Calage exact : n = 2,51 ; Rs = 6,0 Ohm. */
    Tj_refIV = 298.15,
    V1_fit = 2.68,
    I1_fit = 9.9e-3,
    V2_fit = 2.90,
    I2_fit = 33.5e-3,
    V3_fit = 3.23,
    I3_fit = 79.3e-3,
    ivCurveModel = LEDSystems.Types.IVCurveModel.ThreePointFit,

    // Variation de Vf avec la température : seul un coefficient est donné (Tab. 4 p. 5)
    vfTemperatureModel = LEDSystems.Types.VfTemperatureModel.Linear,
    TCVf = -1.9e-3,
    Tj_refVf = 298.15,
    // (Vf_T_table : absente du datasheet, non utilisée)

    // =========================================================================
    // 3) THERMIQUE (Tab. 4 p. 5)
    // =========================================================================
    /* Rth j-sp = 29 K/W, jonction -> point de soudure, CALCULÉE PAR BRIDGELUX AVEC LA
       PUISSANCE ÉLECTRIQUE TOTALE (note 4). La chaleur réellement dissipée est plus
       faible (une partie de la puissance part en lumière) : la vraie résistance au sens
       du flux de chaleur est RthJC_heat = 29/(1 - rendement), calculée par LEDData
       (environ 53 K/W). */
    RthJC = 29,
    RthJC_onElectricalPower = true,
    // RthJA : ABSENTE du datasheet : valeur par défaut 0 (« non fournie ») de LEDData.
    // Modéliser la carte avec Thermal.Plate, ou LEDWithPlate avec useDatasheetRth
    // décochée et R_plate.

    // ============================================================
    // 4) ÉMISSION LUMINEUSE
    // ============================================================
    // Le datasheet donne le flux (lm), pas l'intensité : flux typique 26 lm à 60 mA,
    // pulsé, Tj = 25 °C, pour 4000, 5000 et 5700 K (Tab. 1 p. 3).
    photometricInput = LEDSystems.Types.PhotometricInput.LuminousFlux,
    Phi_nom = 26,
    If_nom = 60e-3,
    Tj_refLight = 298.15,

    // Angle de vue 2 x phi_half = 120° (Fig. 7 p. 13)
    phi_half = Modelica.Units.Conversions.from_deg(60),

    /* LER : absente du datasheet. Calculée (outils/calculs_reference.py) à partir du
       spectre de la Fig. 9 p. 14 : 309 lm/W. ATTENTION : la Fig. 9 ne donne que la
       variante blanc froid 6500 K (pas 5700 K) ; à 4000 K et 3000 K, la LER vaut environ
       330 lm/W : à 5700 K, la vraie valeur est probablement un peu plus élevée
       (environ 315 lm/W). Incertitude de la courbe elle-même : environ +/- 3 %.
       Rendement qui en découle à 60 mA : 140 lm/W / 309 lm/W = 0,45 (Tab. 1 : 140 lm/W). */
    LER = 309,

    // --- Fig. 3 p. 10 : flux relatif = f(If), normalisé à 60 mA, Tj = 25 °C (supposée pulsée) ---
    /* Points de calage seulement (les autres servent à la validation). La courbe ne
       commence qu'à 10 mA : en dessous, le flux est pris proportionnel au courant.
       Le fabricant déconseille les faibles courants (« résultats imprévisibles »). */
    useLogLogInterpolation = true,
    IvRel_If_table = [10e-3, 0.19; 20e-3, 0.363; 30e-3, 0.532; 50e-3, 0.852;
                      60e-3, 1.001; 79e-3, 1.264],

    // --- Fig. 4 p. 11 : flux relatif = f(Tsp), courant continu 60 mA ---
    /* L'axe du datasheet est Tsp ; le modèle utilise Tj. Les abscisses ci-dessous sont
       donc décalées de +5,4 K (Tj = Tsp + 5,4 K à 60 mA ; ce décalage dépend en réalité
       du courant : approximation). Points de calage : Tsp = 17, 30, 52, 72, 85, 105 °C.
       Aucune donnée sous Tsp = 17 °C : par temps froid, la valeur à 22,4 °C est
       maintenue (extrapolation, non validée). */
    lightTemperatureModel = LEDSystems.Types.LightTemperatureModel.Table,
    IvRel_T_table = [22.4, 1.000; 35.4, 0.984; 57.4, 0.949; 77.4, 0.915; 90.4, 0.892;
                     110.4, 0.854],
    T_minTable = 295.55, // 22,4 °C
    T_maxTable = 383.55  // 110,4 °C
  );

  annotation (Documentation(info = "<html>
<p><b>Bridgelux SMD 2835 0,2 W 3 V, BXEN-57E-11L-3A</b> (blanc froid 5700 K, IRC 80) :
données du datasheet DS55 Rev. B (07/2016). LED moyenne puissance typique des
projecteurs solaires.</p>
<p>Dispersion de fabrication (pour <code>LEDMatrix</code> et <code>Functions.dispersion</code>) :
Vf de 2,8 à 3,4&nbsp;V à 60&nbsp;mA (6 classes de 0,1&nbsp;V, Tab. 7) ; flux de 22 à 32&nbsp;lm
à 60&nbsp;mA (5 classes, Tab. 6).</p>
<p>Limites : courbes de 10 à 80&nbsp;mA et de Tsp = 17 à 105&nbsp;°C seulement ; LER
calculée sur le spectre 6500&nbsp;K ; RthJA absente.</p>
</html>"));
end Bridgelux_BXEN_57E_11L;
