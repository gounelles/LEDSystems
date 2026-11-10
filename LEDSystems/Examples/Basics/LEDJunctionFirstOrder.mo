within LEDSystems.Examples.Basics;

model LEDJunctionFirstOrder "LED à courant constant, température de jonction imposée selon un 1er ordre (rejeu)"
  extends Modelica.Icons.Example;

  LEDSystems.Components.LED led(
    redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data)
    "LED Vishay VLMW41S1T1"
    annotation(
      Placement(transformation(extent = {{-20, -10}, {0, 10}})));

  Modelica.Electrical.Analog.Sources.ConstantCurrent constantCurrent(
    I(displayUnit = "mA") = 0.02)
    "Courant constant de 20 mA"
    annotation(
      Placement(transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Electrical.Analog.Basic.Ground gnd
    annotation(
      Placement(transformation(origin = {2, 18}, extent = {{-80, -60}, {-60, -40}})));

  // Température de jonction imposée (rejeu d'un relevé d'échauffement)
  LEDSystems.Thermal.TemperatureFirstOrder temperatureFirstOrder(
    T_start = 298.15,
    T_end = 338.15,
    tau63 = 900)
    "De 25 °C à 65 °C, constante de temps 900 s"
    annotation(
      Placement(transformation(origin = {-40, 40}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(temperatureFirstOrder.port, led.heatPort) annotation(
    Line(points = {{-30, 40}, {-16, 40}, {-16, 10}}, color = {191, 0, 0}));
  connect(constantCurrent.n, led.p) annotation(
    Line(points = {{-30, 0}, {-20, 0}}, color = {0, 0, 255}));
  connect(led.n, gnd.p) annotation(
    Line(points = {{0, 0}, {12, 0}, {12, -22}, {-68, -22}}, color = {0, 0, 255}));
  connect(constantCurrent.p, gnd.p) annotation(
    Line(points = {{-50, 0}, {-68, 0}, {-68, -22}}, color = {0, 0, 255}));
  annotation(
    experiment(StopTime = 3000, Interval = 1, StartTime = 0, Tolerance = 1e-06),
    Documentation(info = "<html>
<p>La LED Vishay VLMW41S1T1 est alimentée à 20&nbsp;mA constants. Sa température de
jonction est imposée par <code>Thermal.TemperatureFirstOrder</code> : de 25&nbsp;°C vers
65&nbsp;°C, constante de temps 900&nbsp;s. C'est un <em>rejeu</em> : la température suit
un relevé, elle ne dépend pas de la puissance dissipée. On isole ainsi l'effet de la
température sur la LED.</p>
<p>À observer (en fonction du temps, ou de <code>led.Tj</code>) :</p>
<ul>
<li><code>led.Tj</code> : 25&nbsp;°C au départ, 50,3&nbsp;°C à t = 900&nbsp;s (63&nbsp;% de l'écart), 63,6&nbsp;°C à 3000&nbsp;s ;</li>
<li><code>led.Vf</code> baisse quand la jonction chauffe (coefficient TCVf négatif) :
    3,300&nbsp;V, puis 3,211&nbsp;V à 900&nbsp;s et 3,165&nbsp;V à 3000&nbsp;s (&minus;3,5&nbsp;mV/K) ;</li>
<li><code>led.Phi_v</code> baisse aussi (courbe Iv = f(T) du datasheet) : 1,421&nbsp;lm, puis 1,277&nbsp;lm à 900&nbsp;s et
    1,182&nbsp;lm à 3000&nbsp;s, soit &minus;17&nbsp;% pour un échauffement de 39&nbsp;K.</li>
</ul>
</html>"));
end LEDJunctionFirstOrder;
