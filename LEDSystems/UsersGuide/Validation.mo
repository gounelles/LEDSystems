within LEDSystems.UsersGuide;
class Validation "Validation : comparaison aux datasheets, limites connues"
  extends Modelica.Icons.Information;

  annotation (Documentation(info="<html>
<h4>Méthode</h4>
<p>Chaque LED de la bibliothèque est comparée à son datasheet, seule source disponible
(pas de mesures). Les points du datasheet sont partagés en deux groupes :</p>
<ul>
<li>points de <strong>calage</strong> : ils servent à écrire le record (3 points I-V,
    courbes relatives). Les retrouver prouve seulement que la saisie est juste ;</li>
<li>points de <strong>validation</strong> : ils ne sont pas dans le record (autres points des
    courbes, tableaux, autres températures). Ce sont eux qui valident le modèle.</li>
</ul>
<p>Les tolérances sont les <strong>tolérances de mesure annoncées par les fabricants</strong>,
fixées avant toute simulation et jamais ajustées : Vf &plusmn;0,1&nbsp;V et flux
&plusmn;7,5&nbsp;% (Bridgelux) ; Vf &plusmn;0,06&nbsp;V et flux &plusmn;6,5&nbsp;% (Lumileds).
Chaque point est simulé à sa température de jonction (jonction imposée par
<code>Thermal.FixedTemperature</code>).</p>

<h4>Résultats</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>LED (record)</th><th>Calage</th><th>Validation</th><th>Plus grand écart en validation</th></tr>
<tr><td>Bridgelux DS55 (<code>Bridgelux_BXEN_57E_11L</code>)</td><td>15/15</td><td>29/29</td>
    <td>Vf +50&nbsp;mV (Tab. 3, valeurs arrondies à 0,1&nbsp;V) ; flux &minus;5,7&nbsp;% à 20&nbsp;mA</td></tr>
<tr><td>Bridgelux DS242 (<code>Bridgelux_BXEN_30G_11M</code>)</td><td>11/11</td><td>30/32</td>
    <td>Vf +48&nbsp;mV à 30&nbsp;mA (Tab. 3) ; flux +9,1&nbsp;% et +8,3&nbsp;% à 85&nbsp;°C
    (incohérence du datasheet, voir plus bas)</td></tr>
<tr><td>Lumileds DS394 (<code>Lumileds_LUXEON_FX2L_Plus_CW</code>)</td><td>15/15</td><td>33/33</td>
    <td>Vf +53&nbsp;mV à 100&nbsp;mA et 25&nbsp;°C ; flux &minus;4,8&nbsp;% à 50&nbsp;mA et 25&nbsp;°C</td></tr>
<tr><td>Vishay (<code>Vishay_VLMW41S1T1</code>)</td><td>8/8</td><td>&ndash;</td>
    <td>pas de point de validation : LED de démonstration</td></tr>
</table>

<h4>Limites connues</h4>
<ul>
<li><strong>Facteur d'idéalité n constant</strong> : une seule exponentielle décrit toute la
    courbe I-V. Calée à 85&nbsp;°C, la LED Lumileds s'écarte de +53&nbsp;mV de la courbe à
    25&nbsp;°C (dans la tolérance de &plusmn;60&nbsp;mV, mais proche).</li>
<li><strong>Effet de la température indépendant du courant</strong> : la courbe de flux en
    fonction de la température n'est donnée qu'à un courant. Lumileds : &minus;4,8&nbsp;% sur
    le flux à 25&nbsp;°C et 50&nbsp;mA.</li>
<li><strong>Incohérence du datasheet DS242</strong> (Rev. F, dernière version publiée) : sa
    Tab. 3 donne à 85&nbsp;°C, de 42 à 120&nbsp;mA, un flux d'environ 0,83 fois celui à
    25&nbsp;°C, contre 0,90 dans sa Tab. 2 et sa Fig. 4 à 150&nbsp;mA. Aucun modèle dont le
    facteur thermique ne dépend que de la température ne peut suivre les deux ; le modèle
    suit la Fig. 4. Ces points sont signalés « écart probable du datasheet ».</li>
<li><strong>Extrapolations</strong> : hors des courbes du datasheet, le modèle extrapole sans
    validation : courants faibles (sous 10&nbsp;mA pour les Bridgelux), froid (sous
    17&nbsp;°C pour le DS55, valeur de l'extrémité maintenue).</li>
<li><strong>Conditions de mesure</strong> : quand le datasheet ne dit pas si une courbe est
    pulsée ou continue, une hypothèse est faite et documentée dans le record. Une courbe
    donnée en fonction de Tsp ou de Tamb est ramenée à Tj (DS55 : +5,4&nbsp;K) ou appliquée
    telle quelle à Tj (Vishay, Fig. 7) : approximation.</li>
<li><strong>Puissance optique</strong> : elle dépend de la LER, calculée sur le spectre du
    datasheet (&plusmn;3&nbsp;% environ) avec une approximation analytique de V(&lambda;) ; pour
    la Vishay, valeur typique de 300&nbsp;lm/W. La chaleur Qth en dépend.</li>
<li><strong>Thermique</strong> : la LED n'a pas de masse thermique propre ; pas de
    vieillissement ni de dépréciation du flux.</li>
</ul>

<h4>Refaire les tests</h4>
<p>Les scripts Python (bibliothèque standard seulement) sont dans le dossier
<code>outils/</code> du dépôt, à lancer depuis sa racine, avec OpenModelica installé :</p>
<ul>
<li><code>python3 outils/verifier.py</code> : vérifie, compile et simule tous les
    exemples ;</li>
<li><code>python3 outils/tester_cas_usage.py</code> : compare les trois LED des cas d'usage
    à leurs datasheets (points de calage et de validation, avec leur source) ;</li>
<li><code>python3 outils/tester_datasheet.py</code> : contrôle de la LED Vishay ;</li>
<li><code>python3 outils/calculs_reference.py</code> : calages exacts, approximation de
    V(&lambda;), LER des spectres, calculés hors Modelica.</li>
</ul>
<p>Les valeurs de référence (avec page, figure ou tableau du datasheet) sont dans
<code>outils/references_cas_usage.py</code>. Les datasheets eux-mêmes ne sont pas fournis
(droits d'auteur) : voir <a href=\"modelica://LEDSystems.UsersGuide.References\">References</a>.</p>
</html>"));
end Validation;
