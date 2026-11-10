within LEDSystems.Examples.Basics;
model ThermalFixedTemperature "Température imposée : indépendante de la puissance reçue"
  extends Modelica.Icons.Example;

  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow heatSource(Q_flow = 0.1)
    "Puissance dissipée par une LED (0,1 W)"
    annotation (Placement(transformation(extent = {{-60, -10}, {-40, 10}})));
  LEDSystems.Thermal.FixedTemperature fixedTemperature(T = 323.15)
    annotation (Placement(transformation(extent = {{40, -10}, {20, 10}})));

equation
  connect(heatSource.port, fixedTemperature.port)
    annotation (Line(points = {{-40, 0}, {20, 0}}, color = {191, 0, 0}));

  annotation (
    experiment(StopTime = 10, Interval = 0.1),
    Documentation(info = "<html>
<p>Une source de 0,1&nbsp;W (qui joue le rôle de la LED) est branchée sur
<code>Thermal.FixedTemperature</code> réglé à 50&nbsp;°C.</p>
<p>À observer :</p>
<ul>
<li><code>fixedTemperature.port.T</code> reste à 50&nbsp;°C pendant toute la simulation ;</li>
<li><code>fixedTemperature.port.Q_flow</code> vaut +0,1&nbsp;W (convention de la MSL :
    positif quand la chaleur entre dans le composant) : toute la puissance est absorbée,
    sans aucun effet sur la température.</li>
</ul>
<p>C'est le principe du <em>rejeu</em> : la température est imposée, pas calculée.</p>
</html>"));
end ThermalFixedTemperature;
