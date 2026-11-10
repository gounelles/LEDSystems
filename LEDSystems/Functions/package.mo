within LEDSystems;
package Functions "Fonctions de calcul : calage électrique, courbes du datasheet, dispersion"
  extends Modelica.Icons.FunctionsPackage;

  annotation (Documentation(info="<html>
<p>Fonctions utilisées par les composants et les records de données. L'utilisateur n'a en
général pas à les appeler lui-même.</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Fonction</th><th>Rôle</th></tr>
<tr><td><a href=\"modelica://LEDSystems.Functions.fitShockley3Points\">fitShockley3Points</a></td>
    <td>Calcule les paramètres de Shockley (Is, n, Rs) qui font passer le modèle exactement
    par 3 points de la courbe If = f(Vf) du datasheet</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Functions.ShockleyParams\">ShockleyParams</a></td>
    <td>Record de sortie du calage (Is, n, Rs)</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Functions.relativeIntensity\">relativeIntensity</a></td>
    <td>Intensité relative en fonction du courant, interpolée dans la courbe du datasheet
    (échelles logarithmiques)</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Functions.interpolateClamped\">interpolateClamped</a></td>
    <td>Interpolation linéaire bornée (intensité relative en fonction de la température,
    variation de Vf avec la température)</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Functions.dispersion\">dispersion</a></td>
    <td>Valeurs reproductibles réparties entre le minimum et le maximum du datasheet, pour
    la dispersion de fabrication d'une matrice de LED</td></tr>
</table>
</html>"));
end Functions;
