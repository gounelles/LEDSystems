within LEDSystems.Examples.Basics;

model LEDSimpleElec "LED seule : rampe de courant, tension directe et flux"
  extends Modelica.Icons.Example;

  LEDSystems.Components.LED led(
    redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data)
    "LED Vishay VLMW41S1T1"
    annotation(
      Placement(transformation(extent = {{-20, -10}, {0, 10}})));

  Modelica.Electrical.Analog.Sources.RampCurrent rampCurrent(
    I(displayUnit = "mA") = 0.02,
    duration = 1,
    offset(displayUnit = "mA") = 0)
    "Rampe de 0 à 20 mA en 1 s"
    annotation(
      Placement(transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Electrical.Analog.Basic.Ground gnd
    annotation(
      Placement(transformation(origin = {2, 18}, extent = {{-80, -60}, {-60, -40}})));

  // Jonction reliée à une petite plaque alu (R = 100 K/W vers l'air à 20 °C)
  LEDSystems.Thermal.Plate plate(
    R = 100,
    T_ambient = 293.15,
    T_start = 293.15)
    "Plaque alu"
    annotation(
      Placement(transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(rampCurrent.n, led.p) annotation(
    Line(points = {{-30, 0}, {-20, 0}}, color = {0, 0, 255}));
  connect(led.n, gnd.p) annotation(
    Line(points = {{0, 0}, {12, 0}, {12, -22}, {-68, -22}}, color = {0, 0, 255}));
  connect(gnd.p, rampCurrent.p) annotation(
    Line(points = {{-68, -22}, {-68, 0}, {-50, 0}}, color = {0, 0, 255}));
  connect(led.heatPort, plate.port) annotation(
    Line(points = {{-16, 10}, {-16, 20}, {-50, 20}, {-50, 40}, {-40, 40}}, color = {191, 0, 0}));
  annotation(
    experiment(StopTime = 1.2, Interval = 0.001),
    Documentation(info = "<html>
<p>Premier exemple : une source de courant fait monter le courant de la LED Vishay
VLMW41S1T1 de 0 à 20&nbsp;mA en 1&nbsp;s (20&nbsp;mA est son courant continu maximal),
puis le maintient. La jonction est reliée à une petite plaque alu.</p>
<p>À observer (tracer en fonction de <code>led.If</code> pour obtenir les caractéristiques) :</p>
<ul>
<li><code>led.Vf</code> = f(<code>led.If</code>) : la caractéristique courant-tension d'une
    diode. Dès 0,1&nbsp;mA, la tension dépasse 2,5&nbsp;V ; ensuite, elle ne monte plus que
    lentement : 2,77&nbsp;V à 1&nbsp;mA, 3,12&nbsp;V à 10&nbsp;mA, 3,32&nbsp;V à 20&nbsp;mA ;</li>
<li><code>led.Phi_v</code> (flux, lm) et <code>led.Iv</code> (intensité, cd) : 1,43&nbsp;lm et 457&nbsp;mcd à 20&nbsp;mA (voir
    <code>LEDSimplePhoto</code> pour la photométrie) ;</li>
<li><code>led.P_elec</code>, <code>led.P_opt</code> et <code>led.Qth</code> : la plus grande
    part de la puissance électrique devient de la chaleur. À 20&nbsp;mA : P_elec = 66,3&nbsp;mW,
    P_opt = 4,8&nbsp;mW (7&nbsp;%), Qth = 61,6&nbsp;mW ;</li>
<li><code>led.Tj</code> : la jonction s'échauffe à peine en 1,2&nbsp;s (+0,17&nbsp;K), car la
    plaque a une constante de temps de 24&nbsp;s. Voir <code>ThermalPlate</code> et
    <code>LEDWithPlateConstantCurrent</code> pour l'échauffement.</li>
</ul>
</html>"));
end LEDSimpleElec;
