within LEDSystems;
package Interfaces "Connecteurs de la bibliothèque"
  extends Modelica.Icons.InterfacesPackage;

  annotation (Documentation(info="<html>
<p>Connecteurs propres à la bibliothèque. Les connecteurs électriques et thermiques sont
ceux de la MSL (<code>Modelica.Electrical.Analog.Interfaces</code>,
<code>Modelica.Thermal.HeatTransfer.Interfaces</code>) : les composants LED se branchent
donc sur n'importe quel circuit ou réseau thermique de la MSL.</p>
<ul>
<li><a href=\"modelica://LEDSystems.Interfaces.LightPort\">LightPort</a> : sortie
    photométrique d'une LED (flux et intensité).</li>
</ul>
</html>"));
end Interfaces;
