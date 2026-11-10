within LEDSystems.Components;
model LEDArray "Réseau de Ns x Np LED identiques (modèle agrégé) : Np branches en parallèle de Ns LED en série"
  extends LEDSystems.Components.BaseClasses.PartialLED(Ns = 3, Np = 1);

  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}),
      graphics = {
        Line(points = {{-90, 0}, {90, 0}}, thickness = 1),
        Polygon(points = {{-66, 16}, {-66, -16}, {-42, 0}, {-66, 16}}, fillPattern = FillPattern.Solid),
        Line(points = {{-42, 16}, {-42, -16}}, thickness = 1),
        Polygon(points = {{-12, 16}, {-12, -16}, {12, 0}, {-12, 16}}, fillPattern = FillPattern.Solid),
        Line(points = {{12, 16}, {12, -16}}, thickness = 1),
        Polygon(points = {{42, 16}, {42, -16}, {66, 0}, {42, 16}}, fillPattern = FillPattern.Solid),
        Line(points = {{66, 16}, {66, -16}}, thickness = 1),
        Line(points = {{-6, 26}, {10, 42}}, thickness = 1),
        Polygon(points = {{14, 46}, {4, 42}, {10, 36}, {14, 46}}, fillPattern = FillPattern.Solid),
        Line(points = {{6, 26}, {22, 42}}, thickness = 1),
        Polygon(points = {{26, 46}, {16, 42}, {22, 36}, {26, 46}}, fillPattern = FillPattern.Solid),
        Rectangle(extent = {{-80, 30}, {80, -30}}, lineColor = {0, 0, 0}, pattern = LinePattern.Dash),
        Text(extent = {{-100, -40}, {100, -70}}, textString = "%Ns × %Np"),
        Text(extent = {{-150, -80}, {150, -110}}, textString = "%name", textColor = {0, 0, 255})}),
    Documentation(info = "<html>
<p>Ensemble de <code>Ns</code>&nbsp;&times;&nbsp;<code>Np</code> LED <strong>identiques</strong> :
<code>Np</code> branches en parallèle, chacune de <code>Ns</code> LED en série. Un seul
modèle de LED est calculé, puis mis à l'échelle (tension &times;&nbsp;Ns, courant
&times;&nbsp;Np, flux et puissances &times;&nbsp;Ns&middot;Np) : c'est rapide, même pour
des dizaines de LED.</p>
<p>Hypothèses : toutes les LED ont les mêmes données et la <strong>même température de
jonction</strong> (même support thermique, par exemple une lampe domestique dont les LED
sont sur un circuit commun). Le <code>heatPort</code> représente cette jonction commune
et reçoit la chaleur de toutes les LED.</p>
<p>Grandeurs :</p>
<ul>
<li><code>Vf</code>, <code>If</code> : tension et courant d'<em>une</em> LED (comparables au
    datasheet) ; <code>v</code>, <code>i</code> : tension et courant totaux ;</li>
<li><code>Iv</code>, <code>Phi_v</code>, <code>P_elec</code>, <code>P_opt</code>,
    <code>Qth</code> : totaux de l'ensemble.</li>
</ul>
<p>Pour des LED différentes les unes des autres (dispersion de fabrication, partage du
courant entre branches) : <code>LEDMatrix</code>.</p>
</html>"));
end LEDArray;
