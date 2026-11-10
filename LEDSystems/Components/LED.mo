within LEDSystems.Components;
model LED "LED : modèle électrique, photométrique et thermique (jonction sur heatPort)"
  extends LEDSystems.Components.BaseClasses.PartialLED(final Ns = 1, final Np = 1);

  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-90, 0}, {-30, 0}}, thickness = 2), Polygon(fillPattern = FillPattern.Solid, lineThickness = 2, points = {{-30, 40}, {-30, -40}, {30, 0}, {-30, 40}}), Line(points = {{30, 40}, {30, -40}}, thickness = 2), Line(points = {{30, 0}, {90, 0}}, thickness = 2), Line(origin = {4, -4}, points = {{10, 55}, {35, 80}}, thickness = 2), Polygon(origin = {4, -4}, fillPattern = FillPattern.Solid, points = {{37, 82}, {26, 78}, {34, 70}, {37, 82}}), Line(origin = {-6, 6}, points = {{10, 55}, {35, 80}}, thickness = 2), Polygon(origin = {-6, 6}, fillPattern = FillPattern.Solid, points = {{37, 82}, {26, 78}, {34, 70}, {37, 82}}), Text(origin = {0, -122}, extent = {{-72, 16}, {72, -16}}, textString = "%name"), Text(origin = {1, -70}, extent = {{-95, 24}, {95, -24}}, textString = "LED")}),
    Documentation(info = "<html>
<p>LED : modèle électrique (diode de Shockley + résistance série + fuite),
photométrique (intensité, flux) et thermique (puissance dissipée).</p>
<p><img src=\"modelica://LEDSystems/Resources/Images/LEDModel.svg\" width=\"720\"
alt=\"Schéma du modèle d'une LED\"/></p>
<p>Détail du modèle : <a href=\"modelica://LEDSystems.UsersGuide.Overview\">UsersGuide.Overview</a>.</p>
<p>Le <code>heatPort</code> représente la <strong>jonction</strong> : sa température est
la température de jonction <code>Tj</code>, et la LED y injecte la puissance qu'elle
dissipe en chaleur, <code>Qth = P_elec - P_opt</code>. Il doit toujours être relié à un
environnement thermique : un composant du package <code>Thermal</code> (température
imposée ou plaque), éventuellement à travers la résistance jonction - boîtier de la LED
(<code>data.RthJC_heat</code>).</p>
<p>Les caractéristiques de la LED sont dans le record <code>data</code>
(voir <code>Data.LEDData</code>). Les paramètres <code>dVf</code> et <code>kIv</code>
(onglet « Avancé ») représentent l'écart de cette LED par rapport au datasheet
(dispersion de fabrication) ; ils valent 0 et 1 par défaut.</p>
<p>Pour plusieurs LED identiques : <code>LEDArray</code> ; avec dispersion :
<code>LEDMatrix</code>.</p>
</html>"),
    Diagram(graphics = {Line(origin = {2, 0}, points = {{-100, 0}, {-30, 0}}, color = {0, 0, 255}, thickness = 2), Polygon(origin = {2, 0}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, lineThickness = 2, points = {{-30, 40}, {-30, -40}, {30, 0}, {-30, 40}}), Line(origin = {2, 0}, points = {{30, 40}, {30, -40}}, color = {0, 0, 255}, thickness = 2), Line(origin = {2, 0}, points = {{30, 0}, {94, 0}}, color = {0, 0, 255}, thickness = 2), Line(origin = {6, -4}, points = {{10, 55}, {35, 80}}, color = {255, 255, 127}, thickness = 2), Polygon(origin = {6, -4}, lineColor = {255, 255, 127}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{37, 82}, {26, 78}, {34, 70}, {37, 82}}), Line(origin = {-4, 6}, points = {{10, 55}, {35, 80}}, color = {255, 255, 127}, thickness = 2), Polygon(origin = {-4, 6}, lineColor = {255, 255, 127}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{37, 82}, {26, 78}, {34, 70}, {37, 82}}), Text(origin = {-4, -86}, textColor = {0, 0, 255}, extent = {{-72, 16}, {72, -16}}, textString = "%name")}));

end LED;
