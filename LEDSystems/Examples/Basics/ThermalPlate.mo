within LEDSystems.Examples.Basics;
model ThermalPlate "Échauffement d'une plaque alu soumise à une puissance constante"
  extends Modelica.Icons.Example;

  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow heatSource(Q_flow = 0.1)
    "Puissance dissipée par une LED (0,1 W)"
    annotation (Placement(transformation(extent = {{-60, -10}, {-40, 10}})));
  LEDSystems.Thermal.Plate plate(
    R = 100,
    T_ambient = 293.15,
    area = 200e-6,
    thickness = 0.5e-3,
    T_start = 293.15)
    annotation (Placement(transformation(extent = {{20, -10}, {40, 10}})));

equation
  connect(heatSource.port, plate.port)
    annotation (Line(points = {{-40, 0}, {20, 0}}, color = {191, 0, 0}));

  annotation (
    experiment(StopTime = 150, Interval = 0.1),
    Documentation(info = "<html>
<p>Une source de 0,1&nbsp;W (qui joue le rôle de la LED) chauffe une plaque alu de
200&nbsp;mm² &times; 0,5&nbsp;mm, avec R = 100&nbsp;K/W vers l'air à 20&nbsp;°C.</p>
<p>Valeurs attendues :</p>
<ul>
<li>masse m = 2700 &times; 200&middot;10<sup>&minus;6</sup> &times; 0,5&middot;10<sup>&minus;3</sup>
    = 0,27&nbsp;g, capacité C = m&middot;c<sub>p</sub> = 0,243&nbsp;J/K ;</li>
<li>constante de temps &tau; = R&middot;C = 24,3&nbsp;s ;</li>
<li>régime établi : T = 20 + 0,1 &times; 100 = 30&nbsp;°C.</li>
</ul>
<p>À observer sur <code>plate.T</code> : 26,3&nbsp;°C à t = &tau; (63&nbsp;% de
l'échauffement), puis 30&nbsp;°C après environ 5&tau; &asymp; 120&nbsp;s.
Les valeurs <code>plate.C</code> et <code>plate.tau</code> sont visibles dans les résultats.</p>
</html>"));
end ThermalPlate;
