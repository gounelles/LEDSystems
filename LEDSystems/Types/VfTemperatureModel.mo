within LEDSystems.Types;
type VfTemperatureModel = enumeration(
    Linear "Coefficient linéaire TCVf",
    Table "Table Vf = f(T) (Vf_T_table)")
  "Modèle de la variation de la tension directe Vf avec la température de jonction"
  annotation (Documentation(info = "<html>
<p>Choix du modèle de Vf(T), paramètre <code>vfTemperatureModel</code> du record
<a href=\"modelica://LEDSystems.Data.LEDData\">LEDData</a> (onglet « Avancé », groupe
« Vf en fonction de la température ») :</p>
<ul>
<li><code>Linear</code> : Vf varie de <code>TCVf</code> (en V/K, négatif) par kelvin
    d'écart à <code>Tj_refVf</code>. À choisir quand le datasheet ne donne qu'un coefficient
    de température, ou une courbe Vf = f(T) presque droite (cas le plus courant) ;</li>
<li><code>Table</code> : décalage de Vf lu dans <code>Vf_T_table</code> (T en °C, Vf en V),
    par différence avec sa valeur à <code>Tj_refVf</code>. À choisir quand le datasheet donne
    une courbe Vf (ou &Delta;Vf) = f(T) nettement courbée (exemple :
    <a href=\"modelica://LEDSystems.Data.Lumileds_LUXEON_FX2L_Plus_CW\">Lumileds_LUXEON_FX2L_Plus_CW</a>).</li>
</ul>
<p>Le paramètre de l'autre option est ignoré. Dans le sous-dialogue <code>data</code>
d'OMEdit 1.26, il n'est pas grisé : se fier à sa description.</p>
</html>"));
