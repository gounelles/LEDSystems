within ;
package LEDSystems "Bibliothèque de LED : modèles électrique, photométrique et thermique, LED seules ou en réseaux"
  extends Modelica.Icons.Package;

  annotation (
    version="1.0.0",
    versionDate="2026-11-10",
    uses(Modelica(version="4.1.0")),
    Documentation(info="<html>
<h4>LEDSystems</h4>
<p>Bibliothèque Modelica pour simuler des LED (diodes électroluminescentes), seules ou en
réseaux, à partir de leur datasheet : tension et courant, intensité et flux lumineux,
puissance dissipée et température de jonction.</p>
<p>Elle est écrite pour l'enseignement (Sciences de l'ingénieur, STI2D) et pour le
dimensionnement de systèmes d'éclairage simples : choix d'un courant, d'un montage série
ou parallèle, d'un dissipateur ; vérification de la température de jonction.</p>
<h4>Contenu</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Package</th><th>Rôle</th></tr>
<tr><td><a href=\"modelica://LEDSystems.UsersGuide\">UsersGuide</a></td><td>Guide
    d'utilisation, notes de version, licence</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Examples\">Examples</a></td><td>Exemples de base,
    puis trois cas d'usage validés sur des datasheets réels</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Components\">Components</a></td><td>LED seule,
    réseau de LED identiques, matrice de LED individuelles, LED sur plaque</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Thermal\">Thermal</a></td><td>Environnement
    thermique de la jonction : températures imposées, plaque dissipatrice</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Data\">Data</a></td><td>Données des LED : record
    de base et un record par LED réelle</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Interfaces\">Interfaces</a></td><td>Connecteur
    photométrique</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Functions\">Functions</a></td><td>Calage du modèle
    électrique, interpolation des courbes du datasheet, dispersion de fabrication</td></tr>
<tr><td><a href=\"modelica://LEDSystems.Types\">Types</a></td><td>Énumérations</td></tr>
</table>
<h4>Pour commencer</h4>
<p>Ouvrir les exemples de <a href=\"modelica://LEDSystems.Examples.Basics\">Examples.Basics</a>,
dans l'ordre : leur documentation dit quoi observer et donne les valeurs attendues.</p>
<p>Bibliothèque fondée sur la seule Modelica Standard Library (version 4.1.0), testée
avec OpenModelica 1.26.1.</p>
<p>&copy; 2026 Stéphane Gounelle. Code sous licence BSD-3-Clause, documentation et images
sous licence CC BY 4.0 (voir <a href=\"modelica://LEDSystems.UsersGuide\">UsersGuide</a>).</p>
</html>")
  );
end LEDSystems;
