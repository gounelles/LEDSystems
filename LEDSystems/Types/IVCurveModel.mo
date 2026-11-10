within LEDSystems.Types;
type IVCurveModel = enumeration(
    ThreePointFit "Calage sur 3 points de la courbe If = f(Vf)",
    ShockleyParameters "Paramètres Is_ref, n_ref, Rs_ref fournis")
  "Origine des paramètres du modèle électrique (Shockley + Rs)"
  annotation (Documentation(info = "<html>
<p>Choix de l'origine des paramètres I<sub>s</sub>, n et R<sub>s</sub> du modèle électrique,
paramètre <code>ivCurveModel</code> du record
<a href=\"modelica://LEDSystems.Data.LEDData\">LEDData</a> (onglet « Avancé », groupe
« Courbe I-V ») :</p>
<ul>
<li><code>ThreePointFit</code> : les trois paramètres sont calculés exactement par
    <a href=\"modelica://LEDSystems.Functions.fitShockley3Points\">fitShockley3Points</a> à
    partir de trois points (<code>V1_fit</code>, <code>I1_fit</code>…) lus sur la courbe
    If = f(Vf) du datasheet, à <code>Tj_refIV</code>. Choix normal : un datasheet de LED
    donne cette courbe, jamais les paramètres de Shockley ;</li>
<li><code>ShockleyParameters</code> : <code>Is_ref</code>, <code>n_ref</code> et
    <code>Rs_ref</code> sont saisis directement (paramètres issus d'un modèle SPICE, d'un
    calage fait ailleurs, ou d'un exercice).</li>
</ul>
<p>Les paramètres de l'autre option sont ignorés. Dans le sous-dialogue <code>data</code>
d'OMEdit 1.26, ils ne sont pas grisés : se fier à leur description.</p>
</html>"));
