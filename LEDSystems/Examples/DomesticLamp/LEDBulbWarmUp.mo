within LEDSystems.Examples.DomesticLamp;
model LEDBulbWarmUp
  "Ampoule à LED : 18 LED en série à courant constant, montée en température après l'allumage"
  extends Modelica.Icons.Example;
  import SI = Modelica.Units.SI;

  // =========================
  // Composants
  // (valeurs saisies directement sur les composants : double-clic dans OMEdit)
  // =========================
  Modelica.Electrical.Analog.Sources.ConstantCurrent driver(I = 0.120)
    "Driver à courant constant, 120 mA (allumé dès t = 0)"
    annotation(Placement(transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation(Placement(transformation(origin = {-60, -40}, extent = {{-10, -10}, {10, 10}})));
  // Dispersion de la tension directe (onglet « Avancé » de la matrice), tirage reproductible :
  // Vf de 2,8 à 3,2 V à 150 mA (min et max garantis, Tab. 1 du DS242), typique 3,0 V ;
  // dVf = décalage par rapport à la courbe typique du record (3,0 V à 150 mA).
  LEDSystems.Components.LEDMatrix matrix(
    redeclare LEDSystems.Data.Bridgelux_BXEN_30G_11M data,
    Ns = 18, Np = 1, R_ballast = 0,
    dVf = transpose({LEDSystems.Functions.dispersion(18, 3.0, 2.8, 3.2, seed = 1) .- 3.0}))
    "18 LED en série (une seule branche)"
    annotation(Placement(transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}})));
  LEDSystems.Thermal.Plate plate(
    R = 10, T_ambient = 298.15, area = 2e-3, thickness = 5e-3, T_start = 298.15)
    "Radiateur alu de l'ampoule (27 g), air à 25 °C (changer T_ambient ET T_start)"
    annotation(Placement(transformation(origin = {-30, 40}, extent = {{10, -10}, {-10, 10}})));

  // =========================
  // Grandeurs à observer
  // =========================
  SI.Power P_opt = sum(matrix.led.P_opt) "Puissance optique totale";
  Real efficacy(unit = "lm/W") = matrix.Phi_v/max(matrix.P_elec, 1e-9) "Efficacité lumineuse";

equation
  connect(driver.n, matrix.p) annotation(Line(points = {{-60, 10}, {-60, 20}, {-20, 20}, {-20, 0}, {-10, 0}}, color = {0, 0, 255}));
  connect(matrix.n, ground.p) annotation(Line(points = {{10, 0}, {20, 0}, {20, -30}, {-60, -30}}, color = {0, 0, 255}));
  connect(driver.p, ground.p) annotation(Line(points = {{-60, -10}, {-60, -30}}, color = {0, 0, 255}));
  connect(plate.port, matrix.heatPort) annotation(Line(points = {{-20, 40}, {-6, 40}, {-6, 10}}, color = {191, 0, 0}));

  annotation(
    experiment(StartTime = 0, StopTime = 1800, Interval = 1),
    Documentation(info = "<html>
<p>Ampoule à LED : 18 LED Bridgelux SMD 2835 0,5&nbsp;W 3&nbsp;V (DS242, 3000&nbsp;K, IRC 90)
<strong>en série</strong>, alimentées par un driver à <strong>courant constant</strong> de
120&nbsp;mA, et soudées sur une carte commune fixée au radiateur en aluminium de l'ampoule
(<code>plate</code> : 27&nbsp;g, résistance radiateur - air de 10&nbsp;K/W, hypothèse). L'air est
à 25&nbsp;°C ; la lampe est allumée à froid à t = 0.</p>

<h4>À observer</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>t</th><th>Radiateur</th><th>Tj max</th><th>Tension de la chaîne</th>
<th>Flux</th><th>P élec.</th><th>Chaleur</th><th>Efficacité</th></tr>
<tr><td>0</td><td>25,0&nbsp;°C</td><td>34,1&nbsp;°C</td><td>52,75&nbsp;V</td><td>883&nbsp;lm</td><td>6,33&nbsp;W</td><td>3,29&nbsp;W</td><td>140&nbsp;lm/W</td></tr>
<tr><td>4&nbsp;min</td><td>45,8&nbsp;°C</td><td>55,0&nbsp;°C</td><td>52,25&nbsp;V</td><td>853&nbsp;lm</td><td>6,27&nbsp;W</td><td>3,33&nbsp;W</td><td>136&nbsp;lm/W</td></tr>
<tr><td>30&nbsp;min</td><td>58,6&nbsp;°C</td><td>67,8&nbsp;°C</td><td>51,93&nbsp;V</td><td>834&nbsp;lm</td><td>6,23&nbsp;W</td><td>3,36&nbsp;W</td><td>134&nbsp;lm/W</td></tr>
</table>
<p>Le flux perd environ 6&nbsp;% entre l'allumage et le régime établi. À t = 0, les jonctions
sont déjà 9&nbsp;K au-dessus du radiateur : le modèle ne leur donne pas de capacité
thermique propre (échauffement instantané, à travers RthJC).</p>
<ul>
<li><code>plate.T</code> et <code>matrix.Tj_max</code> : montée en température, constante de
temps <code>plate.tau</code> = R&middot;C &asymp; 4&nbsp;min ;</li>
<li><code>matrix.Phi_v</code> : le flux baisse pendant la mise en température (Fig. 4 du
datasheet), alors que le courant reste constant ;</li>
<li><code>matrix.v</code> : la tension de la chaîne (environ 18 &times; 2,9&nbsp;V) baisse elle
aussi (&minus;1,35&nbsp;mV/K par LED) : le driver s'y adapte ;</li>
<li><code>matrix.led[j,1].Vf</code> : la dispersion de tension directe ne change pas le courant
(série), seulement la tension de la chaîne.</li>
</ul>
<p>En régime établi : T_plaque = T_air + Qth&middot;R, avec Qth = P_elec &minus; P_opt
(<code>matrix.Qth</code>).</p>

<h4>Limites</h4>
<ul>
<li>Radiateur et enveloppe de l'ampoule réduits à une plaque et une résistance vers l'air
(valeurs plausibles, pas des mesures) ; driver idéal.</li>
<li>Le datasheet donne le flux à 85&nbsp;°C de deux façons incohérentes (Tab. 3 hors courant
nominal, environ 7&nbsp;% plus bas) : le modèle suit la Fig. 4.</li>
</ul>
</html>"));
end LEDBulbWarmUp;
