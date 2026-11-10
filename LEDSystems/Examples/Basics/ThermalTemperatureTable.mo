within LEDSystems.Examples.Basics;
model ThermalTemperatureTable "Température imposée par une table, avec et sans filtre"
  extends Modelica.Icons.Example;

  LEDSystems.Thermal.TemperatureTable rawTable(
    table = [0, 25; 150, 37; 900, 50],
    tauFilter = 0) "Table seule"
    annotation (Placement(transformation(extent = {{-20, 10}, {0, 30}})));
  LEDSystems.Thermal.TemperatureTable filteredTable(
    table = [0, 25; 150, 37; 900, 50],
    tauFilter = 60) "Table lissée (constante de temps 60 s)"
    annotation (Placement(transformation(extent = {{-20, -30}, {0, -10}})));

  annotation (
    experiment(StopTime = 1200, Interval = 1),
    Documentation(info = "<html>
<p>Deux composants <code>Thermal.TemperatureTable</code> rejouent le même relevé
(25&nbsp;°C à 0&nbsp;s, 37&nbsp;°C à 150&nbsp;s, 50&nbsp;°C à 900&nbsp;s).</p>
<p>À observer :</p>
<ul>
<li><code>rawTable.port.T</code> passe exactement par les points de la table, en
    segments de droite, puis reste à 50&nbsp;°C après 900&nbsp;s ;</li>
<li><code>filteredTable.port.T</code> suit la même évolution avec un retard et des angles
    arrondis (filtre du 1er ordre de 60&nbsp;s).</li>
</ul>
<p>Aucune puissance n'est branchée : le rejeu ne dépend pas de la puissance.</p>
</html>"));
end ThermalTemperatureTable;
