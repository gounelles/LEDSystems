within LEDSystems;
package Examples "Exemples : composants de base, puis cas d'usage validés sur datasheet"
  extends Modelica.Icons.ExamplesPackage;

  annotation (Documentation(info="<html>
<p>Chaque exemple dit, dans sa documentation, ce qu'il faut observer et donne les valeurs
attendues. Les valeurs se modifient directement sur les composants (double-clic dans le
diagramme d'OMEdit).</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Package</th><th>Contenu</th><th>LED</th></tr>
<tr><td><a href=\"modelica://LEDSystems.Examples.Basics\">Basics</a></td>
    <td>Un composant ou un phénomène à la fois, dans un ordre progressif : à voir en
    premier</td>
    <td>Vishay VLMW41S1T1</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Examples.SolarSpot\">SolarSpot</a></td>
    <td>Spot solaire : LED en parallèle directement sur un élément LiFePO4, au froid ;
    partage du courant entre LED dispersées</td>
    <td>Bridgelux BXEN-57E-11L</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Examples.DomesticLamp\">DomesticLamp</a></td>
    <td>Ampoule : LED en série sur un radiateur commun, courant constant ; baisse du flux
    pendant la mise en température</td>
    <td>Bridgelux BXEN-30G-11M</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Examples.Automotive\">Automotive</a></td>
    <td>Phare : LED de puissance dans un air à 85&nbsp;°C, feu de croisement puis feu de
    route ; marge sur la température de jonction maximale</td>
    <td>Lumileds LUXEON FX2-L Plus</td></tr>
</table>
<p>Les trois LED des cas d'usage ont été calées sur leur datasheet, puis vérifiées sur
d'autres points du même datasheet (voir le guide d'utilisation).</p>
</html>"));
end Examples;
