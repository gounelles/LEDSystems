within LEDSystems.Components;
model LEDMatrix
  "Matrice de Ns x Np LED individuelles (dispersion) : Np branches en parallèle de Ns LED en série, sur une carte commune"
  import SI = Modelica.Units.SI;

  // =========================
  // Paramètres
  // =========================
  replaceable parameter LEDSystems.Data.LEDData data
    constrainedby LEDSystems.Data.LEDData
    "Données des LED (datasheet), communes à toutes les LED"
    annotation(
      HideResult = true,
      choicesAllMatching = true,
      Evaluate = true,
      Dialog(group = "Datasheet : bouton à droite pour voir ou modifier les valeurs"));

  parameter Integer Ns(min = 1) = 3 "Nombre de LED en série dans une branche"
    annotation(Evaluate = true, Dialog(group = "Assemblage"));
  parameter Integer Np(min = 1) = 2 "Nombre de branches en parallèle"
    annotation(Evaluate = true, Dialog(group = "Assemblage"));
  parameter SI.Resistance R_ballast = 0
    "Résistance de ballast en tête de chaque branche (0 = pas de ballast)"
    annotation(Dialog(group = "Assemblage"));

  // Dispersion : indice [position dans la branche, branche]
  parameter SI.Voltage dVf[Ns, Np] = zeros(Ns, Np)
    "Décalage de la tension directe de chaque LED [position, branche]"
    annotation(Dialog(tab = "Avancé", group = "Dispersion"));
  parameter Real kIv[Ns, Np](each unit = "1", each min = 0) = ones(Ns, Np)
    "Facteur d'intensité lumineuse de chaque LED [position, branche]"
    annotation(Dialog(tab = "Avancé", group = "Dispersion"));

  // =========================
  // Interfaces
  // =========================
  Modelica.Electrical.Analog.Interfaces.PositivePin p "Entrée des branches"
    annotation(Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n "Sortie des branches"
    annotation(Placement(transformation(extent = {{90, -10}, {110, 10}})));
  // Port thermique : la CARTE commune (et non une jonction, contrairement à LED)
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Carte commune : chaque LED y est reliée par sa résistance jonction - boîtier RthJC_heat"
    annotation(Placement(
      transformation(origin = {-60, 0}, extent = {{-10, 90}, {10, 110}}),
      iconTransformation(origin = {-60, 0}, extent = {{-10, 90}, {10, 110}})));
  LEDSystems.Interfaces.LightPort lightPort "Flux et intensité totaux"
    annotation(Placement(
      transformation(origin = {-40, 68}, extent = {{90, 20}, {110, 40}}),
      iconTransformation(origin = {-40, 68}, extent = {{90, 20}, {110, 40}})));

  // =========================
  // Composants (publics : led[j, k].If, led[j, k].Tj... sont visibles dans les résultats)
  // =========================
  LEDSystems.Components.LED led[Ns, Np](
    each data = data,
    dVf = dVf,
    kIv = kIv) "LED [position dans la branche, branche]"
    annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Resistor ballast[Np](each R = R_ballast)
    "Résistance de ballast de chaque branche"
    annotation(Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor rthJC[Ns, Np](each R = data.RthJC_heat)
    "Résistance jonction - boîtier de chaque LED, vers la carte"
    annotation(Placement(transformation(origin = {-6, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // =========================
  // Grandeurs utiles en simulation
  // =========================
  SI.Voltage v "Tension aux bornes de la matrice";
  SI.Current i(displayUnit = "mA") "Courant total";
  SI.Current If_branch[Np](each displayUnit = "mA") "Courant de chaque branche";
  SI.LuminousIntensity Iv(displayUnit = "mcd") "Intensité lumineuse totale";
  SI.LuminousFlux Phi_v "Flux lumineux total";
  SI.Power P_elec "Puissance électrique absorbée par les LED";
  SI.HeatFlowRate Qth "Puissance dissipée en chaleur par les LED";
  SI.Temperature Tj_max "Température de jonction la plus élevée";

equation
  // --- Câblage : p -> ballast[k] -> led[1,k] -> ... -> led[Ns,k] -> n ---
  for k in 1:Np loop
    connect(p, ballast[k].p);
    connect(ballast[k].n, led[1, k].p);
    for j in 1:Ns - 1 loop
      connect(led[j, k].n, led[j + 1, k].p);
    end for;
    connect(led[Ns, k].n, n);
  end for;

  // --- Thermique : chaque jonction -> RthJC -> carte ---
  for j in 1:Ns loop
    for k in 1:Np loop
      connect(led[j, k].heatPort, rthJC[j, k].port_a);
      connect(rthJC[j, k].port_b, heatPort);
    end for;
  end for;

  // --- Grandeurs globales ---
  v = p.v - n.v;
  i = p.i;
  for k in 1:Np loop
    If_branch[k] = led[1, k].i;
  end for;
  Iv = sum(led.Iv);
  Phi_v = sum(led.Phi_v);
  P_elec = sum(led.P_elec);
  Qth = sum(led.Qth);
  Tj_max = max(led.Tj);

  lightPort.Phi_v = Phi_v;
  lightPort.Iv = Iv;

  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}),
      graphics = {
        Line(points = {{-90, 0}, {-70, 0}}, thickness = 1),
        Line(points = {{70, 0}, {90, 0}}, thickness = 1),
        Line(points = {{-70, 30}, {-70, -30}}, thickness = 1),
        Line(points = {{70, 30}, {70, -30}}, thickness = 1),
        Line(points = {{-70, 30}, {70, 30}}),
        Line(points = {{-70, -30}, {70, -30}}),
        Polygon(points = {{-50, 42}, {-50, 18}, {-32, 30}, {-50, 42}}, fillPattern = FillPattern.Solid),
        Line(points = {{-32, 42}, {-32, 18}}, thickness = 1),
        Polygon(points = {{-8, 39}, {-8, 21}, {6, 30}, {-8, 39}}, fillPattern = FillPattern.Solid),
        Line(points = {{6, 39}, {6, 21}}, thickness = 1),
        Polygon(points = {{32, 44}, {32, 16}, {52, 30}, {32, 44}}, fillPattern = FillPattern.Solid),
        Line(points = {{52, 44}, {52, 16}}, thickness = 1),
        Polygon(points = {{-50, -20}, {-50, -40}, {-35, -30}, {-50, -20}}, fillPattern = FillPattern.Solid),
        Line(points = {{-35, -20}, {-35, -40}}, thickness = 1),
        Polygon(points = {{-9, -17}, {-9, -43}, {9, -30}, {-9, -17}}, fillPattern = FillPattern.Solid),
        Line(points = {{9, -17}, {9, -43}}, thickness = 1),
        Polygon(points = {{33, -19}, {33, -41}, {49, -30}, {33, -19}}, fillPattern = FillPattern.Solid),
        Line(points = {{49, -19}, {49, -41}}, thickness = 1),
        Text(extent = {{-100, -50}, {100, -76}}, textString = "%Ns × %Np"),
        Text(extent = {{-150, -82}, {150, -112}}, textString = "%name", textColor = {0, 0, 255})}),
    Documentation(info = "<html>
<p>Matrice de <code>Ns</code>&nbsp;&times;&nbsp;<code>Np</code> LED <strong>individuelles</strong> :
<code>Np</code> branches en parallèle, chacune formée d'une résistance de ballast
(<code>R_ballast</code>, 0 par défaut) et de <code>Ns</code> LED en série.</p>
<pre>
  p ──┬── ballast[1] ── led[1,1] ── led[2,1] ── ... ── led[Ns,1] ──┬── n
      ├── ballast[2] ── led[1,2] ── led[2,2] ── ... ── led[Ns,2] ──┤
      └── ...                                                      ┘
  chaque led[j,k].heatPort ── rthJC[j,k] (RthJC_heat) ── heatPort (carte commune)
</pre>
<p>Différence avec <code>LEDArray</code> : ici chaque LED est calculée séparément. Elle peut
avoir sa propre dispersion (<code>dVf[j,k]</code>, <code>kIv[j,k]</code>) et sa propre
température de jonction. C'est le modèle à utiliser pour étudier le <strong>partage du
courant entre branches</strong>, l'effet du ballast ou les écarts de luminosité.
Pour des LED identiques à la même température, <code>LEDArray</code> donne le même
résultat beaucoup plus vite.</p>
<p><strong>Attention</strong> : le <code>heatPort</code> représente la <strong>carte</strong>
commune, et non une jonction (contrairement à <code>LED</code> et <code>LEDArray</code>).
Chaque LED y est reliée par sa résistance jonction - boîtier <code>data.RthJC_heat</code>
(RthJC du datasheet, ramenée à la chaleur dissipée si le fabricant la rapporte à la
puissance électrique).</p>
<p>Indices : <code>[j, k]</code> = [position dans la branche (1 à Ns), branche (1 à Np)].</p>
<p>Ordres de grandeur de la dispersion de fabrication (à lire sur le datasheet de la LED
utilisée) : tension directe &plusmn;0,2 à 0,3&nbsp;V entre les valeurs min et max ;
intensité lumineuse dans un rapport 1 à 2 entre classes de luminosité.</p>
<p>Grandeurs : <code>v</code>, <code>i</code>, <code>If_branch[k]</code> (courant de chaque
branche), <code>Iv</code>, <code>Phi_v</code>, <code>P_elec</code>, <code>Qth</code> (totaux),
<code>Tj_max</code> (jonction la plus chaude) ; le détail de chaque LED dans
<code>led[j, k]</code>.</p>
<p>Dans le diagramme interne, OMEdit représente le tableau de LED par une seule icône et
ne trace pas les connexions écrites en boucle : le schéma ci-dessus les décrit.</p>
</html>"));
end LEDMatrix;
