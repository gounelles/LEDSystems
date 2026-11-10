within LEDSystems.Components.BaseClasses;
partial model PartialLED
  "Base commune des LED : modèle électrique, photométrique et thermique de Ns x Np LED identiques"
  import SI = Modelica.Units.SI;

  // =========================
  // Interfaces
  // =========================
  extends Modelica.Electrical.Analog.Interfaces.OnePort(
    v(start = Ns*data.Vf_typ),
    i(start = Np*data.If_typ, displayUnit = "mA"));

  LEDSystems.Interfaces.LightPort lightPort
    annotation(
      Placement(
        transformation(origin = {-20, 76}, extent = {{72, 16}, {88, 32}}),
        iconTransformation(origin = {-40, 68}, extent = {{90, 20}, {110, 40}})));

  // Port thermique : la jonction de la LED (toujours présent, à relier)
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    annotation(
      Placement(
        transformation(origin={-60, 0}, extent={{-10, 90}, {10, 110}}),
        iconTransformation(origin={-60, 0}, extent={{-10, 90}, {10, 110}})));

  // =========================
  // Paramètres
  // =========================
  replaceable parameter LEDSystems.Data.LEDData data
    constrainedby LEDSystems.Data.LEDData
    "Données de la LED (datasheet)"
    annotation(
      HideResult=true,
      choicesAllMatching=true,
      Evaluate=true,
      Dialog(
        group="Datasheet : bouton à droite pour voir ou modifier les valeurs"));

  // --- Résumé (lecture seule des valeurs du datasheet saisies dans data) ---
  parameter String colorName = data.colorName "Couleur / teinte"
    annotation(HideResult=true, Evaluate=true,
      Dialog(group="Caractéristiques principales", enable=false));
  parameter SI.Voltage Vf_typ = data.Vf_typ "Tension directe typique (datasheet)"
    annotation(HideResult=true, Evaluate=true,
      Dialog(group="Caractéristiques principales", enable=false));
  parameter SI.Current If_typ(displayUnit = "mA") = data.If_typ
    "Courant direct typique (datasheet)"
    annotation(HideResult=true, Evaluate=true,
      Dialog(group="Caractéristiques principales", enable=false));

  // --- Assemblage : Ns LED en série dans chacune des Np branches en parallèle ---
  parameter Integer Ns(min = 1) = 1 "Nombre de LED en série dans une branche"
    annotation(Evaluate=true, Dialog(group="Assemblage"));
  parameter Integer Np(min = 1) = 1 "Nombre de branches en parallèle"
    annotation(Evaluate=true, Dialog(group="Assemblage"));

  // --- Dispersion : écart de cette LED (ou de cet ensemble) par rapport au datasheet ---
  parameter SI.Voltage dVf = 0
    "Décalage de la tension directe, à courant donné (dispersion de fabrication)"
    annotation(Dialog(tab="Avancé", group="Dispersion"));
  parameter Real kIv(unit="1", min = 0) = 1
    "Facteur multiplicatif de l'intensité lumineuse (classe de luminosité)"
    annotation(Dialog(tab="Avancé", group="Dispersion"));

  // ==============================
  // Grandeurs utiles en simulation
  // ==============================
  // Vf et If : grandeurs d'UNE LED (comparables au datasheet) ;
  // tension et courant totaux : v et i. Iv, Phi_v, P_elec, P_opt, Qth : totaux.
  SI.Voltage Vf "Tension directe d'une LED";
  SI.Current If(displayUnit = "mA") "Courant direct d'une LED";
  SI.LuminousIntensity Iv(displayUnit = "mcd") "Intensité lumineuse totale";
  SI.LuminousFlux Phi_v "Flux lumineux total";
  SI.Power P_elec "Puissance électrique absorbée totale";
  SI.Power P_opt "Puissance optique rayonnée totale";
  SI.HeatFlowRate Qth "Puissance dissipée en chaleur à la jonction (totale)";
  // Tj ne doit pas servir de variable d'itération de la boucle électrothermique :
  // sinon omc calcule Vf à rebours depuis le bilan thermique (environ 5 V par kelvin
  // d'erreur sur Tj) et l'initialisation échoue dès que la jonction est reliée à une
  // capacité thermique. Une copie de Tj déclarée dans un modèle englobant doit porter
  // la même annotation (voir LEDWithPlate).
  // Annotation propre à OpenModelica, ignorée par les autres outils.
  SI.Temperature Tj "Température de jonction"
    annotation(__OpenModelica_tearingSelect = TearingSelect.avoid);

