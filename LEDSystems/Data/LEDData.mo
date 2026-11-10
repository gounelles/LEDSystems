within LEDSystems.Data;
record LEDData "Données d'une LED, issues de son datasheet"
  extends Modelica.Icons.Record;
  import SI = Modelica.Units.SI;

  // ==========================================================================
  // Onglet standard « General » (aucun tab indiqué) : caractéristiques principales (tableau du datasheet)
  // ==========================================================================
  parameter String colorName = "Cool white"
    "Couleur / teinte (ex. : Cool white, Warm white, Red…)"
    annotation (HideResult = true, Evaluate = true,
      Dialog(group = "Caractéristiques principales"));
  parameter SI.Current If_typ(displayUnit = "mA") = 20e-3 "Courant direct typique (datasheet)"
    annotation (HideResult = true, Evaluate = true,
      Dialog(group = "Caractéristiques principales"));
  parameter SI.Voltage Vf_typ = 3.3 "Tension directe typique à If_typ (datasheet)"
    annotation (HideResult = true, Evaluate = true,
      Dialog(group = "Caractéristiques principales"));

  // --- Point de référence photométrique (condition de test du datasheet) ---
  parameter SI.Current If_nom(displayUnit = "mA") = 10e-3
    "Courant de la condition de test photométrique"
    annotation (HideResult = true, Evaluate = true,
      Dialog(group = "Référence photométrique"));
  // Le datasheet donne soit l'intensité lumineuse (mcd, LED de signalisation),
  // soit le flux lumineux (lm, LED d'éclairage) au courant If_nom.
  parameter LEDSystems.Types.PhotometricInput photometricInput =
    LEDSystems.Types.PhotometricInput.LuminousIntensity
    "Grandeur photométrique de référence donnée par le datasheet"
    annotation (HideResult = true, Evaluate = true,
      Dialog(group = "Référence photométrique"));
  parameter SI.LuminousIntensity Iv_nom(displayUnit = "mcd") = 0.275
    "Intensité lumineuse de référence à If_nom"
    annotation (HideResult = true, Evaluate = true,
      Dialog(group = "Référence photométrique",
        enable = photometricInput == LEDSystems.Types.PhotometricInput.LuminousIntensity));
  parameter SI.LuminousFlux Phi_nom = 0.8639
    "Flux lumineux de référence à If_nom"
    annotation (HideResult = true, Evaluate = true,
      Dialog(group = "Référence photométrique",
        enable = photometricInput == LEDSystems.Types.PhotometricInput.LuminousFlux));
  parameter SI.Angle phi_half(displayUnit = "deg") = Modelica.Units.Conversions.from_deg(60)
    "Demi-angle d'émission (angle à mi-intensité)"
    annotation (HideResult = true, Evaluate = true,
      Dialog(group = "Référence photométrique"));

  // ==========================================================================
  // Onglet « Thermique »
  // ==========================================================================
  // RthJA : jonction -> ambiance, mesurée par le fabricant sur une carte normalisée.
  // Utilisable comme résistance d'une Thermal.Plate pour un modèle simple.
  // Beaucoup de datasheets de LED d'éclairage ne la donnent pas (elle dépend de la carte) :
  // laisser alors 0, qui signifie « non fournie ».
  parameter SI.ThermalResistance RthJA(min = 0) = 0
    "Résistance thermique jonction - ambiance (datasheet ; 0 : non fournie)"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Thermique", group = "Résistances thermiques"));
  // RthJC : jonction -> boîtier (point de soudure), propre à la LED.
  // À placer entre le heatPort de la LED et son dissipateur.
  parameter SI.ThermalResistance RthJC = 10
    "Résistance thermique jonction - boîtier (datasheet)"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Thermique", group = "Résistances thermiques"));
  // Deux définitions existent chez les fabricants :
  //  - « réelle » : RthJC = DeltaT / chaleur dissipée (P_elec - P_opt) ;
  //  - « électrique » (par exemple Bridgelux) : RthJC = DeltaT / puissance électrique
  //    totale. Elle sous-estime la vraie résistance d'un facteur (1 - rendement).
  // Le modèle fait passer la chaleur Qth = P_elec - P_opt : il utilise RthJC_heat
  // (et RthJA_heat). La convention choisie s'applique à RthJC et à RthJA.
  parameter Boolean RthJC_onElectricalPower = false
    "RthJC (et RthJA) du datasheet rapportées à la puissance électrique totale (et non à la chaleur)"
    annotation (HideResult = true, Evaluate = true, choices(checkBox = true),
      Dialog(tab = "Thermique", group = "Résistances thermiques"));
  final parameter Real eta_ref(unit = "1") =
    (if photometricInput == LEDSystems.Types.PhotometricInput.LuminousFlux then Phi_nom
     else Iv_nom*2*Modelica.Constants.pi/(1 - log(2)/log(cos(phi_half))))/LER
    /(Vf_typ*If_nom)
    "Rendement optique P_opt/P_elec au point de référence (If_nom, Vf_typ ; suppose If_typ = If_nom)";
  final parameter SI.ThermalResistance RthJC_heat =
    if RthJC_onElectricalPower then RthJC/(1 - eta_ref) else RthJC
    "Résistance thermique jonction - boîtier au sens du flux de chaleur (utilisée par les modèles)";
  final parameter SI.ThermalResistance RthJA_heat =
    if RthJC_onElectricalPower then RthJA/(1 - eta_ref) else RthJA
    "Résistance thermique jonction - ambiance au sens du flux de chaleur (0 : non fournie)";

  // ==========================================================================
  // Onglet « Lumière »
  // ==========================================================================
  // Courbes relatives du datasheet : Iv = Iv_nom * fI(If)/fI(If_nom) * fT(Tj)/fT(Tj_refLight)
  // Sous le premier point de IvRel_If_table, Iv est proportionnelle à If (rendement
  // constant) : prolonger la pente de la courbe donnerait un rendement supérieur à 100 %.
  parameter Boolean useLogLogInterpolation = true
    "true : interpolation de log(Y) en fonction de log(If) ; false : interpolation linéaire"
    annotation (HideResult = true, Evaluate = true, choices(checkBox = true),
      Dialog(tab = "Lumière", group = "Effet du courant"));
  parameter Real IvRel_If_table[:, 2] = [
    //  If (A), Iv relative (1)
       1e-3,   0.12;
       3e-3,   0.25;
      10e-3,   1.00;
      30e-3,   2.20;
     100e-3,   6.50]
    "Intensité lumineuse relative en fonction du courant (If en A, Iv relative)"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Lumière", group = "Effet du courant"));

  // --- Effet de la température : courbe du datasheet (choix normal) ou coefficient ---
  parameter LEDSystems.Types.LightTemperatureModel lightTemperatureModel =
    LEDSystems.Types.LightTemperatureModel.Table
    "Modèle de l'effet de la température sur la lumière : courbe du datasheet ou coefficient"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Lumière", group = "Effet de la température"));
  parameter SI.Temperature Tj_refLight = 298.15
    "Température de jonction à laquelle Iv_nom (ou Phi_nom) est donnée"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Lumière", group = "Effet de la température"));
  parameter Real IvRel_T_table[:, 2] = [
    //  T (°C), Iv relative (1)
       -40,    1.06;
       -20,    1.07;
         0,    1.05;
        25,    1.00;
        40,    0.95;
        60,    0.85;
        80,    0.75;
       100,    0.67]
    "Iv relative = f(T) (T en °C) ; sert si lightTemperatureModel = Table"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Lumière", group = "Effet de la température",
        enable = lightTemperatureModel == LEDSystems.Types.LightTemperatureModel.Table));
  // Bornes de IvRel_T_table : au-delà, la valeur de l'extrémité est maintenue
  parameter SI.Temperature T_minTable = 233.15
    "Température minimale de IvRel_T_table ; sert si lightTemperatureModel = Table"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Lumière", group = "Effet de la température",
        enable = lightTemperatureModel == LEDSystems.Types.LightTemperatureModel.Table));
  parameter SI.Temperature T_maxTable = 373.15
    "Température maximale de IvRel_T_table ; sert si lightTemperatureModel = Table"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Lumière", group = "Effet de la température",
        enable = lightTemperatureModel == LEDSystems.Types.LightTemperatureModel.Table));
  parameter Real TCIV(unit = "1/K") = -0.4e-2
    "Coefficient de température relatif de Iv ; sert si lightTemperatureModel = Linear"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Lumière", group = "Effet de la température",
        enable = lightTemperatureModel == LEDSystems.Types.LightTemperatureModel.Linear));

  // --- Conversion lumière -> puissance optique (bilan thermique) ---
  parameter Real LER(unit = "lm/W") = 300
    "Efficacité lumineuse du rayonnement (flux lumineux / puissance optique)"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Lumière", group = "Puissance optique"));

  // ==========================================================================
  // Onglet « Avancé » : modèle électrique
  // ==========================================================================
  parameter SI.Resistance Rp = 1e8 "Résistance de fuite (sens direct et inverse)"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Électrique"));

  // --- Variation de Vf avec la température : coefficient (choix courant) ou table ---
  parameter LEDSystems.Types.VfTemperatureModel vfTemperatureModel =
    LEDSystems.Types.VfTemperatureModel.Linear
    "Modèle de Vf(T) : coefficient linéaire TCVf ou table Vf_T_table"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Vf en fonction de la température"));
  parameter SI.Temperature Tj_refVf = 298.15
    "Température de référence de la correction de Vf"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Vf en fonction de la température"));
  parameter Real TCVf(unit = "V/K") = -3.0e-3
    "Coefficient de température de Vf ; sert si vfTemperatureModel = Linear"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Vf en fonction de la température",
        enable = vfTemperatureModel == LEDSystems.Types.VfTemperatureModel.Linear));
  parameter Real Vf_T_table[:, 2] = [
    //  T (°C), Vf (V)
       -40, 3.55;
       -20, 3.47;
         0, 3.38;
        20, 3.32;
        40, 3.25;
        60, 3.20;
        80, 3.16;
       100, 3.11]
    "Vf = f(T) (T en °C, Vf en V) ; sert si vfTemperatureModel = Table"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Vf en fonction de la température",
        enable = vfTemperatureModel == LEDSystems.Types.VfTemperatureModel.Table));

  // --- Modèle de Shockley + Rs : calé sur 3 points de If = f(Vf) (choix normal),
  //     ou paramètres fournis directement ---
  parameter LEDSystems.Types.IVCurveModel ivCurveModel =
    LEDSystems.Types.IVCurveModel.ThreePointFit
    "Origine de Is, n, Rs : calage sur 3 points de la courbe If = f(Vf), ou valeurs fournies"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Courbe I-V"));
  parameter SI.Temperature Tj_refIV = 298.15
    "Température de jonction de la courbe If = f(Vf) (ou des paramètres fournis)"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Courbe I-V"));
  parameter SI.Voltage V1_fit = 2.75
    "Point 1 : tension lue sur If = f(Vf) ; sert si ivCurveModel = ThreePointFit"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Calage sur 3 points",
        enable = ivCurveModel == LEDSystems.Types.IVCurveModel.ThreePointFit));
  parameter SI.Current I1_fit(displayUnit = "mA") = 1e-3
    "Point 1 : courant lu sur If = f(Vf) ; sert si ivCurveModel = ThreePointFit"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Calage sur 3 points",
        enable = ivCurveModel == LEDSystems.Types.IVCurveModel.ThreePointFit));
  parameter SI.Voltage V2_fit = 3.30
    "Point 2 : tension lue sur If = f(Vf) ; sert si ivCurveModel = ThreePointFit"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Calage sur 3 points",
        enable = ivCurveModel == LEDSystems.Types.IVCurveModel.ThreePointFit));
  parameter SI.Current I2_fit(displayUnit = "mA") = 20e-3
    "Point 2 : courant lu sur If = f(Vf) ; sert si ivCurveModel = ThreePointFit"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Calage sur 3 points",
        enable = ivCurveModel == LEDSystems.Types.IVCurveModel.ThreePointFit));
  parameter SI.Voltage V3_fit = 4.50
    "Point 3 : tension lue sur If = f(Vf) ; sert si ivCurveModel = ThreePointFit"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Calage sur 3 points",
        enable = ivCurveModel == LEDSystems.Types.IVCurveModel.ThreePointFit));
  parameter SI.Current I3_fit(displayUnit = "mA") = 100e-3
    "Point 3 : courant lu sur If = f(Vf) ; sert si ivCurveModel = ThreePointFit"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Calage sur 3 points",
        enable = ivCurveModel == LEDSystems.Types.IVCurveModel.ThreePointFit));
  parameter SI.Current Is_ref = 1e-18
    "Courant de saturation à Tj_refIV ; sert si ivCurveModel = ShockleyParameters"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Paramètres de Shockley fournis",
        enable = ivCurveModel == LEDSystems.Types.IVCurveModel.ShockleyParameters));
  parameter Real n_ref(unit = "1") = 2.0
    "Facteur d'idéalité à Tj_refIV ; sert si ivCurveModel = ShockleyParameters"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Paramètres de Shockley fournis",
        enable = ivCurveModel == LEDSystems.Types.IVCurveModel.ShockleyParameters));
  parameter SI.Resistance Rs_ref = 1.0
    "Résistance série à Tj_refIV ; sert si ivCurveModel = ShockleyParameters"
    annotation (HideResult = true, Evaluate = true,
      Dialog(tab = "Avancé", group = "Paramètres de Shockley fournis",
        enable = ivCurveModel == LEDSystems.Types.IVCurveModel.ShockleyParameters));

  annotation (Documentation(info = "<html>
<p>Record de base des données d'une LED. Pour une LED réelle, créer un record qui
<em>étend</em> <code>LEDData</code> et renseigne les valeurs lues sur son datasheet (voir
<a href=\"modelica://LEDSystems.Data.Vishay_VLMW41S1T1\">Vishay_VLMW41S1T1</a>, et les records
Bridgelux et Lumileds pour des LED d'éclairage).</p>
<p>Les paramètres sont rangés par onglet dans la boîte de dialogue d'OMEdit, dans l'ordre
où on les lit sur un datasheet :</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Onglet</th><th>Contenu</th><th>Partie du datasheet</th></tr>
<tr><td>General</td><td>Caractéristiques principales (teinte, Vf et If typiques) ;
    référence photométrique : intensité (mcd) ou flux (lm) au courant de référence, angle
    de demi-intensité</td>
    <td>Tableau des caractéristiques électriques et optiques</td></tr>
<tr><td>Thermique</td><td>Résistances thermiques RthJA et RthJC, et leur convention
    (calculée sur la puissance électrique ou sur la chaleur)</td>
    <td>Tableau des caractéristiques thermiques</td></tr>
<tr><td>Lumière</td><td>Effet du courant : courbe d'intensité (ou de flux) relative
    = f(If) ; effet de la température : choix du modèle, température de référence, courbe
    relative = f(T) ou coefficient TCIV ; puissance optique : LER</td>
    <td>Courbes relatives = f(If) et = f(T) ; spectre</td></tr>
<tr><td>Avancé</td><td>Résistance parallèle ; variation de Vf avec la température (choix :
    coefficient ou table) ; courbe I-V (choix : calage sur 3 points de If = f(Vf), ou
    paramètres de Shockley fournis), puis les paramètres de chaque option</td>
    <td>Courbes If = f(Vf) et Vf = f(T)</td></tr>
</table>
<p><strong>Choix de modèle.</strong> Trois listes déroulantes indiquent quelle donnée du
datasheet est utilisée ; les paramètres de l'autre option sont ignorés :</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Paramètre (onglet)</th><th>Options</th><th>Choix habituel</th></tr>
<tr><td><code>lightTemperatureModel</code> (Lumière)</td>
    <td><a href=\"modelica://LEDSystems.Types.LightTemperatureModel\">Table</a>
    (<code>IvRel_T_table</code>) ou <code>Linear</code> (<code>TCIV</code>)</td>
    <td><code>Table</code> : les datasheets donnent la courbe</td></tr>
<tr><td><code>vfTemperatureModel</code> (Avancé)</td>
    <td><a href=\"modelica://LEDSystems.Types.VfTemperatureModel\">Linear</a>
    (<code>TCVf</code>) ou <code>Table</code> (<code>Vf_T_table</code>)</td>
    <td><code>Linear</code>, sauf courbe Vf = f(T) nettement courbée</td></tr>
<tr><td><code>ivCurveModel</code> (Avancé)</td>
    <td><a href=\"modelica://LEDSystems.Types.IVCurveModel\">ThreePointFit</a>
    (<code>V1_fit</code>…<code>I3_fit</code>) ou <code>ShockleyParameters</code>
    (<code>Is_ref</code>, <code>n_ref</code>, <code>Rs_ref</code>)</td>
    <td><code>ThreePointFit</code> : un datasheet donne la courbe, pas les paramètres</td></tr>
</table>
<p><em>Limite d'OMEdit 1.26</em> : dans le sous-dialogue <code>data</code> d'une LED, les
paramètres de l'option non retenue ne sont pas grisés (les conditions <code>enable</code>
y sont ignorées). La description de chaque paramètre indique donc quand il sert
(« sert si … »).</p>
<p>Les données thermiques de l'environnement (plaque, dissipateur, température imposée)
ne sont pas ici : ce sont des composants du package
<a href=\"modelica://LEDSystems.Thermal\">Thermal</a>, à brancher sur le
<code>heatPort</code> de la LED.</p>
</html>"));
end LEDData;
