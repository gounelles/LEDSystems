within LEDSystems.Examples.SolarSpot;
model LiFePO4DirectDrive
  "Spot solaire : 66 LED en parallèle directement sur un élément LiFePO4 (3,0 à 3,4 V), par temps froid"
  extends Modelica.Icons.Example;
  import SI = Modelica.Units.SI;

  // =========================
  // Composants
  // (valeurs saisies directement sur les composants : double-clic dans OMEdit)
  // =========================
  Modelica.Electrical.Analog.Sources.RampVoltage cell(
    V = 0.4, offset = 3.0, duration = 7200, startTime = 0)
    "Élément LiFePO4 : tension de 3,0 à 3,4 V (rampe lente, sans résistance interne)"
    annotation(Placement(transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation(Placement(transformation(origin = {-60, -40}, extent = {{-10, -10}, {10, 10}})));
  // Dispersion (onglet « Avancé » de la matrice), tirages reproductibles :
  //  - Vf : classe de tension F (Tab. 7 du DS55), 3,3 à 3,4 V à 60 mA, centrée sur 3,35 V ;
  //    dVf = décalage par rapport à la courbe typique du record (3,1 V à 60 mA) ;
  //  - flux : toutes les classes de la Tab. 6, 22 à 32 lm à 60 mA (typique 26 lm).
  LEDSystems.Components.LEDMatrix matrix(
    redeclare LEDSystems.Data.Bridgelux_BXEN_57E_11L data,
    Ns = 1, Np = 66, R_ballast = 0,
    dVf = {LEDSystems.Functions.dispersion(66, 3.35, 3.3, 3.4, seed = 1) .- 3.1},
    kIv = {LEDSystems.Functions.dispersion(66, 26, 22, 32, seed = 2) ./ 26})
    "66 LED en parallèle (1 LED par branche, pas de ballast)"
    annotation(Placement(transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}})));
  LEDSystems.Thermal.Plate plate(
    R = 3, T_ambient = 273.15, area = 0.15*0.15, thickness = 2e-3, T_start = 273.15)
    "Plaque alu 150 x 150 x 2 mm, extérieur à 0 °C (changer T_ambient ET T_start)"
    annotation(Placement(transformation(origin = {-30, 40}, extent = {{10, -10}, {-10, 10}})));

  // =========================
  // Grandeurs à observer
  // =========================
  SI.Current If_min(displayUnit = "mA") = min(matrix.If_branch) "Courant de la LED la moins chargée";
  SI.Current If_max(displayUnit = "mA") = max(matrix.If_branch) "Courant de la LED la plus chargée";
  SI.Power P_opt = sum(matrix.led.P_opt) "Puissance optique totale";
  Real efficacy(unit = "lm/W") = matrix.Phi_v/max(matrix.P_elec, 1e-9) "Efficacité lumineuse";

