within LEDSystems.Examples.Basics;
model ThermalTemperatureFirstOrder "Température imposée selon un 1er ordre"
  extends Modelica.Icons.Example;

  LEDSystems.Thermal.TemperatureFirstOrder firstOrder(
    T_start = 298.15,
    T_end = 338.15,
    tau63 = 900)
    annotation (Placement(transformation(extent = {{-10, -10}, {10, 10}})));

  annotation (
    experiment(StopTime = 4500, Interval = 1),
    Documentation(info = "<html>
<p><code>Thermal.TemperatureFirstOrder</code> fait passer la température de 25&nbsp;°C
à 65&nbsp;°C avec une constante de temps de 900&nbsp;s.</p>
<p>À observer sur <code>firstOrder.T</code> :</p>
<ul>
<li>à t = 900&nbsp;s (&tau;63) : 25 + 0,632&times;40 &asymp; 50,3&nbsp;°C ;</li>
<li>à t = 2700&nbsp;s (3&tau;) : 95&nbsp;% de l'écart, soit &asymp; 63&nbsp;°C ;</li>
<li>à t = 4500&nbsp;s (5&tau;) : la température finale est pratiquement atteinte.</li>
</ul>
</html>"));
end ThermalTemperatureFirstOrder;
