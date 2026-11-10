within LEDSystems.Thermal;
model FixedTemperature "Température de jonction constante imposée (rejeu)"
  extends Modelica.Thermal.HeatTransfer.Sources.FixedTemperature(
    T = 323.15);

  annotation (Documentation(info="<html>
<p>Impose une température constante <code>T</code> au port, quelle que soit la puissance
reçue. Branché sur le <code>heatPort</code> d'une LED, il fixe sa température de jonction.</p>
<p>Usage : caractériser la LED à température connue (par exemple 25&nbsp;°C, condition
des datasheets), ou rejouer une mesure en régime établi. Ce composant ne <em>prédit</em>
pas l'échauffement : pour cela, utiliser <code>Plate</code>.</p>
<p>Reprend le composant <code>Modelica.Thermal.HeatTransfer.Sources.FixedTemperature</code>
de la MSL, avec une valeur par défaut de 50&nbsp;°C.</p>
</html>"));
end FixedTemperature;
