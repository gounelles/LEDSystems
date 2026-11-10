within LEDSystems.Examples.Basics;

model LEDHeatSinkInCase "LED sur dissipateur dans un boîtier fermé (composants thermiques de la MSL)"
  extends Modelica.Icons.Example;
  // Température ambiante : 20 °C, saisie à 3 endroits (AirTemp, CthHeatsink, CthCase)
  // =========================
  // Électrique
  // =========================
  LEDSystems.Components.LED led(redeclare LEDSystems.Data.Vishay_VLMW41S1T1 data) annotation(
    Placement(transformation(origin = {-156, -36}, extent = {{-20, -10}, {0, 10}})));
  Modelica.Electrical.Analog.Basic.Ground gnd annotation(
    Placement(transformation(origin = {-154, -18}, extent = {{-80, -60}, {-60, -40}})));
  Modelica.Electrical.Analog.Sources.ConstantCurrent constantCurrent1(I(displayUnit = "mA") = 0.02) "Courant constant de 20 mA" annotation(
    Placement(transformation(origin = {-198, -36}, extent = {{-10, -10}, {10, 10}})));
  // =========================
  // Thermique : composants de la MSL
  // =========================
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor RConvHeatsink(R = 2) "Conduction dans le dissipateur" annotation(
    Placement(transformation(origin = {-88, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor CthHeatsink(C = 9, T(start = 293.15, fixed = true)) "Dissipateur alu de 10 g" annotation(
    Placement(transformation(origin = {-104, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convHeatsink "Convection dissipateur - air intérieur" annotation(
    Placement(transformation(origin = {-54, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation rayHeatsink(Gr = 1.6e-3) "Rayonnement du dissipateur (epsilon 0,8 x 20 cm2)" annotation(
    Placement(transformation(origin = {-54, 46}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature AirTemp(T = 293.15) "Air ambiant à 20 °C" annotation(
    Placement(transformation(origin = {150, 24}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor RthJonction(R = led.data.RthJC_heat) "Jonction - boîtier de la LED (RthJC)" annotation(
    Placement(transformation(origin = {-118, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor RCaseConvectionExt(R = 0.15) "Demi-paroi du boîtier, côté extérieur (conduction)" annotation(
    Placement(transformation(origin = {62, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor CthCase(C = 118, T(start = 293.15, fixed = true)) "Paroi du boîtier ABS" annotation(
    Placement(transformation(origin = {44, 52}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor RCaseConvectionInt(R = 0.15) "Demi-paroi du boîtier, côté intérieur (conduction)" annotation(
    Placement(transformation(origin = {28, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation rayCaseOut(Gr = 3.6e-2) "Rayonnement du boîtier vers l'extérieur (epsilon 0,9 x 400 cm2)" annotation(
    Placement(transformation(origin = {98, 44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convCaseOut "Convection boîtier - air extérieur" annotation(
    Placement(transformation(origin = {98, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation rayCaseIn(Gr = 3.6e-2) "Rayonnement reçu par la paroi intérieure (epsilon 0,9 x 400 cm2)" annotation(
    Placement(transformation(origin = {-8, 46}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convCaseIn "Convection air intérieur - paroi du boîtier" annotation(
    Placement(transformation(origin = {-8, 6}, extent = {{-10, -10}, {10, 10}})));
  // Conductances convectives Gc = h*A (ordres de grandeur)
  Modelica.Blocks.Sources.Constant GcHeatsink(k = 0.01) "h = 5 W/(m2.K) en air confiné x 20 cm2 (W/K)" annotation(
    Placement(transformation(origin = {-64, 23}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Sources.Constant GcCaseIn(k = 0.2) "h = 5 W/(m2.K) x 400 cm2 (W/K)" annotation(
    Placement(transformation(origin = {-24, 23}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Sources.Constant GcCaseOut(k = 0.4) "h = 10 W/(m2.K), convection naturelle x 400 cm2 (W/K)" annotation(
    Placement(transformation(origin = {88, 23}, extent = {{-4, -4}, {4, 4}})));
equation
// Connexions électriques
  connect(led.n, gnd.p) annotation(
    Line(points = {{-156, -36}, {-144, -36}, {-144, -58}, {-224, -58}}, color = {0, 0, 255}));
  connect(constantCurrent1.n, led.p) annotation(
    Line(points = {{-188, -36}, {-176, -36}}, color = {0, 0, 255}));
  connect(constantCurrent1.p, gnd.p) annotation(
    Line(points = {{-208, -36}, {-224, -36}, {-224, -58}}, color = {0, 0, 255}));
  connect(RConvHeatsink.port_b, rayHeatsink.port_a) annotation(
    Line(points = {{-78, 22}, {-72, 22}, {-72, 46}, {-64, 46}}, color = {191, 0, 0}));
  connect(RConvHeatsink.port_b, convHeatsink.solid) annotation(
    Line(points = {{-78, 22}, {-72, 22}, {-72, 6}, {-64, 6}}, color = {191, 0, 0}));
  connect(RthJonction.port_b, RConvHeatsink.port_a) annotation(
    Line(points = {{-108, 22}, {-98, 22}}, color = {191, 0, 0}));
  connect(CthHeatsink.port, RConvHeatsink.port_a) annotation(
    Line(points = {{-104, 40}, {-104, 22}, {-98, 22}}, color = {191, 0, 0}));
  connect(led.heatPort, RthJonction.port_a) annotation(
    Line(points = {{-172, -26}, {-172, 22}, {-128, 22}}, color = {191, 0, 0}));
  connect(RCaseConvectionInt.port_b, RCaseConvectionExt.port_a) annotation(
    Line(points = {{38, 22}, {52, 22}}, color = {191, 0, 0}));
  connect(CthCase.port, RCaseConvectionExt.port_a) annotation(
    Line(points = {{44, 42}, {44, 22}, {52, 22}}, color = {191, 0, 0}));
  connect(rayHeatsink.port_b, rayCaseIn.port_a) annotation(
    Line(points = {{-44, 46}, {-18, 46}}, color = {191, 0, 0}));
  connect(convHeatsink.fluid, convCaseIn.solid) annotation(
    Line(points = {{-44, 6}, {-18, 6}}, color = {191, 0, 0}));
  connect(rayCaseIn.port_b, RCaseConvectionInt.port_a) annotation(
    Line(points = {{2, 46}, {10, 46}, {10, 22}, {18, 22}}, color = {191, 0, 0}));
  connect(convCaseIn.fluid, RCaseConvectionInt.port_a) annotation(
    Line(points = {{2, 6}, {10, 6}, {10, 22}, {18, 22}}, color = {191, 0, 0}));
  connect(RCaseConvectionExt.port_b, rayCaseOut.port_a) annotation(
    Line(points = {{72, 22}, {80, 22}, {80, 44}, {88, 44}}, color = {191, 0, 0}));
  connect(RCaseConvectionExt.port_b, convCaseOut.solid) annotation(
    Line(points = {{72, 22}, {80, 22}, {80, 6}, {88, 6}}, color = {191, 0, 0}));
  connect(rayCaseOut.port_b, AirTemp.port) annotation(
    Line(points = {{108, 44}, {126, 44}, {126, 24}, {140, 24}}, color = {191, 0, 0}));
  connect(convCaseOut.fluid, AirTemp.port) annotation(
    Line(points = {{108, 6}, {126, 6}, {126, 24}, {140, 24}}, color = {191, 0, 0}));
  connect(GcHeatsink.y, convHeatsink.Gc) annotation(
    Line(points = {{-60, 23}, {-54, 23}, {-54, 16}}, color = {0, 0, 127}));
  connect(GcCaseIn.y, convCaseIn.Gc) annotation(
    Line(points = {{-20, 23}, {-8, 23}, {-8, 16}}, color = {0, 0, 127}));
  connect(GcCaseOut.y, convCaseOut.Gc) annotation(
    Line(points = {{92, 23}, {98, 23}, {98, 16}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 3000, Interval = 1, StartTime = 0, Tolerance = 1e-06),
    Documentation(info = "<html>
    <p>Une source de courant constant (20&nbsp;mA) alimente la LED Vishay VLMW41S1T1. La chaleur de la jonction
    (heatPort) passe par la LED elle-même (RthJC), un dissipateur alu, l'intérieur d'un
    boîtier fermé, la paroi du boîtier, puis l'air ambiant à 20&nbsp;°C. Tous les éléments thermiques sont des composants de la
    MSL (<code>Modelica.Thermal.HeatTransfer</code>).</p>
    <p><strong>Valeurs : ordres de grandeur, à remplacer par des mesures.</strong>
    Hypothèses : dissipateur alu de 10 g et 20 cm² ; boîtier ABS de 10 &times; 10 &times; 5 cm
    (400 cm²), paroi de 2 mm.</p>
    <table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
    <tr><th>Composant</th><th>Valeur</th><th>Origine</th></tr>
    <tr><td>RthJonction</td><td>RthJC de la LED</td><td>datasheet</td></tr>
    <tr><td>CthHeatsink</td><td>9 J/K</td><td>10 g &times; 900 J/(kg.K)</td></tr>
    <tr><td>RConvHeatsink</td><td>2 K/W</td><td>conduction dans le dissipateur</td></tr>
    <tr><td>convHeatsink (Gc)</td><td>0,01 W/K</td><td>h = 5 W/(m².K) en air confiné &times; 20 cm²</td></tr>
    <tr><td>rayHeatsink (Gr)</td><td>1,6e-3 m²</td><td>&epsilon; = 0,8 (alu anodisé) &times; 20 cm²</td></tr>
    <tr><td>convCaseIn (Gc)</td><td>0,2 W/K</td><td>h = 5 W/(m².K) &times; 400 cm²</td></tr>
    <tr><td>rayCaseIn (Gr)</td><td>3,6e-2 m²</td><td>&epsilon; = 0,9 (plastique) &times; 400 cm²</td></tr>
    <tr><td>RCaseConvectionInt, RCaseConvectionExt</td><td>0,15 K/W chacune</td><td>paroi ABS : e/(&lambda;.A) = 0,002/(0,17 &times; 0,04) &asymp; 0,3 K/W au total</td></tr>
    <tr><td>CthCase</td><td>118 J/K</td><td>1050 kg/m³ &times; 0,04 m² &times; 2 mm &times; 1400 J/(kg.K)</td></tr>
    <tr><td>convCaseOut (Gc)</td><td>0,4 W/K</td><td>h = 10 W/(m².K), convection naturelle &times; 400 cm²</td></tr>
    <tr><td>rayCaseOut (Gr)</td><td>3,6e-2 m²</td><td>&epsilon; = 0,9 &times; 400 cm²</td></tr>
    </table>
    <p>Les deux capacités partent de la température ambiante (équilibre initial). Pour
    changer l'ambiance, modifier les 3 valeurs : <code>AirTemp.T</code>,
    <code>CthHeatsink.T.start</code> et <code>CthCase.T.start</code>.</p>
    <p>Remarque : le rayonnement dissipateur - paroi est représenté par deux éléments
    <code>BodyRadiation</code> en série (rayHeatsink, rayCaseIn). Physiquement, c'est un
    seul échange, avec un Gr qui combine les deux émissivités. Cette simplification est
    conservée : l'exemple sert à montrer l'emploi des composants thermiques de la MSL. Avec cette LED de 66 mW (dont environ
    61 mW dissipés en chaleur), les échauffements restent faibles : Tj passe de 20,6 °C
    à environ 24,2 °C, atteints vers 3000 s (air à 20 °C).</p>
    <p>Résultats intéressants à observer :</p>
    <ul>
      <li>led.Tj, CthHeatsink.T, CthCase.T : températures, de la jonction vers l'ambiance</li>
      <li>led.Qth (Flux thermique) et AirTemp.port.Q_flow (flux reçu par l'air ambiant)</li>
      <li>led.Vf, led.Phi_v</li>
    </ul>
    </html>"),
    Diagram(graphics = {Rectangle(origin = {-99, 35}, lineColor = {0, 170, 255}, lineThickness = 1, borderPattern = BorderPattern.Raised, extent = {{-65, 45}, {65, -45}}, radius = 4), Bitmap(origin = {-141, 57}, extent = {{-17, 21}, {17, -21}}, fileName = "modelica://LEDSystems/Resources/Images/LEDHeatsink.svg"), Text(origin = {-142, 41}, extent = {{-12, 5}, {12, -5}}, textString = "Dissipateur
(Heatsink)"), Rectangle(origin = {-55, 37}, lineThickness = 1, borderPattern = BorderPattern.Raised, extent = {{-169, 53}, {169, -53}}, radius = 4), Text(origin = {-196, 43}, extent = {{-12, 5}, {12, -5}}, textString = "Boitier
(Case)"), Bitmap(origin = {-196, 64}, extent = {{-24, 24}, {24, -24}}, fileName = "modelica://LEDSystems/Resources/Images/LEDCase.svg")}, coordinateSystem(extent = {{-250, -100}, {250, 100}})),
    Icon(coordinateSystem(extent = {{-250, -100}, {250, 100}})));
end LEDHeatSinkInCase;