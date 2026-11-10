within LEDSystems.Thermal;
model Plate "Plaque dissipatrice : capacité thermique et résistance vers l'ambiance (prédiction)"
  import SI = Modelica.Units.SI;

  parameter SI.ThermalResistance R = 360
    "Résistance thermique entre la plaque et l'air ambiant"
    annotation (Dialog(group = "Échange avec l'ambiance"));
  parameter SI.Temperature T_ambient = 293.15 "Température de l'air ambiant"
    annotation (Dialog(group = "Échange avec l'ambiance"));

  parameter SI.Area area(displayUnit = "mm2") = 200e-6
    "Surface de plaque attribuée à la LED"
    annotation (Dialog(group = "Géométrie"));
  parameter SI.Length thickness(displayUnit = "mm") = 0.5e-3 "Épaisseur de la plaque"
    annotation (Dialog(group = "Géométrie"));

  parameter SI.Density rho = 2700 "Masse volumique (défaut : aluminium)"
    annotation (Dialog(group = "Matériau"));
  parameter SI.SpecificHeatCapacity cp = 900
    "Capacité thermique massique (défaut : aluminium)"
    annotation (Dialog(group = "Matériau"));

  parameter SI.Temperature T_start = 293.15 "Température initiale de la plaque"
    annotation (Dialog(group = "Initialisation"));

  final parameter SI.Mass m = rho*area*thickness "Masse de la plaque";
  final parameter SI.HeatCapacity C = m*cp "Capacité thermique de la plaque";
  final parameter SI.Time tau = R*C "Constante de temps thermique";

  SI.Temperature T = capacitor.T "Température de la plaque";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port
    annotation (Placement(transformation(extent = {{-110, -10}, {-90, 10}})));

protected
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capacitor(
    final C = C,
    T(start = T_start, fixed = true))
    "Inertie thermique de la plaque"
    annotation (Placement(transformation(extent = {{-40, 10}, {-20, 30}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor resistor(final R = R)
    "Échange plaque - air (convection et rayonnement globalisés)"
    annotation (Placement(transformation(extent = {{0, -10}, {20, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature ambient(final T = T_ambient)
    "Air ambiant"
    annotation (Placement(transformation(extent = {{70, -10}, {50, 10}})));

equation
  assert(C > 0, "Plate : la capacité thermique doit être strictement positive (aire, épaisseur, rho, cp).");
  assert(R > 0, "Plate : R doit être strictement positive.");
  connect(port, capacitor.port)
    annotation (Line(points = {{-100, 0}, {-30, 0}, {-30, 10}}, color = {191, 0, 0}));
  connect(capacitor.port, resistor.port_a)
    annotation (Line(points = {{-30, 10}, {-30, 0}, {0, 0}}, color = {191, 0, 0}));
  connect(resistor.port_b, ambient.port)
    annotation (Line(points = {{20, 0}, {50, 0}}, color = {191, 0, 0}));

  annotation (
    Icon(graphics = {
      Rectangle(extent = {{-90, 20}, {90, -20}}, lineColor = {64, 64, 64},
        fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid),
      Line(points = {{-60, 30}, {-50, 50}, {-60, 70}, {-50, 90}}, color = {191, 0, 0},
        smooth = Smooth.Bezier),
      Line(points = {{0, 30}, {10, 50}, {0, 70}, {10, 90}}, color = {191, 0, 0},
        smooth = Smooth.Bezier),
      Line(points = {{60, 30}, {70, 50}, {60, 70}, {70, 90}}, color = {191, 0, 0},
        smooth = Smooth.Bezier),
      Text(extent = {{-150, -40}, {150, -70}}, textString = "R=%R"),
      Text(extent = {{-150, -110}, {150, -150}}, textString = "%name", textColor = {0, 0, 255})}),
    Documentation(info = "<html>
<p>Plaque (par défaut en aluminium) qui reçoit la puissance de la LED par son port et
la cède à l'air ambiant :</p>
<p>C&middot;dT/dt = Q &minus; (T &minus; T_ambient)/R &nbsp;&nbsp; avec C = &rho;&middot;c<sub>p</sub>&middot;aire&middot;épaisseur</p>
<ul>
<li>en régime établi : T = T_ambient + Q&middot;R ;</li>
<li>constante de temps : &tau; = R&middot;C (63&nbsp;% de l'échauffement final à t = &tau;).</li>
</ul>
<p><code>R</code> regroupe la convection et le rayonnement de la plaque vers l'air.
Branchée directement sur la jonction avec <code>R</code> = RthJA (datasheet), elle donne
un modèle simple d'auto-échauffement ; attention, le RthJA d'un datasheet est mesuré
sur une carte normalisée et ne correspond pas forcément à votre montage.</p>
<p>Ouvrir le diagramme pour voir le schéma équivalent : capacité, résistance, air ambiant.</p>
</html>"));
end Plate;
