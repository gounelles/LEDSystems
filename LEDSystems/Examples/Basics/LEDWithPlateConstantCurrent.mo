within LEDSystems.Examples.Basics;
model LEDWithPlateConstantCurrent "LED sur plaque alimentée à courant constant : auto-échauffement"
  extends Modelica.Icons.Example;

  Modelica.Electrical.Analog.Sources.ConstantCurrent source(I(displayUnit = "mA") = 0.02)
    "Courant constant de 20 mA"
    annotation(Placement(transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}})));
  LEDSystems.Components.LEDWithPlate ledWithPlate(
    redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data,
    T_ambient = 293.15)
    annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground gnd
    annotation(Placement(transformation(origin = {0, -40}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(source.n, ledWithPlate.p)
    annotation(Line(points = {{-30, 0}, {-10, 0}}, color = {0, 0, 255}));
  connect(ledWithPlate.n, gnd.p)
    annotation(Line(points = {{10, 0}, {20, 0}, {20, -30}, {0, -30}}, color = {0, 0, 255}));
  connect(source.p, gnd.p)
    annotation(Line(points = {{-50, 0}, {-60, 0}, {-60, -30}, {0, -30}}, color = {0, 0, 255}));

  annotation(
    experiment(StopTime = 600, Interval = 0.1),
    Documentation(info = "<html>
<p>La LED Vishay VLMW41S1T1, montée sur une plaque alu (bloc <code>LEDWithPlate</code>,
réglages par défaut), est alimentée à 20&nbsp;mA constants dans un air à 20&nbsp;°C.</p>
<p>Réglages par défaut : résistance plaque - air = RthJA &minus; RthJC = 350&nbsp;K/W (R_plateUsed), plaque de
200&nbsp;mm² &times; 0,5&nbsp;mm (C = 0,243&nbsp;J/K), d'où une constante de temps
d'environ 350 &times; 0,243 &asymp; 85&nbsp;s.</p>
<p>À observer :</p>
<ul>
<li><code>ledWithPlate.Tj</code> monte de 20,6&nbsp;°C jusqu'à T_ambient + Qth&middot;RthJA,
    soit environ 20 + 0,060 &times; 360 &asymp; 41,7&nbsp;°C (Qth &asymp; 60&nbsp;mW) ;
    la plaque atteint 63&nbsp;% de son échauffement final vers t = 85&nbsp;s ;</li>
<li><code>ledWithPlate.T_plate</code> reste en dessous de Tj de Qth&middot;RthJC &asymp; 0,6&nbsp;K ;</li>
<li><code>ledWithPlate.Vf</code> baisse de 3,32 à 3,24&nbsp;V (coefficient TCVf négatif) et
    <code>ledWithPlate.Phi_v</code> de 1,43 à 1,34&nbsp;lm (courbe Iv = f(T) du datasheet)
    pendant l'échauffement.</li>
</ul>
</html>"));
end LEDWithPlateConstantCurrent;