protected
  // --- Paramètres de Shockley (fournis, ou calés sur 3 points) ---
  parameter LEDSystems.Functions.ShockleyParams shockleyFit =
    LEDSystems.Functions.fitShockley3Points(
      data.V1_fit, data.I1_fit,
      data.V2_fit, data.I2_fit,
      data.V3_fit, data.I3_fit,
      data.Tj_refIV);
  parameter SI.Current IsShockley =
    if data.ivCurveModel == LEDSystems.Types.IVCurveModel.ShockleyParameters then data.Is_ref else shockleyFit.Is
    "Courant de saturation";
  parameter Real nShockley(unit="1") =
    if data.ivCurveModel == LEDSystems.Types.IVCurveModel.ShockleyParameters then data.n_ref else shockleyFit.n
    "Facteur d'idéalité";
  parameter SI.Resistance RsShockley =
    if data.ivCurveModel == LEDSystems.Types.IVCurveModel.ShockleyParameters then data.Rs_ref else shockleyFit.Rs
    "Résistance série";

  final parameter Real mLambert(unit="1") = -log(2)/log(cos(data.phi_half))
    "Ordre de l'émetteur lambertien généralisé (déduit du demi-angle)";

  // --- Photométrie : référence et normalisation des courbes du datasheet ---
  final parameter SI.LuminousIntensity Iv_ref =
    if data.photometricInput == LEDSystems.Types.PhotometricInput.LuminousIntensity
    then data.Iv_nom
    else data.Phi_nom*(mLambert + 1)/(2*Modelica.Constants.pi)
    "Intensité lumineuse de référence à If_nom (donnée, ou déduite du flux)";
  final parameter Real fI_nom(unit="1") =
    LEDSystems.Functions.relativeIntensity(data.IvRel_If_table, data.If_nom,
      data.useLogLogInterpolation)
    "Valeur de la courbe Iv relative = f(If) au courant de référence If_nom";
  final parameter Real fT_ref(unit="1") =
    LEDSystems.Functions.interpolateClamped(data.IvRel_T_table,
      Modelica.Units.Conversions.to_degC(data.Tj_refLight))
    "Valeur de la courbe Iv relative = f(T) à la température de référence";
  parameter Real xExp_max(unit="1") = 80 "Limite de l'argument de exp() (robustesse numérique)";

  SI.Voltage vLED "Tension aux bornes d'une LED";
  SI.Current iLED "Courant dans une LED";
  SI.Voltage Vt "Tension thermique kT/q évaluée à Tj_refIV";
  SI.Voltage dVf_T "Décalage de Vf dû à la température";
  Real fT(unit="1") "Facteur de température de l'intensité lumineuse (1 à Tj_refLight)";
  SI.Voltage vEff "Tension interne corrigée thermiquement";
  Real xExp(unit="1", start = log(data.If_typ/IsShockley + 1))
    "Argument de l'exponentielle (départ : sa valeur au courant typique)";
  Real xExpLim(unit="1") "Argument de l'exponentielle, limité";

initial equation
  // Garde-fous si des valeurs fournies sont incohérentes
  assert(IsShockley > 0, "LED : le courant de saturation IsShockley doit être > 0.");
  assert(nShockley > 0, "LED : le facteur d'idéalité nShockley doit être > 0.");
  assert(RsShockley >= 0, "LED : la résistance série RsShockley doit être >= 0.");

