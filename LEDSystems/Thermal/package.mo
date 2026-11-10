within LEDSystems;
package Thermal "Environnement thermique de la jonction : températures imposées et dissipateurs"
  extends Modelica.Icons.Package;

  annotation (Documentation(info="<html>
<p>Composants à brancher sur le <code>heatPort</code> d'une LED, qui représente sa
<strong>jonction</strong>.</p>
<p>Deux familles :</p>
<ul>
<li><strong>Rejeu</strong> : <code>FixedTemperature</code>, <code>TemperatureTable</code>,
    <code>TemperatureFirstOrder</code> imposent la température de jonction, quelle que soit
    la puissance dissipée. Ils servent à rejouer des mesures ou un scénario connu.</li>
<li><strong>Prédiction</strong> : <code>Plate</code> calcule la température à partir de la
    puissance dissipée par la LED (résistance thermique vers l'ambiance et capacité
    thermique de la plaque).</li>
</ul>
</html>"));
end Thermal;
