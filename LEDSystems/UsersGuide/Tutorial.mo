within LEDSystems.UsersGuide;
class Tutorial "Tutoriel : paramétrer une LED à partir de son datasheet"
  extends Modelica.Icons.Information;

  annotation (Documentation(info="<html>
<p>Ce tutoriel suit, pas à pas, l'écriture du record
<a href=\"modelica://LEDSystems.Data.Bridgelux_BXEN_57E_11L\">Bridgelux_BXEN_57E_11L</a> : une
LED blanche SMD 2835 de 0,2&nbsp;W, datasheet Bridgelux DS55 Rev. B. Ouvrir ce record en
mode texte à côté du tutoriel : chaque valeur y est commentée avec sa source. Les encadrés
« LED en mcd » signalent ce qui change pour un datasheet qui donne l'intensité (LED de
signalisation, comme la
<a href=\"modelica://LEDSystems.Data.Vishay_VLMW41S1T1\">Vishay_VLMW41S1T1</a>).</p>

<h4>0. Lire les conditions de mesure du datasheet</h4>
<p>Avant de recopier une valeur, noter <strong>à quelle température</strong> elle a été
mesurée, et <strong>où</strong> :</p>
<ul>
<li>mesure <strong>pulsée</strong> (impulsions de quelques ms) : la jonction n'a pas le temps
    de chauffer, Tj = température du support (25&nbsp;°C en général) ;</li>
<li>mesure <strong>continue</strong> à température de point de soudure Tsp donnée : la
    jonction est plus chaude que Tsp, de RthJC&middot;P ;</li>
<li>température ambiante Tamb (LED de signalisation) : la jonction est encore plus chaude.</li>
</ul>
<p>Le modèle travaille toujours en <strong>température de jonction</strong>. Pour le DS55 :
tableaux et courbes I-V pulsés (Tj = 25&nbsp;°C) ; courbe de flux en fonction de la
température en continu à 60&nbsp;mA, en fonction de Tsp (voir l'étape 4).</p>

<h4>1. Créer le record</h4>
<p>Ne pas modifier la bibliothèque : créer son propre package (par exemple
<code>MesLED</code>), puis dans ce package un record qui étend
<code>LEDSystems.Data.LEDData</code>. Le plus simple est de copier le texte d'un record de la
bibliothèque (vue texte d'OMEdit) et de remplacer les valeurs une à une :</p>
<pre>
within MesLED;
record MaLED \"Ma LED : référence, datasheet, révision\"
  extends LEDSystems.Data.LEDData(
    colorName = \"Cool white 5700 K\",
    Vf_typ = 3.1,
    If_typ = 60e-3,
    ...);
end MaLED;
</pre>
<p>Les valeurs s'écrivent en unités SI (A, V, K, W) ; OMEdit les affiche ensuite en mA, °C,
etc. Noter la source de chaque valeur en commentaire : elle servira à la vérification.</p>
<p>Une IA (assistant conversationnel capable de lire un PDF) peut préparer un premier jet du
record et relever les incohérences du datasheet : voir l'étape 8. Les étapes 2 à 6
restent nécessaires pour contrôler son travail.</p>

<h4>2. Onglet « General » : caractéristiques principales et référence photométrique</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Paramètre</th><th>Valeur DS55</th><th>Source</th></tr>
<tr><td><code>Vf_typ</code>, <code>If_typ</code></td><td>3,1&nbsp;V ; 60&nbsp;mA</td>
    <td>Tab. 1 p. 3 (pulsé, 25&nbsp;°C)</td></tr>
<tr><td><code>photometricInput</code></td><td><code>LuminousFlux</code></td>
    <td>le datasheet donne un flux</td></tr>
<tr><td><code>Phi_nom</code>, <code>If_nom</code></td><td>26&nbsp;lm ; 60&nbsp;mA</td>
    <td>Tab. 1 p. 3, flux typique</td></tr>
<tr><td><code>phi_half</code></td><td>60°</td>
    <td>Fig. 7 p. 13 : angle de vue 120° = 2 &times; phi_half</td></tr>
</table>
<p><em>LED en mcd</em> : <code>photometricInput = LuminousIntensity</code> et
<code>Iv_nom</code> (en cd dans le texte : 275&nbsp;mcd s'écrit 0.275) au courant
<code>If_nom</code> du tableau.</p>

<h4>3. Onglet « Avancé » : calage du modèle électrique</h4>
<p>Cet onglet contient deux <strong>choix de modèle</strong> (listes déroulantes), qui disent
quelle donnée du datasheet est utilisée. Les paramètres de l'option non retenue sont
ignorés ; OMEdit ne les grise pas dans le sous-dialogue <code>data</code> : leur description
indique quand ils servent (« sert si … »).</p>
<ul>
<li><code>ivCurveModel</code> : <code>ThreePointFit</code> (calage sur 3 points de la courbe
    If = f(Vf), le cas normal) ou <code>ShockleyParameters</code> (I<sub>s</sub>, n,
    R<sub>s</sub> saisis directement, s'ils viennent d'ailleurs : modèle SPICE, exercice) ;</li>
<li><code>vfTemperatureModel</code> : <code>Linear</code> (coefficient <code>TCVf</code>) ou
    <code>Table</code> (courbe <code>Vf_T_table</code>).</li>
</ul>
<p>Pour le DS55, <code>ivCurveModel = ThreePointFit</code>. Choisir <strong>3 points</strong> sur la courbe If = f(Vf) : un en bas, un au milieu, un en
haut de la plage où la LED sera utilisée, bien écartés. Pour le DS55 (Fig. 2 p. 10, de
10 à 80&nbsp;mA) :</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Point</th><th>Vf</th><th>If</th></tr>
<tr><td>1 (<code>V1_fit</code>, <code>I1_fit</code>)</td><td>2,68&nbsp;V</td><td>9,9&nbsp;mA</td></tr>
<tr><td>2</td><td>2,90&nbsp;V</td><td>33,5&nbsp;mA</td></tr>
<tr><td>3</td><td>3,23&nbsp;V</td><td>79,3&nbsp;mA</td></tr>
</table>
<p><code>Tj_refIV</code> = 25&nbsp;°C, température de jonction de la courbe. La fonction
<a href=\"modelica://LEDSystems.Functions.fitShockley3Points\">fitShockley3Points</a> calcule
les paramètres qui font passer le modèle exactement par ces 3 points :
n = 2,51 ; I<sub>s</sub> = 2,2e-20&nbsp;A ; R<sub>s</sub> = 6,0&nbsp;&Omega;. Si les points sont
incohérents (courbe lue de travers, points trop proches), la résistance série sort négative
et la simulation s'arrête avec un message : relire les points.</p>
<p>Variation de Vf avec la température : le DS55 donne un coefficient,
<code>TCVf</code> = &minus;1,9&nbsp;mV/K (Tab. 4 p. 5), à la référence
<code>Tj_refVf</code> = 25&nbsp;°C. D'où <code>vfTemperatureModel = Linear</code>. Si le datasheet
donne une courbe nettement courbée, choisir <code>Table</code> et saisir <code>Vf_T_table</code> (exemple : record
<a href=\"modelica://LEDSystems.Data.Lumileds_LUXEON_FX2L_Plus_CW\">Lumileds_LUXEON_FX2L_Plus_CW</a>).</p>

<h4>4. Onglet « Thermique » : résistances thermiques et leur convention</h4>
<p>Le DS55 donne R<sub>th j-sp</sub> = 29&nbsp;K/W (jonction - point de soudure, Tab. 4), et
précise en note qu'elle est <strong>calculée avec la puissance électrique totale</strong>.
Or une partie de cette puissance part en lumière : la chaleur réelle est plus faible, et la
vraie résistance plus grande. On saisit donc <code>RthJC</code> = 29 et on coche
<code>RthJC_onElectricalPower</code> : le record calcule
<code>RthJC_heat</code> = 29/(1 &minus; 0,45) &asymp; 53&nbsp;K/W, seule valeur utilisée par
les modèles (0,45 est le rendement optique au point de référence, <code>eta_ref</code>).</p>
<p>Le DS55 ne donne pas de RthJA : laisser la valeur par défaut 0 (« non fournie »). La
carte et le dissipateur se modélisent avec le package
<a href=\"modelica://LEDSystems.Thermal\">Thermal</a>.</p>

<h4>5. Onglet « Lumière » : courbes relatives et LER</h4>
<p><strong>Flux relatif en fonction du courant</strong> (Fig. 3 p. 10, normalisé à
60&nbsp;mA) : table <code>IvRel_If_table</code>, courant en A, valeur relative.
Interpolation logarithmique (<code>useLogLogInterpolation</code>), adaptée aux courbes
tracées en échelles log. Sous le premier point, le flux est pris proportionnel au courant ;
au-delà du dernier, la courbe est prolongée et un avertissement est émis.</p>
<p><strong>Flux relatif en fonction de la température</strong> (Fig. 4 p. 11) : choix
<code>lightTemperatureModel = Table</code> (le cas normal : la courbe du datasheet ;
<code>Linear</code> et le coefficient <code>TCIV</code> seulement si le datasheet ne donne
qu'un coefficient), puis table <code>IvRel_T_table</code>, température en °C. Attention, l'axe du DS55 est Tsp, mesurée en
continu à 60&nbsp;mA : la jonction était 5,4&nbsp;K plus chaude
(29&nbsp;K/W &times; 3,1&nbsp;V &times; 60&nbsp;mA). Les abscisses saisies sont donc décalées
de +5,4&nbsp;K. <code>T_minTable</code>, <code>T_maxTable</code> : bornes de la table
(au-delà, la valeur de l'extrémité est maintenue). <code>Tj_refLight</code> = 25&nbsp;°C :
température à laquelle <code>Phi_nom</code> a été mesuré.</p>
<p><strong>LER</strong> (lm/W) : elle convertit le flux en puissance optique. Les datasheets
ne la donnent pas ; on la calcule à partir du spectre du datasheet (script
<code>outils/calculs_reference.py</code> : 309&nbsp;lm/W pour le DS55). À défaut, 300&nbsp;lm/W
pour une LED blanche. Contrôle : le rendement P<sub>opt</sub>/P<sub>elec</sub> doit rester
nettement inférieur à 1 (0,45 ici à 60&nbsp;mA ; un avertissement apparaît au-delà de 1).</p>
<p><em>LED en mcd</em> : mêmes tables, avec la courbe d'intensité relative du datasheet.</p>

<h4>6. Contrôler le record</h4>
<p>Avant d'utiliser le record, vérifier qu'il reproduit le datasheet, avec un modèle de test
où la jonction est maintenue à la température des courbes :</p>
<pre>
model TestMaLED \"Contrôle du record : jonction à 25 °C, rampe de courant\"
  LEDSystems.Components.LED led(redeclare MesLED.MaLED data);
  LEDSystems.Thermal.FixedTemperature junction(T = 298.15);
  Modelica.Electrical.Analog.Sources.RampCurrent ramp(I = 0.08, duration = 1);
  Modelica.Electrical.Analog.Basic.Ground ground;
equation
  connect(ramp.n, led.p);
  connect(led.n, ground.p);
  connect(ramp.p, ground.p);
  connect(junction.port, led.heatPort);
  annotation(experiment(StopTime = 1, Interval = 0.001));
end TestMaLED;
</pre>
<p>Tracer <code>led.Vf</code> et <code>led.Phi_v</code> en fonction de <code>led.If</code>
(tracé paramétrique : maintenir Maj enfoncée et cliquer sur la variable en x, relâcher Maj et
cliquer sur la variable en y ; voir
<a href=\"modelica://LEDSystems.UsersGuide.Conventions\">Conventions</a>), et comparer aux
courbes du datasheet. Résultats avec le record DS55 :</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>If</th><th>10&nbsp;mA</th><th>33,5&nbsp;mA</th><th>60&nbsp;mA</th><th>79,3&nbsp;mA</th></tr>
<tr><td>Vf (modèle)</td><td>2,68&nbsp;V</td><td>2,90&nbsp;V</td><td>3,10&nbsp;V</td><td>3,23&nbsp;V</td></tr>
<tr><td>&Phi;v (modèle)</td><td>4,9&nbsp;lm</td><td>15,3&nbsp;lm</td><td>26,0&nbsp;lm</td><td>32,9&nbsp;lm</td></tr>
</table>
<p>Les points de calage sont reproduits exactement : cela prouve seulement que la saisie
est juste. La vraie vérification se fait sur <strong>d'autres</strong> points du datasheet,
qui n'ont pas servi au calage (par exemple la Tab. 3 du DS55), à comparer avec les
tolérances de mesure du fabricant (&plusmn;0,1&nbsp;V, &plusmn;7,5&nbsp;% chez Bridgelux).
C'est la démarche décrite dans
<a href=\"modelica://LEDSystems.UsersGuide.Validation\">Validation</a>.</p>

<h4>7. Utiliser le record</h4>
<p>Dans un composant : <code>redeclare MesLED.MaLED data</code> (ou le bouton à droite du
champ <code>data</code> dans la boîte de dialogue). Pour une matrice de LED dispersées, les
écarts <code>dVf</code> et <code>kIv</code> se tirent entre les classes min et max du
datasheet avec <a href=\"modelica://LEDSystems.Functions.dispersion\">Functions.dispersion</a> :
voir <a href=\"modelica://LEDSystems.Examples.SolarSpot.LiFePO4DirectDrive\">SolarSpot.LiFePO4DirectDrive</a>,
qui utilise ce record.</p>

<h4>8. Se faire aider par une IA</h4>
<p>Un assistant conversationnel qui lit les PDF peut écrire un premier jet du record. Lui
fournir le datasheet (PDF) et la définition de <code>LEDData</code> (fichier
<code>LEDSystems/Data/LEDData.mo</code>, à joindre ou à coller), puis lui donner le prompt
ci-dessous, en complétant la première ligne :</p>
<pre>
LED à modéliser : [référence complète, teinte, classe de flux et de tension].

Tu es ingénieur en optoélectronique et tu connais Modelica. À partir du datasheet joint
(PDF) et de la définition du record LEDData de la bibliothèque LEDSystems (jointe),
écris un record Modelica pour cette LED, en suivant ces règles :

1. Forme : « within MesLED; record NomLED ... extends LEDSystems.Data.LEDData(...);
   end NomLED; ». Renseigne tous les paramètres que le datasheet permet de fixer.
2. Chaque valeur porte un commentaire donnant sa source (page, tableau ou figure) et ses
   conditions de mesure (courant, pulsé ou continu, température de jonction, de point de
   soudure ou ambiante). Une valeur lue sur une courbe est signalée comme telle, avec la
   précision de lecture estimée.
3. Unités : SI dans le texte (20 mA s'écrit 20e-3, 25 °C s'écrit 298.15) ; courants des
   tables en A ; colonne de température des tables en °C ; tables relatives égales à 1
   au point de référence. Les températures de référence sont des températures de jonction.
4. Calage I-V : 3 points de la courbe If = f(Vf), bien répartis (bas, milieu et haut de
   la plage), à une même température de jonction, reportée dans Tj_refIV.
5. Pour chaque choix de modèle prévu par LEDData (grandeur photométrique de référence,
   variation de Vf avec la température, effet de la température sur la lumière, calage
   sur 3 points ou paramètres de Shockley fournis), indique l'option retenue et pourquoi.
6. Traite explicitement : mesures pulsées ou continues ; passage de la température de
   point de soudure à la température de jonction ; convention de la résistance thermique
   (rapportée à la puissance électrique ou à la chaleur : RthJC_onElectricalPower) ;
   RthJA absente (laisser 0) ; efficacité lumineuse du rayonnement LER, calculée à partir
   du spectre du datasheet pondéré par V(lambda), ou à défaut estimée (le dire).
7. N'invente aucune valeur : une donnée absente garde la valeur par défaut de LEDData,
   avec le commentaire « absente du datasheet ».

Après le record, donne :
A. BIZARRERIES : incohérences entre tableaux et figures ou entre pages, unités ou
   conditions de mesure ambiguës, courbes illisibles ou trop courtes, valeurs inhabituelles,
   données manquantes, plages où le modèle extrapolera. Pour chacune : où, quoi,
   conséquence pour le modèle, choix fait.
B. POINTS DE CONTRÔLE : 8 à 15 points du datasheet NON utilisés pour le calage
   (grandeur, courant, température de jonction, valeur attendue, source, tolérance de
   mesure du fabricant).
C. ORDRES DE GRANDEUR attendus : n, Is, Rs du calage, et rendement optique
   P_opt/P_elec au point de référence, pour juger si le record est plausible.
</pre>
<p>Ensuite, <strong>tout contrôler</strong> : une IA peut mal lire une courbe, confondre deux
teintes ou deux classes, ou « compléter » une donnée absente.</p>
<ul>
<li>reprendre chaque valeur du record sur le datasheet, à l'aide des commentaires de
    source (étapes 2 à 5) ;</li>
<li>vérifier soi-même chaque bizarrerie signalée, et chercher celles qu'elle n'a pas vues ;</li>
<li>simuler le modèle de test de l'étape 6 et comparer aux points de contrôle (liste B),
    eux aussi vérifiés sur le datasheet. Un écart hors tolérance se comprend et se
    documente : on ne modifie jamais une valeur de référence pour le faire disparaître.</li>
</ul>
<p>Les incohérences relevées sur les datasheets de cette bibliothèque (DS242 notamment) sont
décrites dans <a href=\"modelica://LEDSystems.UsersGuide.Validation\">Validation</a> : c'est
le type de constat attendu dans la liste A.</p>
</html>"));
end Tutorial;
