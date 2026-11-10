within LEDSystems.Components;
model LEDWithPlate "LED montée sur une plaque dissipatrice (bloc prêt à l'emploi)"
  import SI = Modelica.Units.SI;

  // =========================
  // Paramètres
  // =========================
  replaceable parameter LEDSystems.Data.LEDData data
    constrainedby LEDSystems.Data.LEDData
    "Données de la LED (datasheet)"
    annotation(
      HideResult = true,
      choicesAllMatching = true,
      Evaluate = true,
      Dialog(group = "Datasheet : bouton à droite pour voir ou modifier les valeurs"));

  parameter Boolean useDatasheetRth = true
    "Résistance plaque - air déduite du datasheet (RthJA - RthJC, au sens de la chaleur)"
    annotation(Evaluate = true, choices(checkBox = true), Dialog(group = "Plaque"));
  parameter SI.ThermalResistance R_plate = 350
    "Résistance thermique plaque - air (utilisée si la case précédente est décochée)"
    annotation(Dialog(group = "Plaque", enable = not useDatasheetRth));
  final parameter SI.ThermalResistance R_plateUsed =
    if useDatasheetRth then data.RthJA_heat - data.RthJC_heat else R_plate
    "Résistance plaque - air réellement utilisée";
  parameter SI.Area area(displayUnit = "mm2") = 200e-6 "Surface de plaque attribuée à la LED"
    annotation(Dialog(group = "Plaque"));
  parameter SI.Length thickness(displayUnit = "mm") = 0.5e-3 "Épaisseur de la plaque"
    annotation(Dialog(group = "Plaque"));
  parameter SI.Density rho = 2700 "Masse volumique de la plaque (défaut : aluminium)"
    annotation(Dialog(group = "Plaque"));
  parameter SI.SpecificHeatCapacity cp = 900
    "Capacité thermique massique de la plaque (défaut : aluminium)"
    annotation(Dialog(group = "Plaque"));

  parameter SI.Temperature T_ambient = 293.15 "Température de l'air ambiant"
    annotation(Dialog(group = "Ambiance"));
  parameter SI.Temperature T_start = T_ambient "Température initiale de la plaque"
    annotation(Dialog(group = "Ambiance"));

  // =========================
  // Interfaces
  // =========================
  Modelica.Electrical.Analog.Interfaces.PositivePin p "Anode"
    annotation(Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n "Cathode"
    annotation(Placement(transformation(extent = {{90, -10}, {110, 10}})));
  LEDSystems.Interfaces.LightPort lightPort
    annotation(
      Placement(
        transformation(origin = {-40, 68}, extent = {{90, 20}, {110, 40}}),
        iconTransformation(origin = {-40, 68}, extent = {{90, 20}, {110, 40}})));

  // =========================
  // Grandeurs utiles en simulation
  // =========================
  SI.Voltage Vf = led.Vf "Tension directe";
  SI.Current If(displayUnit = "mA") = led.If "Courant direct";
  SI.LuminousIntensity Iv(displayUnit = "mcd") = led.Iv "Intensité lumineuse";
  SI.LuminousFlux Phi_v = led.Phi_v "Flux lumineux";
  SI.HeatFlowRate Qth = led.Qth "Puissance dissipée en chaleur";
  SI.Temperature Tj = led.Tj "Température de jonction"
    annotation(__OpenModelica_tearingSelect = TearingSelect.avoid); // voir LED.Tj
  SI.Temperature T_plate = plate.T "Température de la plaque";

protected
  LEDSystems.Components.LED led(data = data)
    annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor rthJC(final R = data.RthJC_heat)
    "Jonction - boîtier de la LED"
    annotation(Placement(transformation(origin = {-6, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  LEDSystems.Thermal.Plate plate(
    final R = R_plateUsed,
    final area = area,
    final thickness = thickness,
    final rho = rho,
    final cp = cp,
    final T_ambient = T_ambient,
    final T_start = T_start)
    annotation(Placement(transformation(origin = {-6, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  assert(not useDatasheetRth or data.RthJA > 0,
    "LEDWithPlate : le record de la LED ne donne pas RthJA (datasheet sans résistance "
    + "jonction - ambiance). Décocher useDatasheetRth et saisir R_plate.");
  assert(R_plateUsed > 0,
    "LEDWithPlate : résistance plaque - air nulle ou négative (R_plateUsed = "
    + String(R_plateUsed) + " K/W). Vérifier RthJA et RthJC du record, ou R_plate.");
  connect(p, led.p)
    annotation(Line(points = {{-100, 0}, {-10, 0}}, color = {0, 0, 255}));
  connect(led.n, n)
    annotation(Line(points = {{10, 0}, {100, 0}}, color = {0, 0, 255}));
  connect(led.lightPort, lightPort)
    annotation(Line(points = {{6, 10}, {6, 20}, {60, 20}, {60, 98}}, color = {0, 0, 127}));
  connect(led.heatPort, rthJC.port_a)
    annotation(Line(points = {{-6, 10}, {-6, 30}}, color = {191, 0, 0}));
  connect(rthJC.port_b, plate.port)
    annotation(Line(points = {{-6, 50}, {-6, 66}}, color = {191, 0, 0}));

  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-90, 0}, {-30, 0}}, thickness = 2), Polygon(fillPattern = FillPattern.Solid, lineThickness = 2, points = {{-30, 40}, {-30, -40}, {30, 0}, {-30, 40}}), Line(points = {{30, 40}, {30, -40}}, thickness = 2), Line(points = {{30, 0}, {90, 0}}, thickness = 2), Line(origin = {4, -4}, points = {{10, 55}, {35, 80}}, thickness = 2), Polygon(origin = {4, -4}, fillPattern = FillPattern.Solid, points = {{37, 82}, {26, 78}, {34, 70}, {37, 82}}), Line(origin = {-6, 6}, points = {{10, 55}, {35, 80}}, thickness = 2), Polygon(origin = {-6, 6}, fillPattern = FillPattern.Solid, points = {{37, 82}, {26, 78}, {34, 70}, {37, 82}}), Text(origin = {0, -122}, extent = {{-72, 16}, {72, -16}}, textString = "%name"), Rectangle(extent = {{-80, -52}, {80, -66}}, lineColor = {64, 64, 64}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid), Line(points = {{0, -40}, {0, -52}}, color = {191, 0, 0}, thickness = 1), Text(origin = {0, -84}, extent = {{-95, 14}, {95, -14}}, textString = "LED + plaque")}),
    Documentation(info = "<html>
<p>Bloc prêt à l'emploi : une <code>LED</code> montée sur une plaque dissipatrice
(<a href=\"modelica://LEDSystems.Thermal.Plate\">Thermal.Plate</a>), à travers la
résistance jonction - boîtier de la LED (<code>data.RthJC_heat</code>, voir
<a href=\"modelica://LEDSystems.Data.LEDData\">LEDData</a>). Il suffit de le brancher dans un circuit électrique : l'environnement
thermique (plaque et air ambiant) est inclus.</p>
<p>Chemin de la chaleur : jonction &rarr; RthJC_heat &rarr; plaque (capacité thermique) &rarr;
R_plate &rarr; air ambiant.</p>
<ul>
<li>Par défaut (<code>useDatasheetRth</code> cochée), la résistance plaque - air vaut
    RthJA &minus; RthJC : la résistance totale jonction - air vaut le RthJA du datasheet,
    et en régime établi Tj = T_ambient + Qth&middot;RthJA (résistances prises au sens de
    la chaleur, <code>RthJA_heat</code> et <code>RthJC_heat</code>, voir
    <a href=\"modelica://LEDSystems.Data.LEDData\">LEDData</a>). Il faut que le datasheet
    donne RthJA : c'est le cas de la Vishay VLMW41S1T1, pas des records Bridgelux et
    Lumileds. Sans RthJA, la simulation s'arrête avec un message : décocher
    <code>useDatasheetRth</code> et saisir <code>R_plate</code>.</li>
<li>Pour un montage réel, décocher <code>useDatasheetRth</code>, puis régler
    <code>R_plate</code> et les dimensions de la plaque.</li>
<li>La valeur réellement utilisée est <code>R_plateUsed</code> (visible dans les résultats).</li>
</ul>
<p>Grandeurs à observer : <code>Vf</code>, <code>If</code>, <code>Iv</code>, <code>Phi_v</code>,
<code>Qth</code>, <code>Tj</code>, <code>T_plate</code>.</p>
</html>"));
end LEDWithPlate;
