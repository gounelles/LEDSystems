within LEDSystems.UsersGuide;
class Overview "Vue d'ensemble : modèle d'une LED, choix d'un composant"
  extends Modelica.Icons.Information;

  annotation (Documentation(info="<html>
<h4>Ce que fait la bibliothèque</h4>
<p>LEDSystems calcule, pour une LED ou un ensemble de LED décrit par son datasheet :</p>
<ul>
<li>la relation courant - tension, et son évolution avec la température de jonction ;</li>
<li>l'intensité lumineuse (cd) et le flux lumineux (lm), en fonction du courant et de la
    température de jonction ;</li>
<li>la puissance optique rayonnée et la puissance dissipée en chaleur ;</li>
<li>la température de jonction, si la LED est reliée à un modèle de son environnement
    thermique (plaque, dissipateur, boîtier).</li>
</ul>
<p>Elle ne modélise pas : le spectre et la couleur (seule la LER, efficacité lumineuse du
rayonnement, relie le flux à la puissance optique), le vieillissement, le comportement
en commutation rapide (aucune capacité électrique), le claquage en inverse, ni
l'électronique de commande (driver, régulateur), à modéliser avec la MSL.</p>

<h4>Le modèle d'une LED</h4>
<p><img src=\"modelica://LEDSystems/Resources/Images/LEDModel.svg\" width=\"720\"
alt=\"Schéma du modèle d'une LED\"/></p>
<ul>
<li><strong>Électrique</strong> : diode de Shockley avec résistance série R<sub>s</sub> et
    résistance de fuite R<sub>p</sub>. Les paramètres I<sub>s</sub>, n et R<sub>s</sub> sont
    calés exactement sur 3 points de la courbe If = f(Vf) du datasheet
    (<a href=\"modelica://LEDSystems.Functions.fitShockley3Points\">fitShockley3Points</a>).
    La tension directe baisse quand la jonction chauffe (coefficient TCVf ou table).</li>
<li><strong>Photométrique</strong> : l'intensité au point de référence du datasheet est
    corrigée par les courbes relatives du datasheet, en fonction du courant et de la
    température de jonction. Le flux s'en déduit par l'indicatrice d'émission (angle de
    demi-intensité), et la puissance optique par la LER.</li>
<li><strong>Thermique</strong> : la chaleur Q<sub>th</sub> = P<sub>elec</sub> &minus;
    P<sub>opt</sub> sort par le <code>heatPort</code>, qui <em>est</em> la jonction. La LED
    n'a pas de masse thermique propre : c'est le modèle branché sur le
    <code>heatPort</code> qui fixe la température.</li>
</ul>

<h4>Rejeu ou prédiction</h4>
<p>Le <code>heatPort</code> doit toujours être relié à un composant du package
<a href=\"modelica://LEDSystems.Thermal\">Thermal</a> (ou de la MSL) :</p>
<ul>
<li><strong>rejeu</strong> : la température de jonction est imposée
    (<code>FixedTemperature</code>, <code>TemperatureTable</code>,
    <code>TemperatureFirstOrder</code>), sans tenir compte de la puissance dissipée. Pour
    caractériser la LED à température connue, ou rejouer une mesure ;</li>
<li><strong>prédiction</strong> : la température résulte de la puissance dissipée
    (<code>Plate</code>, ou un réseau thermique de la MSL). Pour dimensionner un
    dissipateur ou étudier l'échauffement.</li>
</ul>

<h4>Choix d'un composant</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Situation</th><th>Composant</th></tr>
<tr><td>Une LED</td>
    <td><a href=\"modelica://LEDSystems.Components.LED\">LED</a> + un composant de
    <code>Thermal</code></td></tr>
<tr><td>Une LED sur une plaque, sans se soucier du thermique</td>
    <td><a href=\"modelica://LEDSystems.Components.LEDWithPlate\">LEDWithPlate</a> (bloc prêt à
    l'emploi)</td></tr>
<tr><td>Plusieurs LED identiques, à la même température (lampe, bandeau)</td>
    <td><a href=\"modelica://LEDSystems.Components.LEDArray\">LEDArray</a> (rapide)</td></tr>
<tr><td>LED en parallèle, dispersion de fabrication, ballast, LED la plus chaude</td>
    <td><a href=\"modelica://LEDSystems.Components.LEDMatrix\">LEDMatrix</a></td></tr>
</table>
<p>Chaque composant reçoit les données de sa LED par le paramètre <code>data</code> : un
record du package <a href=\"modelica://LEDSystems.Data\">Data</a>, ou un record écrit pour
une autre LED (voir <a href=\"modelica://LEDSystems.UsersGuide.Tutorial\">Tutorial</a>).</p>

<h4>Parcours conseillé</h4>
<ol>
<li>Les exemples de <a href=\"modelica://LEDSystems.Examples.Basics\">Examples.Basics</a>,
    dans l'ordre du package ;</li>
<li>un cas d'usage proche de votre projet :
    <a href=\"modelica://LEDSystems.Examples.SolarSpot\">SolarSpot</a>,
    <a href=\"modelica://LEDSystems.Examples.DomesticLamp\">DomesticLamp</a> ou
    <a href=\"modelica://LEDSystems.Examples.Automotive\">Automotive</a> ;</li>
<li>le <a href=\"modelica://LEDSystems.UsersGuide.Tutorial\">tutoriel</a>, pour utiliser
    une autre LED.</li>
</ol>
</html>"));
end Overview;
