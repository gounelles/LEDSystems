within LEDSystems.Interfaces;

connector LightPort
  "Port signal photométrique (sortie LED)"

  import SI = Modelica.Units.SI;

  output SI.LuminousFlux Phi_v "Flux lumineux (lm)";
  output SI.LuminousIntensity Iv(displayUnit = "mcd") "Intensité lumineuse dans l'axe (cd)";

  annotation(defaultComponentName = "lightPort",
  Icon(graphics = {Rectangle(lineColor = {85, 85, 127}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}),
  Diagram(graphics = {Rectangle(lineColor = {85, 85, 127}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, extent = {{-60, 60}, {60, -60}}), Text(origin = {-1, 97}, textColor = {255, 170, 0}, extent = {{-95, 37}, {95, -37}}, textString = "%name")}),
  Documentation(info = "<html>
<p>Sortie photométrique d'une LED : le flux lumineux <code>Phi_v</code> (lm) et
l'intensité lumineuse dans l'axe <code>Iv</code> (cd, affichée en mcd).</p>
<p>C'est un connecteur de <strong>signal</strong> : ses deux variables sont des sorties
calculées par la LED. Il ne représente pas un échange d'énergie et n'obéit à aucune loi
de conservation (contrairement aux ports électrique et thermique). La puissance optique
rayonnée est la variable <code>P_opt</code> du composant LED.</p>
<p>Usage : relier le port à un composant qui lit la lumière (par exemple un capteur ou un
modèle de pièce éclairée, dans une bibliothèque qui utilise celle-ci), ou tracer
directement <code>lightPort.Phi_v</code> et <code>lightPort.Iv</code> : ce sont les
sorties <code>Phi_v</code> et <code>Iv</code> du composant (totaux de toutes les LED pour
<code>LEDArray</code> et <code>LEDMatrix</code>).</p>
</html>"));
end LightPort;
