within LEDSystems.UsersGuide;
class Conventions "Conventions : unités, tracés, signes, grandeurs, résistances thermiques"
  extends Modelica.Icons.Information;

  annotation (Documentation(info="<html>
<h4>Unités</h4>
<ul>
<li>Toutes les grandeurs sont en unités SI (<code>Modelica.Units.SI</code>). Dans le texte
    d'un modèle, on écrit donc des A, des V, des K : 20&nbsp;mA s'écrit
    <code>0.02</code>, 25&nbsp;°C s'écrit <code>298.15</code>.</li>
<li>Les boîtes de dialogue et les tracés d'OMEdit affichent des unités pratiques
    (<code>displayUnit</code>) : températures en °C, courants en mA, intensités en mcd,
    surfaces en mm², épaisseurs en mm. La saisie dans une boîte de dialogue se fait dans
    l'unité affichée.</li>
<li>Exceptions, pour recopier les datasheets sans conversion : les tables de température
    (<code>IvRel_T_table</code>, <code>Vf_T_table</code>, <code>TemperatureTable</code>) ont
    leur colonne de température <strong>en °C</strong> ; leur description le précise. Les
    courants des tables restent en A.</li>
<li>Le courant de saturation I<sub>s</sub> (de l'ordre de 1e-20&nbsp;A) est laissé en A.</li>
</ul>

<h4>Tracer une grandeur en fonction d'une autre</h4>
<p>Par défaut, OMEdit trace les variables en fonction du temps. Pour tracer par exemple
l'intensité en fonction du courant (Iv = f(If)), il faut un <em>tracé paramétrique</em> :</p>
<ol>
<li>après la simulation, dans l'onglet de tracé, ouvrir une nouvelle fenêtre de tracé
    paramétrique (menu ou bouton de la barre d'outils) ;</li>
<li>dans le navigateur de variables, <strong>maintenir la touche Maj enfoncée</strong>, puis
    cliquer sur la variable à afficher <strong>en x</strong> (par exemple <code>led.If</code>) ;</li>
<li><strong>relâcher Maj</strong>, puis cliquer sur la variable à afficher <strong>en y</strong>
    (par exemple <code>led.Iv</code>).</li>
</ol>
<p>Pour superposer une seconde courbe, recommencer les étapes 2 et 3 dans la même fenêtre.
L'unité d'affichage de chaque axe (mA, mcd…) se choisit dans la colonne « Unité » du
navigateur de variables.</p>

<h4>Signes</h4>
<ul>
<li>Électrique : convention récepteur de la MSL (<code>OnePort</code>) :
    <code>v = p.v &minus; n.v</code>, <code>i</code> entre par <code>p</code>. Une LED
    passante a v &gt; 0 et i &gt; 0.</li>
<li>Thermique : convention de la MSL, <code>Q_flow</code> positif quand la chaleur entre
    dans le composant. La LED <em>fournit</em> de la chaleur :
    <code>heatPort.Q_flow = &minus;Qth</code> (négatif). Une plaque branchée dessus reçoit
    <code>port.Q_flow = +Qth</code>.</li>
</ul>

<h4>Grandeurs d'une LED, grandeurs totales</h4>
<p>Pour <code>LEDArray</code> (Ns LED en série dans chacune de Np branches) :</p>
<ul>
<li><code>Vf</code>, <code>If</code> : tension et courant <strong>d'une</strong> LED,
    comparables au datasheet ;</li>
<li><code>v</code>, <code>i</code> : tension et courant aux bornes de l'ensemble
    (v = Ns&middot;Vf, i = Np&middot;If) ;</li>
<li><code>Iv</code>, <code>Phi_v</code>, <code>P_elec</code>, <code>P_opt</code>,
    <code>Qth</code> : <strong>totaux</strong> de l'ensemble.</li>
</ul>
<p>Pour <code>LEDMatrix</code>, mêmes totaux ; le détail de chaque LED est dans
<code>led[j, k]</code> (position j dans la branche, branche k).</p>

<h4>Résistances thermiques</h4>
<ul>
<li><code>RthJC</code> : jonction - boîtier ou jonction - point de soudure, propre à la LED.
    <code>RthJA</code> : jonction - ambiance, mesurée par le fabricant sur une carte
    normalisée ; 0 si le datasheet ne la donne pas.</li>
<li>Certains fabricants (Bridgelux) calculent ces résistances avec la <strong>puissance
    électrique totale</strong>, d'autres (Lumileds) avec la <strong>chaleur</strong>
    réellement dissipée. Le modèle fait passer la chaleur Qth = P<sub>elec</sub> &minus;
    P<sub>opt</sub> : il utilise <code>RthJC_heat</code> et <code>RthJA_heat</code>, déduites
    du datasheet selon la case <code>RthJC_onElectricalPower</code> (division par
    1 &minus; rendement).</li>
</ul>

<h4>Températures de référence</h4>
<p>Chaque donnée du datasheet a sa température de jonction de mesure, à saisir dans le
record : <code>Tj_refIV</code> (courbe If = f(Vf)), <code>Tj_refVf</code> (référence de la
variation de Vf), <code>Tj_refLight</code> (référence photométrique). Elles valent en
général 25&nbsp;°C ; 85&nbsp;°C pour la LED de phare Lumileds.</p>

<h4>Noms</h4>
<ul>
<li>Classes en <code>UpperCamelCase</code>, paramètres et variables en
    <code>lowerCamelCase</code>, comme dans la MSL.</li>
<li>Symboles des datasheets conservés : <code>Vf</code>, <code>If</code>, <code>Iv</code>,
    <code>Phi_v</code>, <code>Tj</code>, <code>RthJC</code>, <code>TCVf</code>&hellip;, avec un
    suffixe pour les variantes : <code>_typ</code> (typique), <code>_nom</code> (point de
    référence), <code>_ref</code>, <code>_table</code>.</li>
<li>Identifiants en anglais ; documentation en français.</li>
</ul>
</html>"));
end Conventions;