equation
  connect(cell.p, matrix.p) annotation(Line(points = {{-60, 10}, {-60, 20}, {-20, 20}, {-20, 0}, {-10, 0}}, color = {0, 0, 255}));
  connect(matrix.n, ground.p) annotation(Line(points = {{10, 0}, {20, 0}, {20, -30}, {-60, -30}}, color = {0, 0, 255}));
  connect(cell.n, ground.p) annotation(Line(points = {{-60, -10}, {-60, -30}}, color = {0, 0, 255}));
  connect(plate.port, matrix.heatPort) annotation(Line(points = {{-20, 40}, {-6, 40}, {-6, 10}}, color = {191, 0, 0}));

  annotation(
    experiment(StartTime = 0, StopTime = 7200, Interval = 10),
    Documentation(info = "<html>
<p>Projecteur solaire : 66 LED Bridgelux SMD 2835 0,2&nbsp;W 3&nbsp;V (DS55) montées
<strong>en parallèle, sans driver ni ballast</strong>, directement sur un élément LiFePO4.
La tension de l'élément passe lentement de 3,0&nbsp;V (déchargé) à 3,4&nbsp;V (chargé)
en 2&nbsp;h : la rampe est lente devant la constante de temps de la plaque
(<code>plate.tau</code> &asymp; 5&nbsp;min), chaque instant est donc proche du régime établi
(retard thermique de l'ordre de 1&nbsp;K). Extérieur à 0&nbsp;°C : paramètres
<code>T_ambient</code> et <code>T_start</code> de <code>plate</code> (les changer ensemble).</p>

<h4>Pourquoi la classe de tension F</h4>
<p>Le courant de chaque LED n'est fixé que par sa caractéristique I&ndash;V. Avec une LED
typique (3,1&nbsp;V à 60&nbsp;mA), le courant atteindrait 115&nbsp;mA à 3,4&nbsp;V, au-delà du
maximum de 80&nbsp;mA en continu (Tab. 5 du datasheet). Pour une commande directe en
tension, il faut acheter des LED de la classe haute <b>F</b> (3,3 à 3,4&nbsp;V à 60&nbsp;mA,
Tab. 7) : c'est le choix de cet exemple. Pour voir le dépassement, essayer la classe C
(3,0 à 3,1&nbsp;V) : dans l'onglet « Avancé » de <code>matrix</code>, remplacer
<code>dispersion(66, 3.35, 3.3, 3.4, seed = 1)</code> par
<code>dispersion(66, 3.05, 3.0, 3.1, seed = 1)</code>.</p>

<h4>Dispersion</h4>
<p>Tension directe tirée dans la classe F, flux tiré dans toutes les classes de la Tab. 6
(22 à 32&nbsp;lm), par <code>Functions.dispersion</code> (loi normale tronquée, graines
fixes : résultats reproductibles).</p>

<h4>À observer</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Tension</th><th>Courant par LED (min - max)</th><th>Courant total</th>
<th>Plaque</th><th>Tj max</th><th>Flux total</th><th>Efficacité</th></tr>
<tr><td>3,0&nbsp;V</td><td>8 - 16&nbsp;mA</td><td>0,78&nbsp;A</td><td>0&nbsp;°C</td><td>1&nbsp;°C</td><td>386&nbsp;lm</td><td>165&nbsp;lm/W</td></tr>
<tr><td>3,1&nbsp;V</td><td>19 - 28&nbsp;mA</td><td>1,55&nbsp;A</td><td>6&nbsp;°C</td><td>9&nbsp;°C</td><td>734&nbsp;lm</td><td>153&nbsp;lm/W</td></tr>
<tr><td>3,2&nbsp;V</td><td>32 - 43&nbsp;mA</td><td>2,46&nbsp;A</td><td>12&nbsp;°C</td><td>16&nbsp;°C</td><td>1129&nbsp;lm</td><td>143&nbsp;lm/W</td></tr>
<tr><td>3,3&nbsp;V</td><td>47 - 59&nbsp;mA</td><td>3,49&nbsp;A</td><td>18&nbsp;°C</td><td>24&nbsp;°C</td><td>1552&nbsp;lm</td><td>135&nbsp;lm/W</td></tr>
<tr><td>3,4&nbsp;V</td><td>64 - 76&nbsp;mA</td><td>4,61&nbsp;A</td><td>26&nbsp;°C</td><td>35&nbsp;°C</td><td>1951&nbsp;lm</td><td>124&nbsp;lm/W</td></tr>
</table>
<ul>
<li><code>If_min</code>, <code>If_max</code> : écart de courant entre LED dû aux 0,1&nbsp;V de
la classe ; toutes restent sous le maximum de 80&nbsp;mA ;</li>
<li><code>matrix.i</code> : courant demandé à l'élément ; <code>matrix.Phi_v</code> : flux total ;
<code>efficacy</code> : efficacité, plus élevée à faible courant ;</li>
<li><code>plate.T</code> et <code>matrix.Tj_max</code> : l'échauffement réduit Vf
(&minus;1,9&nbsp;mV/K), ce qui augmente le courant à tension donnée.</li>
</ul>

<h4>Limites (non validé)</h4>
<ul>
<li>Températures de jonction sous 22,4&nbsp;°C (Tsp = 17&nbsp;°C) : pas de données ; c'est le cas
de presque toute la simulation jusqu'à 3,3&nbsp;V. Vf est
extrapolée avec le coefficient linéaire du datasheet ; le facteur de flux reste celui de
22,4&nbsp;°C (la vraie LED éclaire probablement un peu plus au froid).</li>
<li>Courants sous 10&nbsp;mA (élément presque déchargé) : flux pris proportionnel au
courant, Vf extrapolée par le modèle de Shockley.</li>
<li>Élément LiFePO4 idéal (pas de résistance interne) ; résistance plaque - air de
3&nbsp;K/W supposée (plaque nue dans l'air calme, convection et rayonnement).</li>
</ul>
</html>"));
end LiFePO4DirectDrive;
