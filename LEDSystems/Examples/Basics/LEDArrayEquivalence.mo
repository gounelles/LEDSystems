within LEDSystems.Examples.Basics;
model LEDArrayEquivalence "LEDArray (3 x 2) et 6 LED câblées une par une : résultats identiques"
  extends Modelica.Icons.Example;

  // =========================
  // Circuit A : un seul composant LEDArray (Ns = 3 en série, Np = 2 branches)
  // =========================
  Modelica.Electrical.Analog.Sources.RampCurrent sourceA(I(displayUnit = "mA") = 0.04, duration = 10)
    "0 -> 40 mA en 10 s (20 mA par branche)"
    annotation(Placement(transformation(origin = {-80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  LEDSystems.Components.LEDArray ledArray(
    redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data,
    Ns = 3, Np = 2)
    annotation(Placement(transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}})));
  LEDSystems.Thermal.Plate plateA(R = 50, area = 1200e-6, T_ambient = 293.15, T_start = 293.15)
    "Plaque commune aux 6 LED (6 x 200 mm²)"
    annotation(Placement(transformation(origin = {-30, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground groundA
    annotation(Placement(transformation(origin = {-80, 20}, extent = {{-10, -10}, {10, 10}})));

  // =========================
  // Circuit B : 6 LED câblées une par une (2 branches de 3)
  // =========================
  Modelica.Electrical.Analog.Sources.RampCurrent sourceB(I(displayUnit = "mA") = 0.04, duration = 10)
    annotation(Placement(transformation(origin = {-80, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  LEDSystems.Components.LED led11(redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data)
    annotation(Placement(transformation(origin = {-20, -20}, extent = {{-10, -10}, {10, 10}})));
  LEDSystems.Components.LED led12(redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data)
    annotation(Placement(transformation(origin = {20, -20}, extent = {{-10, -10}, {10, 10}})));
  LEDSystems.Components.LED led13(redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data)
    annotation(Placement(transformation(origin = {60, -20}, extent = {{-10, -10}, {10, 10}})));
  LEDSystems.Components.LED led21(redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data)
    annotation(Placement(transformation(origin = {-20, -60}, extent = {{-10, -10}, {10, 10}})));
  LEDSystems.Components.LED led22(redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data)
    annotation(Placement(transformation(origin = {20, -60}, extent = {{-10, -10}, {10, 10}})));
  LEDSystems.Components.LED led23(redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data)
    annotation(Placement(transformation(origin = {60, -60}, extent = {{-10, -10}, {10, 10}})));
  LEDSystems.Thermal.Plate plateB(R = 50, area = 1200e-6, T_ambient = 293.15, T_start = 293.15)
    annotation(Placement(transformation(origin = {120, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground groundB
    annotation(Placement(transformation(origin = {-80, -110}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(sourceA.n, ledArray.p) annotation(Line(points = {{-80, 60}, {-80, 70}, {-20, 70}, {-20, 60}, {-10, 60}}, color = {0, 0, 255}));
  connect(ledArray.n, groundA.p) annotation(Line(points = {{10, 60}, {30, 60}, {30, 30}, {-80, 30}}, color = {0, 0, 255}));
  connect(sourceA.p, groundA.p) annotation(Line(points = {{-80, 40}, {-80, 30}}, color = {0, 0, 255}));
  connect(ledArray.heatPort, plateA.port) annotation(Line(points = {{-6, 70}, {-6, 76}, {-48, 76}, {-48, 90}, {-40, 90}}, color = {191, 0, 0}));
  connect(sourceB.p, groundB.p) annotation(Line(points = {{-80, -50}, {-80, -100}}, color = {0, 0, 255}));
  connect(sourceB.n, led11.p) annotation(Line(points = {{-70, -20}, {-40, -20}, {-40, -20}, {-30, -20}}, color = {0, 0, 255}));
  connect(led11.n, led12.p) annotation(Line(points = {{-10, -20}, {10, -20}}, color = {0, 0, 255}));
  connect(led12.n, led13.p) annotation(Line(points = {{30, -20}, {50, -20}}, color = {0, 0, 255}));
  connect(led13.n, groundB.p) annotation(Line(points = {{70, -20}, {90, -20}, {90, -90}, {-90, -90}}, color = {0, 0, 255}));
  connect(led11.heatPort, plateB.port) annotation(Line(points = {{-26, -10}, {-26, -6}, {-96, -6}, {-96, -100}, {100, -100}, {100, -40}, {110, -40}}, color = {191, 0, 0}));
  connect(led12.heatPort, plateB.port) annotation(Line(points = {{14, -10}, {14, -6}, {-96, -6}, {-96, -100}, {100, -100}, {100, -40}, {110, -40}}, color = {191, 0, 0}));
  connect(led13.heatPort, plateB.port) annotation(Line(points = {{54, -10}, {54, -6}, {-96, -6}, {-96, -100}, {100, -100}, {100, -40}, {110, -40}}, color = {191, 0, 0}));
  connect(sourceB.n, led21.p) annotation(Line(points = {{-70, -20}, {-40, -20}, {-40, -60}, {-30, -60}}, color = {0, 0, 255}));
  connect(led21.n, led22.p) annotation(Line(points = {{-10, -60}, {10, -60}}, color = {0, 0, 255}));
  connect(led22.n, led23.p) annotation(Line(points = {{30, -60}, {50, -60}}, color = {0, 0, 255}));
  connect(led23.n, groundB.p) annotation(Line(points = {{70, -60}, {90, -60}, {90, -90}, {-90, -90}}, color = {0, 0, 255}));
  connect(led21.heatPort, plateB.port) annotation(Line(points = {{-26, -50}, {-26, -46}, {-96, -46}, {-96, -100}, {100, -100}, {100, -40}, {110, -40}}, color = {191, 0, 0}));
  connect(led22.heatPort, plateB.port) annotation(Line(points = {{14, -50}, {14, -46}, {-96, -46}, {-96, -100}, {100, -100}, {100, -40}, {110, -40}}, color = {191, 0, 0}));
  connect(led23.heatPort, plateB.port) annotation(Line(points = {{54, -50}, {54, -46}, {-96, -46}, {-96, -100}, {100, -100}, {100, -40}, {110, -40}}, color = {191, 0, 0}));

  annotation(
    experiment(StopTime = 300, Interval = 0.1),
    Diagram(coordinateSystem(extent = {{-140, -140}, {140, 120}})),
    Documentation(info = "<html>
<p>Deux circuits indépendants, alimentés par la même rampe de courant (0 &rarr; 40&nbsp;mA
en 10&nbsp;s, soit 20&nbsp;mA par branche), sur deux plaques identiques
(R = 50&nbsp;K/W, 1200&nbsp;mm²) :</p>
<ul>
<li><b>A</b> : un seul composant <code>LEDArray</code> (3 LED en série &times; 2 branches) ;</li>
<li><b>B</b> : les 6 LED câblées une par une, toutes sur la même plaque.</li>
</ul>
<p>Les résultats sont <strong>identiques</strong> : <code>ledArray.v</code> et la tension aux
bornes de <code>sourceB</code>, <code>ledArray.Tj</code> et la température de jonction de
chaque LED de B, <code>ledArray.Phi_v</code> et la somme des flux des 6 LED. Dans A, une
seule LED est calculée puis mise à l'échelle : c'est le modèle rapide pour des LED
identiques sur un même support.</p>
<p>À observer aussi : <code>ledArray.If</code> (courant d'une LED, 20&nbsp;mA) et
<code>ledArray.i</code> (courant total, 40&nbsp;mA).</p>
</html>"));
end LEDArrayEquivalence;
