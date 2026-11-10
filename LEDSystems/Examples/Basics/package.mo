within LEDSystems.Examples;
package Basics "Exemples de base : un composant à la fois"
  extends Modelica.Icons.ExamplesPackage;

  annotation (Documentation(info="<html>
<p>Exemples courts, chacun centré sur un composant ou un phénomène. Ils utilisent tous la
LED Vishay VLMW41S1T1 (courant continu maximal 20&nbsp;mA). L'ordre ci-dessous est
progressif ; la documentation de chaque exemple dit quoi observer et donne les valeurs
attendues.</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Exemple</th><th>Ce qu'il montre</th></tr>
<tr><td colspan=\"2\"><em>La LED seule</em></td></tr>
<tr><td><code>LEDSimpleElec</code></td><td>Caractéristique courant-tension, bilan des
    puissances (électrique, optique, chaleur)</td></tr>
<tr><td><code>LEDSimplePhoto</code></td><td>Intensité en fonction du courant (non
    proportionnelle), passage de l'intensité (cd) au flux (lm), effet de la température</td></tr>
<tr><td colspan=\"2\"><em>Les composants thermiques seuls</em></td></tr>
<tr><td><code>ThermalFixedTemperature</code></td><td>Température imposée, quelle que soit
    la puissance (rejeu)</td></tr>
<tr><td><code>ThermalTemperatureTable</code></td><td>Rejeu d'un relevé de température, brut
    ou filtré</td></tr>
<tr><td><code>ThermalTemperatureFirstOrder</code></td><td>Rejeu d'un échauffement du
    1<sup>er</sup> ordre</td></tr>
<tr><td><code>ThermalPlate</code></td><td>Échauffement d'une plaque (prédiction) :
    constante de temps R&middot;C, régime établi</td></tr>
<tr><td colspan=\"2\"><em>La LED et son environnement thermique</em></td></tr>
<tr><td><code>LEDJunctionFirstOrder</code></td><td>Baisse de la tension et du flux quand la
    jonction chauffe (température imposée)</td></tr>
<tr><td><code>LEDWithPlateConstantCurrent</code></td><td>Bloc prêt à l'emploi LED + plaque :
    la LED s'échauffe sous l'effet de sa propre chaleur (prédiction)</td></tr>
<tr><td><code>LEDHeatSinkInCase</code></td><td>Chaîne thermique complète (dissipateur,
    boîtier, convection, rayonnement) avec les composants de la MSL</td></tr>
<tr><td colspan=\"2\"><em>Plusieurs LED</em></td></tr>
<tr><td><code>LEDArrayEquivalence</code></td><td><code>LEDArray</code> : Ns&nbsp;&times;&nbsp;Np
    LED identiques calculées comme une seule</td></tr>
<tr><td><code>LEDMatrixCurrentSharing</code></td><td><code>LEDMatrix</code> : LED en
    parallèle, dispersion de fabrication, rôle d'une résistance de ballast</td></tr>
</table>
<p>Les valeurs de chaque exemple se saisissent directement sur ses composants (double-clic
dans le diagramme d'OMEdit).</p>
</html>"));
end Basics;
