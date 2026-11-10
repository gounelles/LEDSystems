within LEDSystems.Types;
type LightTemperatureModel = enumeration(
    Table "Table Iv relative = f(T) (IvRel_T_table)",
    Linear "Coefficient linéaire TCIV")
  "Modèle de l'effet de la température de jonction sur la lumière émise"
  annotation (Documentation(info = "<html>
<p>Choix du modèle de l'effet de la température sur l'intensité (et le flux), paramètre
<code>lightTemperatureModel</code> du record
<a href=\"modelica://LEDSystems.Data.LEDData\">LEDData</a> (onglet « Lumière », groupe
« Effet de la température ») :</p>
<ul>
<li><code>Table</code> : facteur lu dans la courbe relative du datasheet
    <code>IvRel_T_table</code> (T en °C), normalisé à 1 à <code>Tj_refLight</code>, maintenu
    constant hors de [<code>T_minTable</code>, <code>T_maxTable</code>]. Choix par défaut :
    les datasheets donnent presque toujours cette courbe, souvent non linéaire ;</li>
<li><code>Linear</code> : facteur 1 + <code>TCIV</code>&middot;(Tj &minus;
    <code>Tj_refLight</code>), avec <code>TCIV</code> en 1/K (négatif). À choisir si le
    datasheet ne donne qu'un coefficient.</li>
</ul>
<p>Le paramètre de l'autre option est ignoré. Dans le sous-dialogue <code>data</code>
d'OMEdit 1.26, il n'est pas grisé : se fier à sa description.</p>
</html>"));
