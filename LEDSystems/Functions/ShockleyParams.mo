within LEDSystems.Functions;

record ShockleyParams "Paramètres du modèle électrique de Shockley (résultat du calage)"
  extends Modelica.Icons.Record;
  Modelica.Units.SI.Current Is "Courant de saturation";
  Real n(unit="1") "Facteur d'idéalité";
  Modelica.Units.SI.Resistance Rs "Résistance série";

  annotation (Documentation(info = "<html>
<p>Les trois paramètres du modèle électrique de la LED (diode de Shockley avec résistance
série), à la température de jonction de la courbe de calage :</p>
<p>V = n&middot;V<sub>t</sub>&middot;ln(1 + I/I<sub>s</sub>) + R<sub>s</sub>&middot;I,
avec V<sub>t</sub> = k&middot;T/q (environ 25,7&nbsp;mV à 25&nbsp;°C).</p>
<p>C'est le type de sortie de
<a href=\"modelica://LEDSystems.Functions.fitShockley3Points\">fitShockley3Points</a>.
Pour les LED blanches de la bibliothèque : n de 1,5 à 4 (n est grand quand une seule
exponentielle doit décrire toute la courbe), I<sub>s</sub> de 1e-33 à 1e-15&nbsp;A
(d'autant plus petit que n est faible : ce n'est qu'un paramètre de calage),
R<sub>s</sub> de 0,3&nbsp;&Omega; (LED de puissance) à 13&nbsp;&Omega; (LED de
signalisation).</p>
</html>"));
end ShockleyParams;
