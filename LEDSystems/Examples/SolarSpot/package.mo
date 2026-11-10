within LEDSystems.Examples;
package SolarSpot "Spot solaire : LED en parallèle directement sur un élément LiFePO4"
  extends Modelica.Icons.ExamplesPackage;

  annotation (Documentation(info="<html>
<p>Cas d'usage du projecteur solaire : des LED moyenne puissance montées en parallèle
et alimentées <strong>directement en tension</strong> par un élément lithium fer phosphate
(LiFePO4, 3,0 à 3,4&nbsp;V), sans driver de courant. Le courant de chaque LED n'est fixé
que par sa caractéristique I&ndash;V : le calage I&ndash;V et le choix de la classe de
tension directe sont déterminants.</p>
<p>LED : Bridgelux SMD 2835 0,2&nbsp;W 3&nbsp;V, BXEN-57E-11L-3A
(<code>Data.Bridgelux_BXEN_57E_11L</code>, datasheet DS55 Rev. B), validée par
<code>outils/tester_cas_usage.py</code> de 10 à 80&nbsp;mA et pour Tsp de 17 à 105&nbsp;°C.</p>
</html>"));
end SolarSpot;
