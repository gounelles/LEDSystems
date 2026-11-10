within LEDSystems;
package Components "Composants LED : LED seule, réseaux de LED, LED sur plaque"
  extends Modelica.Icons.Package;

  annotation (Documentation(info="<html>
<p>Composants électriques, photométriques et thermiques de LED.</p>
<ul>
<li><code>LED</code> : une LED. Son <code>heatPort</code> est la jonction : le relier à un
    composant du package <code>Thermal</code>.</li>
<li><code>LEDWithPlate</code> : une LED déjà montée sur une plaque dissipatrice, avec
    l'air ambiant (bloc prêt à l'emploi).</li>
<li><code>LEDArray</code> et <code>LEDMatrix</code> : Ns&nbsp;&times;&nbsp;Np LED, en
    Np branches en parallèle de Ns LED en série.</li>
</ul>
<h4>LEDArray ou LEDMatrix ?</h4>
<p>Le câblage est le même ; c'est la <strong>manière de calculer</strong> qui diffère.</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th></th><th>LEDArray</th><th>LEDMatrix</th></tr>
<tr><td>LED</td><td>identiques</td><td>individuelles</td></tr>
<tr><td>Calcul</td><td>une LED, mise à l'échelle (rapide)</td><td>chacune des Ns&nbsp;&times;&nbsp;Np LED</td></tr>
<tr><td>Partage du courant entre branches</td><td>égal, par hypothèse</td><td>résultat du calcul</td></tr>
<tr><td>Température de jonction</td><td>une seule</td><td>une par LED (<code>Tj_max</code>)</td></tr>
<tr><td><code>heatPort</code></td><td>jonction commune</td><td><strong>carte</strong> commune (via RthJC de chaque LED)</td></tr>
<tr><td>Dispersion</td><td><code>dVf</code>, <code>kIv</code> appliqués à toutes les LED</td><td>tableaux <code>dVf[j,k]</code>, <code>kIv[j,k]</code>, LED par LED</td></tr>
<tr><td>Ballast</td><td>non</td><td>oui (<code>R_ballast</code> par branche)</td></tr>
</table>
<p>Sans dispersion ni ballast, les deux donnent le même résultat (en reliant le
<code>LEDArray</code> à la carte par RthJC/(Ns&middot;Np)). <code>LEDMatrix</code> n'apporte
donc quelque chose que si les LED <em>diffèrent</em>.</p>
<ul>
<li><strong>Lampe domestique</strong> (LED identiques en série, driver à courant constant) :
    <code>LEDArray</code>.</li>
<li><strong>Spot solaire</strong> (LED en parallèle directement sur la batterie) :
    <code>LEDMatrix</code>, car le partage du courant dépend de la dispersion
    (voir <code>Examples.Basics.LEDMatrixCurrentSharing</code>).</li>
<li><strong>Matrice automobile</strong> : <code>LEDMatrix</code> pour étudier l'homogénéité
    de l'éclairage ou la LED la plus chaude ; sinon <code>LEDArray</code>.</li>
</ul>
</html>"));
end Components;
