within LEDSystems.Examples.Basics;

model LEDSimplePhoto "Photométrie d'une LED : intensité en fonction du courant et de la température"
  extends Modelica.Icons.Example;

  Modelica.Electrical.Analog.Sources.RampCurrent rampCurrent(
    I(displayUnit = "mA") = 0.02,
    duration = 1,
    offset(displayUnit = "mA") = 0)
    "Rampe de 0 à 20 mA en 1 s, commune aux deux LED (en série)"
    annotation(
      Placement(transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}})));

  LEDSystems.Components.LED led25(
    redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data)
    "LED dont la jonction est maintenue à 25 °C"
    annotation(
      Placement(transformation(extent = {{-30, -10}, {-10, 10}})));

  LEDSystems.Components.LED led85(
    redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data)
    "LED dont la jonction est maintenue à 85 °C"
    annotation(
      Placement(transformation(extent = {{10, -10}, {30, 10}})));

  LEDSystems.Thermal.FixedTemperature junction25(T = 298.15)
    "Jonction à 25 °C"
    annotation(
      Placement(transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}})));

  LEDSystems.Thermal.FixedTemperature junction85(T = 358.15)
    "Jonction à 85 °C"
    annotation(
      Placement(transformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Electrical.Analog.Basic.Ground gnd
    annotation(
      Placement(transformation(origin = {-80, -30}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(rampCurrent.n, led25.p) annotation(
    Line(points = {{-50, 0}, {-30, 0}}, color = {0, 0, 255}));
  connect(led25.n, led85.p) annotation(
    Line(points = {{-10, 0}, {10, 0}}, color = {0, 0, 255}));
  connect(led85.n, gnd.p) annotation(
    Line(points = {{30, 0}, {40, 0}, {40, -20}, {-80, -20}}, color = {0, 0, 255}));
  connect(rampCurrent.p, gnd.p) annotation(
    Line(points = {{-70, 0}, {-80, 0}, {-80, -20}}, color = {0, 0, 255}));
  connect(junction25.port, led25.heatPort) annotation(
    Line(points = {{-40, 40}, {-26, 40}, {-26, 10}}, color = {191, 0, 0}));
  connect(junction85.port, led85.heatPort) annotation(
    Line(points = {{10, 40}, {14, 40}, {14, 10}}, color = {191, 0, 0}));
  annotation(
    experiment(StopTime = 1, Interval = 0.001),
    Documentation(info = "<html>
<p>Deux LED Vishay VLMW41S1T1 identiques, en série, sont traversées par le même courant :
une rampe de 0 à 20&nbsp;mA en 1&nbsp;s (20&nbsp;mA est le courant continu maximal du
datasheet). Leurs jonctions sont maintenues à <strong>25&nbsp;°C</strong> et à
<strong>85&nbsp;°C</strong> par <code>Thermal.FixedTemperature</code> : ce <em>rejeu</em>
isole l'effet du courant et celui de la température, sans couplage thermique.</p>
<p>À observer, en traçant en fonction de <code>led25.If</code> (tracé paramétrique :
nouvelle fenêtre de tracé paramétrique, puis, dans le navigateur de variables, maintenir la
touche Maj enfoncée et cliquer sur la variable à afficher en x, relâcher Maj et cliquer sur la
variable en y ; détail dans
<a href=\"modelica://LEDSystems.UsersGuide.Conventions\">Conventions</a>) :</p>
<ul>
<li><strong>Intensité et courant</strong> : <code>led25.Iv</code> (en mcd) n'est pas
    proportionnelle au courant : elle suit la courbe Iv relative = f(If) du datasheet (Fig. 5),
    et le rapport Iv/If varie avec le courant.
    <table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
    <tr><th>If</th><th>1&nbsp;mA</th><th>3&nbsp;mA</th><th>10&nbsp;mA</th><th>20&nbsp;mA</th></tr>
    <tr><td>Iv (25&nbsp;°C)</td><td>33&nbsp;mcd</td><td>69&nbsp;mcd</td><td>275&nbsp;mcd</td><td>452&nbsp;mcd</td></tr>
    <tr><td>Iv/If</td><td>33&nbsp;mcd/mA</td><td>23&nbsp;mcd/mA</td><td>27,5&nbsp;mcd/mA</td><td>22,6&nbsp;mcd/mA</td></tr>
    </table>
    275&nbsp;mcd à 10&nbsp;mA est la valeur de référence du datasheet (<code>Iv_nom</code> à
    <code>If_nom</code>).</li>
<li><strong>Intensité et flux</strong> : <code>led25.Phi_v</code>/<code>led25.Iv</code> est
    constant et vaut 2&pi;/(m+1) = &pi;&nbsp;sr &asymp; 3,14&nbsp;lm/cd. Le flux se déduit de
    l'intensité dans l'axe par l'indicatrice d'émission (lambertienne, angle de
    demi-intensité de 60°, d'où m = 1). À 20&nbsp;mA : 452&nbsp;mcd &times; &pi; = 1,42&nbsp;lm.</li>
<li><strong>Température</strong> : <code>led85.Iv</code>/<code>led25.Iv</code> vaut 0,73 à tous les courants
    (courbe Iv relative = f(T) du datasheet, Fig. 7, appliquée à la jonction). La tension
    baisse aussi : <code>led85.Vf</code> est inférieure de 0,21&nbsp;V à <code>led25.Vf</code>
    (3,09 contre 3,30&nbsp;V à 20&nbsp;mA, &minus;3,5&nbsp;mV/K).</li>
</ul>
</html>"));
end LEDSimplePhoto;
