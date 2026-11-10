within LEDSystems.Examples.Automotive;
model HeadlampLowHighBeam
  "Phare à LED : feu de croisement (1000 mA) puis feu de route (1500 mA), air du phare à 85 °C"
  extends Modelica.Icons.Example;
  import SI = Modelica.Units.SI;

  // =========================
  // Composants
  // (valeurs saisies directement sur les composants : double-clic dans OMEdit)
  // =========================
  Modelica.Electrical.Analog.Sources.StepCurrent driver(I = 0.5, offset = 1.0, startTime = 1800)
    "Driver à courant constant : 1000 mA (croisement), puis 1500 mA (route) à t = 30 min"
    annotation(Placement(transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation(Placement(transformation(origin = {-60, -40}, extent = {{-10, -10}, {10, 10}})));
  // Radiateur du phare : 50 g d'aluminium (plaque équivalente de 3700 mm² x 5 mm),
  // résistance radiateur - air de 8 K/W (hypothèse), air intérieur du phare à 85 °C.
  LEDSystems.Components.LEDWithPlate headlamp(
    redeclare LEDSystems.Data.Lumileds_LUXEON_FX2L_Plus_CW data,
    useDatasheetRth = false, R_plate = 8,
    area = 3.7e-3, thickness = 5e-3,
    T_ambient = 358.15)
    "LED sur le radiateur du phare (air à 85 °C ; T_start suit T_ambient)"
    annotation(Placement(transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}})));

  // =========================
  // Grandeurs à observer
  // =========================
  SI.Power P_elec = headlamp.Vf*headlamp.If "Puissance électrique de la LED";
  Real efficacy(unit = "lm/W") = headlamp.Phi_v/max(P_elec, 1e-9) "Efficacité lumineuse";
  SI.TemperatureDifference Tj_margin = 423.15 - headlamp.Tj
    "Marge par rapport à Tj max = 150 °C (Tab. 4 du datasheet)";

equation
  connect(driver.n, headlamp.p) annotation(Line(points = {{-60, 10}, {-60, 20}, {-20, 20}, {-20, 0}, {-10, 0}}, color = {0, 0, 255}));
  connect(headlamp.n, ground.p) annotation(Line(points = {{10, 0}, {20, 0}, {20, -30}, {-60, -30}}, color = {0, 0, 255}));
  connect(driver.p, ground.p) annotation(Line(points = {{-60, -10}, {-60, -30}}, color = {0, 0, 255}));

  annotation(
    experiment(StartTime = 0, StopTime = 3600, Interval = 1),
    Documentation(info = "<html>
<p>Phare à LED : une LED Lumileds LUXEON FX2-L Plus (DS394) sur le radiateur du phare
(<code>headlamp</code> : 50&nbsp;g d'aluminium, 8&nbsp;K/W vers l'air, hypothèses),
alimentée par un driver à courant constant. L'air à l'intérieur du phare est à 85&nbsp;°C
(<code>headlamp.T_ambient</code>). Feu de croisement à 1000&nbsp;mA pendant 30&nbsp;min, puis
feu de route à 1500&nbsp;mA (courant maximal en continu).</p>
<h4>À observer</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Instant</th><th>Courant</th><th>Vf</th><th>Radiateur</th><th>Tj</th><th>Marge</th>
<th>Flux</th><th>P élec.</th><th>Efficacité</th></tr>
<tr><td>allumage</td><td>1000&nbsp;mA</td><td>3,085&nbsp;V</td><td>85,0&nbsp;°C</td><td>95,6&nbsp;°C</td><td>54&nbsp;K</td><td>372&nbsp;lm</td><td>3,09&nbsp;W</td><td>121&nbsp;lm/W</td></tr>
<tr><td>30&nbsp;min</td><td>1000&nbsp;mA</td><td>3,053&nbsp;V</td><td>100,1&nbsp;°C</td><td>110,8&nbsp;°C</td><td>39&nbsp;K</td><td>360&nbsp;lm</td><td>3,05&nbsp;W</td><td>118&nbsp;lm/W</td></tr>
<tr><td>30&nbsp;min (route)</td><td>1500&nbsp;mA</td><td>3,207&nbsp;V</td><td>100,2&nbsp;°C</td><td>118,2&nbsp;°C</td><td>32&nbsp;K</td><td>494&nbsp;lm</td><td>4,81&nbsp;W</td><td>103&nbsp;lm/W</td></tr>
<tr><td>60&nbsp;min</td><td>1500&nbsp;mA</td><td>3,186&nbsp;V</td><td>110,9&nbsp;°C</td><td>129,0&nbsp;°C</td><td>21&nbsp;K</td><td>481&nbsp;lm</td><td>4,78&nbsp;W</td><td>101&nbsp;lm/W</td></tr>
</table>
<ul>
<li><code>headlamp.Phi_v</code> : +50&nbsp;% de courant ne donne qu'environ +40&nbsp;% de flux
(fléchissement aux forts courants, Fig. 4), et le flux baisse ensuite pendant que la LED
chauffe (Fig. 3) ;</li>
<li><code>headlamp.Tj</code>, <code>headlamp.T_plate</code> et <code>Tj_margin</code> : marge
par rapport à la limite Tj = 150&nbsp;°C ;</li>
<li><code>efficacy</code> : l'efficacité baisse avec le courant et la température.</li>
</ul>
<p>Au changement de courant, Tj saute de 7&nbsp;K : la jonction n'a pas de capacité thermique
propre dans le modèle (échauffement instantané à travers RthJC). Essayer
<code>headlamp.T_ambient</code> = 105&nbsp;°C : Tj atteint 131&nbsp;°C en croisement et
149,8&nbsp;°C en feu de route, à la limite du datasheet.</p>
<h4>Limites</h4>
<ul>
<li>Radiateur et air du phare réduits à une plaque et une résistance vers l'air
(valeurs plausibles, pas des mesures) ; driver idéal (changement de courant instantané).</li>
<li>Flux nominal = flux <em>minimal</em> de la référence (380&nbsp;lm à 1000&nbsp;mA, 85&nbsp;°C) :
le datasheet ne donne pas de valeur typique.</li>
</ul>
</html>"));
end HeadlampLowHighBeam;
