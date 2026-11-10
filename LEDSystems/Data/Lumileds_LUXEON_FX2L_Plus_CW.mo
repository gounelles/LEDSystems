within LEDSystems.Data;
record Lumileds_LUXEON_FX2L_Plus_CW
  "LED blanc froid Lumileds LUXEON FX2-L Plus Cool White A1F2-5850F3C003800 (1 puce) : phare automobile"

  // Source : Lumileds, « LUXEON FX2-L Plus Cool White Product Datasheet DS394 » (20231206).
  // Les pages citées sont les pages imprimées du document.
  // Seules les données de CALAGE sont ici ; les points de validation sont dans
  // outils/references_cas_usage.py (ils ne doivent pas entrer dans ce record).
  //
  // Conditions de mesure : toutes les données en MONOPULSE (MP, impulsion de 1 ms, p. 2) :
  // la jonction ne chauffe pas, Tj = température de la platine de mesure.
  // Conditions de tri (« binning ») : 1000 mA, 85 °C. LED « automobile » : les valeurs de
  // référence sont à 85 °C (et non 25 °C), proche du fonctionnement réel dans un phare.

  extends LEDData(
    // ==========================================================
    // 1) VALEURS DE BASE (Tab. 3 p. 3, MP, 1000 mA, Tj = 85 °C)
    // ==========================================================
    colorName = "Cool white 5850 K",
    Vf_typ = 3.11,
    If_typ = 1.0,

    // ============================================================
    // 2) MODÈLE ÉLECTRIQUE : Shockley + Rs, calé à 85 °C sur 3 points de la Fig. 5 p. 6
    // ============================================================
    /* Courbe à 85 °C, de 50 mA (courant minimal autorisé, Tab. 4) à 1500 mA (maximal).
       Calage exact : n = 1,98 ; Rs = 0,29 Ohm. La courbe à 25 °C de la même figure
       n'entre pas dans le calage : elle sert à valider la correction en température. */
    Tj_refIV = 358.15,
    V1_fit = 2.710,
    I1_fit = 0.1,
    V2_fit = 2.923,
    I2_fit = 0.5,
    V3_fit = 3.277,
    I3_fit = 1.5,
    ivCurveModel = LEDSystems.Types.IVCurveModel.ThreePointFit,

    // Variation de Vf avec la température : courbe ΔVf = f(Tj) de la Fig. 6 p. 7 (MP, 1000 mA),
    // non linéaire (-3,8 mV/K vers 0 °C, -1,9 mV/K vers 120 °C) : table plutôt que coefficient.
    vfTemperatureModel = LEDSystems.Types.VfTemperatureModel.Table,
    Tj_refVf = 358.15,
    Vf_T_table = [
    //  T (°C), ΔVf (V) : décalage par rapport à 85 °C (lu sur la Fig. 6 par pas de 10 °C)
       -40, 0.421;
       -30, 0.373;
       -20, 0.329;
       -10, 0.286;
         0, 0.247;
        10, 0.210;
        20, 0.176;
        30, 0.144;
        40, 0.114;
        50, 0.086;
        60, 0.060;
        70, 0.035;
        80, 0.011;
        90, -0.011;
       100, -0.033;
       110, -0.054;
       120, -0.073;
       130, -0.093;
       140, -0.111;
       150, -0.129],

    // =========================================================================
    // 3) THERMIQUE (Tab. 3 p. 3)
    // =========================================================================
    /* Lumileds donne les deux définitions de la résistance jonction - boîtier :
        - « électrique » Rθj-c el = 3,3 K/W (rapportée à la puissance électrique) ;
        - « réelle » Rθj-c real = 5,6 K/W (rapportée à la chaleur dissipée, la lumière émise
          étant retranchée).
       Le modèle fait passer la chaleur Qth = P_elec - P_opt : on prend la valeur réelle. */
    RthJC = 5.6,
    RthJC_onElectricalPower = false,
    // RthJA : sans objet (dépend entièrement de la carte et du radiateur du phare) :
    // valeur par défaut 0 (« non fournie ») de LEDData.

    // ============================================================
    // 4) ÉMISSION LUMINEUSE
    // ============================================================
    /* Le datasheet ne donne que le flux MINIMAL de chaque référence (Tab. 1 p. 3) :
       380 lm à 1000 mA, MP, 85 °C pour la ...003800. Pas de valeur typique : le modèle
       représente une LED en limite basse de sa classe de flux. */
    photometricInput = LEDSystems.Types.PhotometricInput.LuminousFlux,
    Phi_nom = 380,
    If_nom = 1.0,
    Tj_refLight = 358.15,

    // Angle de vue 2 x phi_half = 120° (Tab. 2 p. 3)
    phi_half = Modelica.Units.Conversions.from_deg(60),

    /* LER : absente du datasheet. Calculée (outils/calculs_reference.py) à partir du
       spectre de la Fig. 2 p. 5 : 313 lm/W. Rendement qui en découle à 1000 mA, 85 °C :
       380 lm / 313 lm/W / (3,11 V x 1 A) = 0,39. */
    LER = 313.1,

    // --- Fig. 4 p. 6 : flux relatif = f(If), normalisé à 1000 mA, MP, Tj = 85 °C ---
    /* Points de calage seulement (les autres, et la courbe à 25 °C, servent à la
       validation). Fléchissement aux forts courants : +50 % de courant (1000 -> 1500 mA)
       ne donne que +39,5 % de flux. */
    useLogLogInterpolation = true,
    IvRel_If_table = [0.05, 0.060; 0.2, 0.238; 0.5, 0.551; 1.0, 1.000; 1.5, 1.395],

    // --- Fig. 3 p. 5 : flux relatif = f(Tj), normalisé à 85 °C, MP, 1000 mA ---
    /* Non monotone : maximum vers 50 °C (+2 %), puis baisse rapide au-delà de 100 °C.
       Points de calage : -40, 0, 25, 50, 85, 125 et 150 °C. */
    lightTemperatureModel = LEDSystems.Types.LightTemperatureModel.Table,
    IvRel_T_table = [-40, 0.961; 0, 1.000; 25, 1.015; 50, 1.021; 85, 1.000; 125, 0.919;
                     150, 0.841],
    T_minTable = 233.15, // -40 °C
    T_maxTable = 423.15  // 150 °C
  );

  annotation (Documentation(info = "<html>
<p><b>Lumileds LUXEON FX2-L Plus Cool White, A1F2-5850F3C003800</b> (blanc froid 5850&nbsp;K,
une puce, boîtier céramique AlN) : données du datasheet DS394 (20231206). LED de puissance
pour l'éclairage avant automobile (feux de croisement et de route, feux de jour,
antibrouillard), qualifiée AEC-Q102.</p>
<p>Particularité : toutes les valeurs de référence sont données à <b>85&nbsp;°C</b> (tri à
chaud), en monopulse. Limites : 50 à 1500&nbsp;mA en continu, Tj&nbsp;&le;&nbsp;150&nbsp;°C
(180&nbsp;°C moins de 200&nbsp;h), boîtier de &minus;40 à 135&nbsp;°C (Tab. 4).</p>
<p>Dispersion de fabrication (pour <code>LEDMatrix</code> et <code>Functions.dispersion</code>) :
Vf de 2,90 à 3,35&nbsp;V à 1000&nbsp;mA, 85&nbsp;°C (Tab. 3) ; flux de 380 à 390&nbsp;lm pour
la classe R de cette référence (Tab. 5 : classes de 10&nbsp;lm de 350 à 420&nbsp;lm).</p>
</html>"));
end Lumileds_LUXEON_FX2L_Plus_CW;
