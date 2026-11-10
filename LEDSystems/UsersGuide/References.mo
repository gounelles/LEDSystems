within LEDSystems.UsersGuide;
class References "Références : datasheets et publications utilisés"
  extends Modelica.Icons.References;

  annotation (Documentation(info="<html>
<h4>Datasheets</h4>
<p>Les datasheets ne sont pas fournis avec la bibliothèque (droits d'auteur des
fabricants) : ils sont disponibles sur le site de chaque fabricant. Les records ne
contiennent que des valeurs extraites, chacune avec sa source.</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Record</th><th>Document</th></tr>
<tr><td><a href=\"modelica://LEDSystems.Data.Vishay_VLMW41S1T1\">Vishay_VLMW41S1T1</a></td>
    <td>Vishay Semiconductors, VLMW41.. (document 82411),
    <a href=\"https://www.vishay.com/docs/82411/vlmw41.pdf\">www.vishay.com/docs/82411/vlmw41.pdf</a></td></tr>
<tr><td><a href=\"modelica://LEDSystems.Data.Bridgelux_BXEN_57E_11L\">Bridgelux_BXEN_57E_11L</a></td>
    <td>Bridgelux, SMD 2835 0.2W 3V Product Data Sheet DS55, Rev. B (07/2016),
    <a href=\"https://www.bridgelux.com\">www.bridgelux.com</a></td></tr>
<tr><td><a href=\"modelica://LEDSystems.Data.Bridgelux_BXEN_30G_11M\">Bridgelux_BXEN_30G_11M</a></td>
    <td>Bridgelux, SMD 2835 0.5W 3V Product Data Sheet DS242, Rev. F (04/2024),
    <a href=\"https://www.bridgelux.com/sites/default/files/DS242.pdf\">www.bridgelux.com/sites/default/files/DS242.pdf</a></td></tr>
<tr><td><a href=\"modelica://LEDSystems.Data.Lumileds_LUXEON_FX2L_Plus_CW\">Lumileds_LUXEON_FX2L_Plus_CW</a></td>
    <td>Lumileds, LUXEON FX2-L Plus Cool White Product Datasheet DS394 (20231206),
    <a href=\"https://lumileds.com\">lumileds.com</a></td></tr>
</table>
<p>Un fabricant peut publier une nouvelle révision : vérifier la révision indiquée dans le
record avant de comparer.</p>

<h4>Publications</h4>
<ul>
<li>C. Wyman, P.-P. Sloan, P. Shirley, « Simple Analytic Approximations to the CIE XYZ Color
    Matching Functions », <em>Journal of Computer Graphics Techniques</em>, vol. 2, n° 2,
    2013. Approximation de la fonction d'efficacité lumineuse V(&lambda;), utilisée pour
    calculer la LER à partir des spectres des datasheets (écart à la table de la CIE
    inférieur à 0,005).</li>
<li>W. Shockley, « The Theory of p-n Junctions in Semiconductors and p-n Junction
    Transistors », <em>Bell System Technical Journal</em>, vol. 28, n° 3, 1949. Équation de la
    diode.</li>
</ul>

<h4>Logiciels</h4>
<ul>
<li>Modelica Standard Library 4.1.0,
    <a href=\"https://github.com/modelica/ModelicaStandardLibrary\">github.com/modelica/ModelicaStandardLibrary</a>.</li>
<li>OpenModelica 1.26.1, <a href=\"https://openmodelica.org\">openmodelica.org</a>.</li>
</ul>
</html>"));
end References;
