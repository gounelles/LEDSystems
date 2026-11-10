within LEDSystems.Examples;
package DomesticLamp "Lampe domestique : LED moyenne puissance en série sur une carte commune"
  extends Modelica.Icons.ExamplesPackage;

  annotation (Documentation(info="<html>
<p>Cas d'usage de la lampe domestique (ampoule à LED) : une chaîne de LED moyenne
puissance <strong>en série</strong>, alimentée par un driver à <strong>courant
constant</strong>, toutes les LED étant soudées sur une même carte qui forme un
<strong>nœud thermique commun</strong>.</p>
<p>LED : Bridgelux SMD 2835 0,5&nbsp;W 3&nbsp;V, BXEN-30G-11M-3C, 3000&nbsp;K, IRC 90
(<code>Data.Bridgelux_BXEN_30G_11M</code>, datasheet DS242 Rev. F), validée par
<code>outils/tester_cas_usage.py</code> de 10 à 240&nbsp;mA et de 25 à 105&nbsp;°C.</p>
</html>"));
end DomesticLamp;