equation
  // --- Grandeurs d'une LED (assemblage Ns x Np de LED identiques) ---
  vLED = v/Ns;
  iLED = i/Np;

  // --- Modèle I-V : Shockley + Rs (implicite) ---
  // La loi de base est identifiée à Tj_refIV.
  // La dérive thermique de Vf est apportée par les données du datasheet.
  Vt = Modelica.Constants.k*data.Tj_refIV/Modelica.Constants.q;

  // Décalage de la tension directe en fonction de la température de jonction :
  // linéaire (TCVf), ou différence de deux valeurs de la table Vf = f(T) (en °C)
  if data.vfTemperatureModel == LEDSystems.Types.VfTemperatureModel.Linear then
    dVf_T = data.TCVf*(Tj - data.Tj_refVf);
  else
    dVf_T = Modelica.Math.Vectors.interpolate(data.Vf_T_table[:, 1], data.Vf_T_table[:, 2],
              Modelica.Units.Conversions.to_degC(Tj))
          - Modelica.Math.Vectors.interpolate(data.Vf_T_table[:, 1], data.Vf_T_table[:, 2],
              Modelica.Units.Conversions.to_degC(data.Tj_refVf));
  end if;

  // Tension interne corrigée :
  // si Tj augmente et TCVf < 0, la diode devient plus conductrice
  // à tension donnée, donc à courant imposé Vf diminue.
  // dVf décale Vf de cette LED (dispersion de fabrication).
  vEff = vLED - iLED*RsShockley - dVf_T - dVf;

  xExp = vEff/(nShockley*Vt);

  // Courant direct + fuite parallèle (Rp)
  // L'argument de l'exponentielle est limité pour la robustesse numérique.
  xExpLim = noEvent(min(max(xExp, -xExp_max), xExp_max));
  iLED = IsShockley*(Modelica.Math.exp(xExpLim) - 1) + vLED/data.Rp;

  // --- Grandeurs électriques ---
  Vf = vLED;
  If = iLED;
  P_elec = v*i;

  // --- Photométrie ---
  // Iv = Iv_ref * fI(If)/fI(If_nom) * fT(Tj)/fT(Tj_refLight)
  // fI : courbe Iv relative = f(If) du datasheet (log-log, proportionnelle sous la table)
  // fT : courbe Iv relative = f(T) du datasheet (ou coefficient linéaire TCIV)
  if data.lightTemperatureModel == LEDSystems.Types.LightTemperatureModel.Table then
    fT = LEDSystems.Functions.interpolateClamped(data.IvRel_T_table,
           Modelica.Units.Conversions.to_degC(
             min(max(Tj, data.T_minTable), data.T_maxTable)))/fT_ref;
  else
    fT = 1 + data.TCIV*(Tj - data.Tj_refLight);
  end if;

  // Intensité totale : Ns*Np LED, chacune corrigée par kIv (dispersion)
  Iv = Ns*Np*kIv*Iv_ref
       * LEDSystems.Functions.relativeIntensity(data.IvRel_If_table, iLED,
           data.useLogLogInterpolation)/fI_nom
       * fT;                                                    // intensité lumineuse

  assert(iLED <= data.IvRel_If_table[size(data.IvRel_If_table, 1), 1],
    "LED : courant supérieur au dernier point de la courbe Iv = f(If) du datasheet, "
    + "intensité lumineuse extrapolée.", AssertionLevel.warning);

  Phi_v = 2*Modelica.Constants.pi*Iv/(mLambert + 1);            // flux lumineux

  P_opt = Phi_v/data.LER;                                       // puissance optique

  // Garde-fou : le rendement ne peut pas dépasser 100 %. Avertissement seulement
  // (pas d'écrêtage) : une valeur aberrante signale une donnée incohérente.
  // Tolérance de 1 nW : à courant nul, P_elec peut valoir -1e-36 W (bruit numérique
  // sur des LED en série), ce qui déclencherait une fausse alerte.
  assert(P_opt <= P_elec + 1e-9,
    "LED : puissance optique supérieure à la puissance électrique (rendement > 100 %). "
    + "Vérifier LER et la référence photométrique (Iv_nom ou Phi_nom).",
    AssertionLevel.warning);

  lightPort.Phi_v = Phi_v;
  lightPort.Iv = Iv;

  // --- Thermique : la jonction est le heatPort ---
  Qth = P_elec - P_opt;
  Tj = heatPort.T;
  heatPort.Q_flow = -Qth;

  annotation(Documentation(info = "<html>
<p>Base commune de <code>LED</code> et <code>LEDArray</code> : modèle électrique
(diode de Shockley + résistance série + fuite), photométrique (intensité, flux) et
thermique (puissance dissipée) d'un assemblage de <code>Ns</code> LED en série dans
chacune de <code>Np</code> branches en parallèle, toutes identiques et à la même
température de jonction.</p>
<ul>
<li>Grandeurs d'une LED : <code>Vf</code>, <code>If</code> (comparables au datasheet) ;
    tension et courant totaux : <code>v</code>, <code>i</code>.</li>
<li>Grandeurs totales : <code>Iv</code>, <code>Phi_v</code>, <code>P_elec</code>,
    <code>P_opt</code>, <code>Qth</code>.</li>
<li>Dispersion : <code>dVf</code> décale la tension directe à courant donné,
    <code>kIv</code> multiplie l'intensité lumineuse.</li>
</ul>
<p>Le <code>heatPort</code> représente la jonction commune.</p>
</html>"));
end PartialLED;
