within LEDSystems;
package Data "Données des LED : record de base et records des LED réelles"
  extends Modelica.Icons.RecordsPackage;

  annotation (Documentation(info="<html>
<p>Un composant LED reçoit ses caractéristiques par son paramètre <code>data</code>, un
record qui étend <a href=\"modelica://LEDSystems.Data.LEDData\">LEDData</a>. Chaque LED
réelle a son record, dont chaque valeur est commentée avec sa source dans le datasheet
(page, figure ou tableau, conditions de mesure).</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Record</th><th>LED</th><th>Utilisée par</th></tr>
<tr><td><a href=\"modelica://LEDSystems.Data.Vishay_VLMW41S1T1\">Vishay_VLMW41S1T1</a></td>
    <td>LED CMS blanc froid de signalisation, 20&nbsp;mA</td>
    <td>Exemples de base</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Data.Bridgelux_BXEN_57E_11L\">Bridgelux_BXEN_57E_11L</a></td>
    <td>SMD 2835 0,2&nbsp;W, 5700&nbsp;K</td>
    <td>Spot solaire</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Data.Bridgelux_BXEN_30G_11M\">Bridgelux_BXEN_30G_11M</a></td>
    <td>SMD 2835 0,5&nbsp;W, 3000&nbsp;K, IRC 90</td>
    <td>Lampe domestique</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Data.Lumileds_LUXEON_FX2L_Plus_CW\">Lumileds_LUXEON_FX2L_Plus_CW</a></td>
    <td>LED de puissance blanc froid pour phare automobile</td>
    <td>Phare automobile</td></tr>
</table>
<p>Pour une nouvelle LED : copier le record le plus proche (même type de datasheet :
intensité en mcd ou flux en lm), puis remplacer chaque valeur par celle du nouveau
datasheet, en notant sa source. Les records Bridgelux et Lumileds ont été validés sur des
points du datasheet qui ne servent pas au calage (voir le guide d'utilisation).</p>
<p>Les datasheets eux-mêmes ne sont pas fournis (droits d'auteur des fabricants) : chaque
record donne la référence exacte du document et sa révision.</p>
</html>"));
end Data;
