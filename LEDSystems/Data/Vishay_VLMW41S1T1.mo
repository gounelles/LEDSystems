within LEDSystems.Data;
record Vishay_VLMW41S1T1
  "LED blanc froid Vishay VLMW41S1T1-5K8L-08 : données électriques, thermiques et photométriques"

  // Traduction des données du datasheet pour paramétrer le modèle de LED.

  extends LEDData(
    // ==========================================================
    // 1) VALEURS DE BASE
    // ==========================================================
    colorName = "Cool white",

    // Valeurs de référence électriques (tableau « PARTS TABLE »)
    // Ex. : Vf typique pour If = 20 mA, Tamb = 25 °C
    Vf_typ = 3.3,
    If_typ = 20e-3,

    // ============================================================
    // 2) MODÈLE ÉLECTRIQUE : Shockley + Rs
    // ============================================================
    /*
      Modèle :
        i = Is * ( exp( (v - i*Rs) / (n*Vt) ) - 1 )
        avec Vt = k*T/q

      Où :
        - Is : courant de saturation (A)
        - n  : facteur d'idéalité (-)
        - Rs : résistance série (Ohm)
        - T  : température de jonction (K), celle du heatPort de la LED

      Démarche :
        - saisir 3 points (V, I) lus sur la courbe If = f(Vf) du datasheet (Fig. 4)
        - le modèle en déduit Is, n et Rs par un calcul exact (fonction
          Functions.fitShockley3Points) : il repasse par les 3 points
    */

    Tj_refIV = 298.15, // 25 °C

    // --- 3 points de calage, Fig. 4 : If = f(Vf) ---
    V1_fit = 2.75,
    I1_fit = 1e-3,
    V2_fit = 3.30,
    I2_fit = 20e-3,
    V3_fit = 4.50,
    I3_fit = 100e-3,

    // --- Paramètres de Shockley à Tj_refIV (calculés par ailleurs, ou à fournir)
    ivCurveModel = LEDSystems.Types.IVCurveModel.ThreePointFit,
    Is_ref = 1e-18,
    n_ref = 2.0,
    Rs_ref = 1.0,

    // =========================================================================
    // 3) THERMIQUE
    // =========================================================================
    // RthJA du datasheet (carte normalisée). L'environnement thermique réel
    // (plaque, dissipateur, température imposée) se choisit dans le package
    // Thermal et se branche sur le heatPort de la LED.
    RthJA = 360,

    // ============================================================
    // 4) ÉMISSION LUMINEUSE
    // ============================================================
    // Émission moyenne, tableau « OPTICAL AND ELECTRICAL CHARACTERISTICS » à 25 °C
    // Ce datasheet donne l'intensité lumineuse (mcd). Pour une LED d'éclairage dont le
    // datasheet donne le flux (lm) : photometricInput = LuminousFlux et Phi_nom.
    photometricInput = LEDSystems.Types.PhotometricInput.LuminousIntensity,
    If_nom = 10e-3,
    Iv_nom = 0.275, // 275 mcd

    // Demi-angle (angle à mi-intensité)
    phi_half = Modelica.Units.Conversions.from_deg(60),

    // Faibles courants : il n'y a pas de seuil d'émission (une LED émet dès quelques µA).
    // Sous le premier point de la Fig. 5 (1 mA), l'intensité est prise proportionnelle
    // au courant : le rendement lumineux reste celui du premier point.

    // TCIV : coefficient de dérive thermique linéaire, utilisé seulement si
    // lightTemperatureModel = Linear (ici Table : la courbe IvRel_T_table de la Fig. 7)
    TCIV = -0.4e-2,

    // LER : Luminous Efficacy of Radiation (efficacité lumineuse du rayonnement)
    /* Conversion du flux lumineux (lm) en puissance optique rayonnée (W).
       Unité : lm/W (watt optique).
       Dépend du spectre de la LED.
       Valeur maximale théorique : 683 lm/W à 555 nm.
       LED blanche typique : 250 à 350 lm/W.
       Sert à calculer : P_opt = Phi_v / LER. */
    LER = 300,

    // --------------------------------------------------------------------
    // 5) VARIATION DE Vf AVEC LA TEMPÉRATURE (Fig. 8)
    // --------------------------------------------------------------------
    /*
      Deux stratégies :
        - linéaire sur 10..100 °C, pour un modèle léger : ΔV(T) = TCVf * (T - Tj_refVf)
        - table : Vf(T) par points
      Pour changer de stratégie : paramètres de la LED, bouton à côté de « data »,
      onglet « Avancé », liste vfTemperatureModel (Linear ou Table).

      Remarque : TCVf s'estime sur la courbe « Forward Voltage vs. Ambient Temperature »,
      par la pente autour du point de fonctionnement normal (20-40 °C).
    */
    vfTemperatureModel = LEDSystems.Types.VfTemperatureModel.Linear,
    TCVf = -3.5e-3,
    Tj_refVf = 298.15,
    Vf_T_table = [-40, 3.55; -20, 3.47; 0, 3.38; 20, 3.32; 40, 3.25; 60, 3.20; 80, 3.16; 100, 3.11],

    // ----------------------------------------------------------
    // 6) MODÈLE LUMINEUX : courbes relatives (Fig. 5 et Fig. 7)
    // ----------------------------------------------------------
    /*
      On calcule l'intensité relative, normalisée au point de référence du datasheet :
        Yrel = fI(If)/fI(If_nom) * fT(Tj)/fT(Tj_refLight),
      puis la grandeur physique : Iv = Iv_nom * Yrel.

      La Fig. 5 étant en échelle logarithmique, le meilleur rendu avec peu de points
      est une interpolation log-log : log(Yrel) en fonction de log(If).
      D'où l'option useLogLogInterpolation.
    */
    Tj_refLight = 298.15,
    lightTemperatureModel = LEDSystems.Types.LightTemperatureModel.Table, // effet de la température par la Fig. 7 (sinon : TCIV)
    useLogLogInterpolation = true,

    // --- Fig. 5 : Yrel = f(If) (If en mA sur le graphe, stocké ici en A) ---
    /* Lecture de la courbe en échelles log : la pente entre deux points indique la loi
       Iv proportionnelle à If^pente sur ce segment.
         pente = 1 : comportement linéaire (rendement constant) ;
         pente < 1 : saturation lumineuse (le rendement baisse quand le courant augmente) ;
         pente > 1 : comportement super-linéaire (rare).
       Pour cette LED : pente 0,67 entre 1 et 3 mA, 0,90 entre 30 et 100 mA. */
    IvRel_If_table = [1e-3, 0.12; 3e-3, 0.25; 10e-3, 1.00; 30e-3, 2.20; 100e-3, 6.50],

    // --- Fig. 7 : Yrel = f(Tamb) (T en °C) ---
    IvRel_T_table = [-40, 1.06; -20, 1.07; 0, 1.05; 25, 1.00; 40, 0.95; 60, 0.85; 80, 0.75; 100, 0.67],

    // Plage de la Fig. 7 : au-delà, la valeur de l'extrémité est maintenue
    T_minTable = 233.15, // -40 °C
    T_maxTable = 373.15  // 100 °C
  );

  annotation (Documentation(info = "<html>
<p><b>Vishay VLMW41S1T1-5K8L-08</b> (LED CMS blanc froid, boîtier PLCC-2) : LED de
signalisation de faible puissance, utilisée par tous les exemples de
<a href=\"modelica://LEDSystems.Examples.Basics\">Examples.Basics</a>.</p>
<p>Source : datasheet Vishay de la famille VLMW41.. (document 82411). Valeurs utilisées :</p>
<ul>
<li>tableau des caractéristiques à 25&nbsp;°C : Vf typique 3,3&nbsp;V à 20&nbsp;mA,
    Iv = 275&nbsp;mcd à 10&nbsp;mA, angle de demi-intensité 60° ;</li>
<li>Fig. 4 (If = f(Vf)) : 3 points de calage du modèle électrique (1, 20 et 100&nbsp;mA) ;</li>
<li>Fig. 5 (intensité relative en fonction du courant) et Fig. 7 (en fonction de la
    température ambiante, appliquée à la jonction) ;</li>
<li>Fig. 8 (Vf en fonction de la température) : coefficient TCVf = &minus;3,5&nbsp;mV/K ;</li>
<li>RthJA = 360&nbsp;K/W (carte normalisée du fabricant).</li>
</ul>
<p>Limites d'utilisation (valeurs maximales du datasheet) : courant continu 20&nbsp;mA
(Tamb &le; 80&nbsp;°C), température de jonction 110&nbsp;°C. Les courbes du datasheet
vont jusqu'à 100&nbsp;mA, mais au-delà de 20&nbsp;mA en continu la LED sort de son domaine
d'utilisation.</p>
<p>LER = 300&nbsp;lm/W est une valeur typique de LED blanche (le datasheet ne donne pas de
spectre exploitable) : la puissance optique <code>P_opt</code> de cette LED est donc
approchée. Les points de calage sont contrôlés par <code>outils/tester_datasheet.py</code>.</p>
</html>"));
end Vishay_VLMW41S1T1;
