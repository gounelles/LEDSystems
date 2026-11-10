within LEDSystems.Examples.Basics;
model LEDMatrixCurrentSharing "Partage du courant entre LED en parallèle : effet de la dispersion et du ballast"
  extends Modelica.Icons.Example;

  // Dispersion de Vf des 4 LED (une par branche) : même tableau dVf dans A et dans B

  // =========================
  // A : 4 LED en parallèle directement sous 3,30 V
  // =========================
  Modelica.Electrical.Analog.Sources.ConstantVoltage sourceA(V = 3.30)
    annotation(Placement(transformation(origin = {-60, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  LEDSystems.Components.LEDMatrix matrixA(
    redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data,
    Ns = 1, Np = 4, R_ballast = 0, dVf = [-0.2, -0.1, 0.1, 0.2])
    annotation(Placement(transformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}})));
  LEDSystems.Thermal.FixedTemperature boardA(T = 298.15) "Carte maintenue à 25 °C"
    annotation(Placement(transformation(origin = {-30, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground groundA
    annotation(Placement(transformation(origin = {-60, 10}, extent = {{-10, -10}, {10, 10}})));

  // =========================
  // B : les mêmes LED, avec un ballast de 10 Ohm par branche, sous 3,50 V
  // =========================
  Modelica.Electrical.Analog.Sources.ConstantVoltage sourceB(V = 3.50)
    annotation(Placement(transformation(origin = {-60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  LEDSystems.Components.LEDMatrix matrixB(
    redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data,
    Ns = 1, Np = 4, R_ballast = 10, dVf = [-0.2, -0.1, 0.1, 0.2])
    annotation(Placement(transformation(origin = {0, -40}, extent = {{-10, -10}, {10, 10}})));
  LEDSystems.Thermal.FixedTemperature boardB(T = 298.15) "Carte maintenue à 25 °C"
    annotation(Placement(transformation(origin = {-30, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground groundB
    annotation(Placement(transformation(origin = {-60, -70}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(sourceA.p, matrixA.p) annotation(Line(points = {{-60, 50}, {-60, 56}, {-20, 56}, {-20, 40}, {-10, 40}}, color = {0, 0, 255}));
  connect(matrixA.n, groundA.p) annotation(Line(points = {{10, 40}, {20, 40}, {20, 20}, {-60, 20}}, color = {0, 0, 255}));
  connect(sourceA.n, groundA.p) annotation(Line(points = {{-60, 30}, {-60, 20}}, color = {0, 0, 255}));
  connect(boardA.port, matrixA.heatPort) annotation(Line(points = {{-20, 70}, {-6, 70}, {-6, 50}}, color = {191, 0, 0}));
  connect(sourceB.p, matrixB.p) annotation(Line(points = {{-60, -30}, {-60, -24}, {-20, -24}, {-20, -40}, {-10, -40}}, color = {0, 0, 255}));
  connect(matrixB.n, groundB.p) annotation(Line(points = {{10, -40}, {20, -40}, {20, -60}, {-60, -60}}, color = {0, 0, 255}));
  connect(sourceB.n, groundB.p) annotation(Line(points = {{-60, -50}, {-60, -60}}, color = {0, 0, 255}));
  connect(boardB.port, matrixB.heatPort) annotation(Line(points = {{-20, -10}, {-6, -10}, {-6, -30}}, color = {191, 0, 0}));

  annotation(
    experiment(StopTime = 1, Interval = 0.01),
    Documentation(info = "<html>
<p>Quatre LED Vishay VLMW41S1T1 montées <strong>en parallèle</strong> et alimentées
<strong>en tension</strong> (comme un spot solaire branché directement sur sa batterie).
Leurs tensions directes diffèrent de &minus;0,2 / &minus;0,1 / +0,1 / +0,2&nbsp;V
(dispersion de fabrication, paramètre <code>dVf</code>). La carte est maintenue à 25&nbsp;°C.</p>
<ul>
<li><b>A</b> : sous 3,30&nbsp;V, sans ballast ;</li>
<li><b>B</b> : sous 3,50&nbsp;V, avec une résistance de 10&nbsp;&Omega; en série dans chaque branche.</li>
</ul>
<p>À observer : <code>matrixA.If_branch</code> et <code>matrixB.If_branch</code>.</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>dVf</th><th>A : courant</th><th>B : courant</th></tr>
<tr><td>&minus;0,2&nbsp;V</td><td>32,0&nbsp;mA</td><td>27,4&nbsp;mA</td></tr>
<tr><td>&minus;0,1&nbsp;V</td><td>25,9&nbsp;mA</td><td>23,7&nbsp;mA</td></tr>
<tr><td>+0,1&nbsp;V</td><td>14,8&nbsp;mA</td><td>16,6&nbsp;mA</td></tr>
<tr><td>+0,2&nbsp;V</td><td>10,0&nbsp;mA</td><td>13,2&nbsp;mA</td></tr>
<tr><td>rapport max/min</td><td>3,2</td><td>2,1</td></tr>
</table>
<p>Sans ballast, la LED dont la tension directe est la plus faible prend trois fois plus
de courant que celle dont la tension est la plus forte : elle chauffe davantage, éclaire
davantage, et vieillit plus vite. La résistance série interne de la LED (environ 13&nbsp;&Omega;)
limite déjà ce déséquilibre ; un ballast l'atténue encore, au prix d'une perte de
puissance dans les résistances. Le courant moyen est d'environ 20&nbsp;mA par LED,
mais la LED la plus favorisée dépasse le courant continu maximal du datasheet
(20&nbsp;mA) dans les deux cas : un calcul fait sur la seule LED typique ne le montre
pas. Voir aussi <code>led[1,k].Iv</code> (écarts de luminosité)
et <code>led[1,k].Tj</code>.</p>
</html>"));
end LEDMatrixCurrentSharing;
