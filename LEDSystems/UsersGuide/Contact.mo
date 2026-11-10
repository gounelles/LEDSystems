within LEDSystems.UsersGuide;
class Contact "Contact et origine de la bibliothèque"
  extends Modelica.Icons.Contact;

  annotation (Documentation(info="<html>
<h4>Auteur</h4>
<p>Stéphane Gounelle, enseignant en Sciences de l'ingénieur.<br/>
Courriel : <a href=\"mailto:gounelles@gmail.com\">gounelles@gmail.com</a><br/>
Dépôt : <a href=\"https://github.com/gounelles/LEDSystems\">github.com/gounelles/LEDSystems</a>
(signaler un problème, proposer une LED ou une correction : onglet « Issues »).</p>

<h4>Origine</h4>
<p>La bibliothèque a d'abord été écrite à la main par l'auteur (version 0.4.0, non
fonctionnelle : un exemple sur sept ne compilait pas, et le modèle ne reproduisait que trois
points sur huit de son datasheet). Elle a ensuite été finalisée avec l'assistant Claude Code
(Anthropic), étape par étape, chaque étape étant présentée, discutée et validée par
l'auteur :</p>
<ol>
<li>restructuration (nom, arborescence, MSL 4.1.0), sans changer les calculs ;</li>
<li>refonte du composant LED et des données (port thermique permanent, unités, package
    <code>Thermal</code>) ;</li>
<li>correction des calculs (calage exact, photométrie par les courbes du datasheet) ;</li>
<li>réseaux et matrices de LED ;</li>
<li>validation sur trois datasheets réels, un par cas d'usage ;</li>
<li>documentation et publication.</li>
</ol>
<p>Le fichier <code>CLAUDE.md</code>, à la racine du dépôt, contient les règles de travail,
les décisions et le journal complet de ces étapes.</p>
</html>"));
end Contact;
