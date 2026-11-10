within LEDSystems.Thermal;
model TemperatureTable "Température de jonction imposée par une table de mesures (rejeu)"
  import SI = Modelica.Units.SI;

  parameter Real table[:, 2] = [0, 25; 600, 65]
    "Table (t en s, T en °C). Au-delà du dernier point : maintien de la dernière valeur"
    annotation (Dialog(group = "Mesures"));
  parameter SI.Time tauFilter = 0
    "Constante de temps du filtre du 1er ordre appliqué à la table (0 = pas de filtre)"
    annotation (Dialog(group = "Mesures"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port(T(start = T_start))
    annotation (Placement(transformation(extent = {{90, -10}, {110, 10}})));

protected
  final parameter Modelica.Units.SI.Temperature T_start =
    Modelica.Units.Conversions.from_degC(table[1, 2])
    "Première valeur de la table, en K (valeur initiale du filtre et des ports)";
  final parameter Boolean useFilter = tauFilter > 0
    "Filtre actif"
    annotation (Evaluate = true);

  Modelica.Blocks.Sources.CombiTimeTable timeTable(
    final table = table,
    final columns = {2},
    final smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments,
    final extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    "Table en °C"
    annotation (Placement(transformation(extent = {{-80, -10}, {-60, 10}})));
  Modelica.Blocks.Math.UnitConversions.From_degC fromDegC
    "Conversion °C vers K"
    annotation (Placement(transformation(extent = {{-40, -10}, {-20, 10}})));
  Modelica.Blocks.Continuous.FirstOrder filter(
    final k = 1,
    final T = tauFilter,
    final initType = Modelica.Blocks.Types.Init.InitialOutput,
    final y_start = T_start) if useFilter
    "Filtre optionnel (lissage de mesures bruitées)"
    annotation (Placement(transformation(extent = {{0, 20}, {20, 40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature(
    port(T(start = T_start)))
    annotation (Placement(transformation(extent = {{50, -10}, {70, 10}})));

equation
  connect(timeTable.y[1], fromDegC.u)
    annotation (Line(points = {{-59, 0}, {-42, 0}}, color = {0, 0, 127}));
  if useFilter then
    connect(fromDegC.y, filter.u)
      annotation (Line(points = {{-19, 0}, {-10, 0}, {-10, 30}, {-2, 30}}, color = {0, 0, 127}));
    connect(filter.y, prescribedTemperature.T)
      annotation (Line(points = {{21, 30}, {36, 30}, {36, 0}, {48, 0}}, color = {0, 0, 127}));
  else
    connect(fromDegC.y, prescribedTemperature.T)
      annotation (Line(points = {{-19, 0}, {48, 0}}, color = {0, 0, 127}));
  end if;
  connect(prescribedTemperature.port, port)
    annotation (Line(points = {{70, 0}, {100, 0}}, color = {191, 0, 0}));

  annotation (
    Icon(graphics = {
      Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {191, 0, 0},
        fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid),
      Line(points = {{-70, 60}, {-70, -60}, {70, -60}}, color = {0, 0, 0}),
      Line(points = {{-70, -40}, {-30, -10}, {0, 0}, {30, 30}, {60, 30}},
        color = {191, 0, 0}, thickness = 0.5),
      Ellipse(extent = {{-34, -6}, {-26, -14}}, lineColor = {191, 0, 0},
        fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid),
      Ellipse(extent = {{26, 34}, {34, 26}}, lineColor = {191, 0, 0},
        fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid),
      Text(extent = {{-150, 150}, {150, 110}}, textString = "%name", textColor = {0, 0, 255})}),
    Documentation(info = "<html>
<p>Impose au port une température qui suit une <strong>table de mesures</strong>
(t en s, T en °C), interpolée linéairement ; après le dernier point, la dernière valeur
est maintenue.</p>
<p>Si <code>tauFilter</code> &gt; 0, la table est lissée par un filtre du 1er ordre de
constante de temps <code>tauFilter</code> (utile pour des mesures bruitées : avec 30&nbsp;s,
la température ne peut pas varier plus vite que ne le permet une constante de temps
de 30&nbsp;s).</p>
<p>Comme tous les composants de rejeu, il impose la température <em>sans tenir compte</em>
de la puissance dissipée par la LED.</p>
</html>"));
end TemperatureTable;
