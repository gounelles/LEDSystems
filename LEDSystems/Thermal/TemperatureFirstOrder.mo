within LEDSystems.Thermal;
model TemperatureFirstOrder "Température de jonction imposée selon un 1er ordre (rejeu)"
  import SI = Modelica.Units.SI;

  parameter SI.Temperature T_start = 293.15 "Température initiale"
    annotation (Dialog(group = "Scénario"));
  parameter SI.Temperature T_end = 323.15 "Température finale (régime établi)"
    annotation (Dialog(group = "Scénario"));
  parameter SI.Time tau63 = 900
    "Temps pour atteindre 63 % de l'écart (T_end - T_start)"
    annotation (Dialog(group = "Scénario"));

  SI.Temperature T "Température imposée au port";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port
    annotation (Placement(transformation(extent = {{90, -10}, {110, 10}})));

initial equation
  T = T_start;

equation
  assert(tau63 > 0, "TemperatureFirstOrder : tau63 doit être strictement positif.");
  der(T) = (T_end - T)/tau63;
  port.T = T;

  annotation (
    Icon(graphics = {
      Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {191, 0, 0},
        fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid),
      Line(points = {{-70, 60}, {-70, -60}, {70, -60}}, color = {0, 0, 0}),
      Line(points = {{-70, -50}, {-50, -6}, {-30, 18}, {-10, 32}, {10, 40}, {40, 46}, {70, 48}},
        color = {191, 0, 0}, thickness = 0.5, smooth = Smooth.Bezier),
      Line(points = {{-70, 50}, {70, 50}}, color = {191, 0, 0}, pattern = LinePattern.Dash),
      Text(extent = {{-150, 150}, {150, 110}}, textString = "%name", textColor = {0, 0, 255})}),
    Documentation(info = "<html>
<p>Impose au port une température qui évolue selon un <strong>1er ordre</strong> :</p>
<p>T(t) = T_end + (T_start &minus; T_end)&middot;e<sup>&minus;t/&tau;63</sup></p>
<p>À t = <code>tau63</code>, 63&nbsp;% de l'écart (T_end &minus; T_start) est parcouru ;
à 3&middot;<code>tau63</code>, 95&nbsp;%.</p>
<p>Usage : rejouer un relevé d'échauffement dont on a identifié la température finale
et la constante de temps. La température est imposée <em>sans tenir compte</em> de la
puissance dissipée : pour prédire l'échauffement, utiliser <code>Plate</code>.</p>
</html>"));
end TemperatureFirstOrder;
