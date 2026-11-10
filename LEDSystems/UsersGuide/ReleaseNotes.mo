within LEDSystems.UsersGuide;
class ReleaseNotes "Notes de version"
  extends Modelica.Icons.ReleaseNotes;

  annotation (Documentation(info="<html>
<h4>Version 1.0.0 (2026-11-10)</h4>
<p>Première version publiée. Les calculs sont <strong>inchangés</strong> : les trajectoires
de tous les exemples et les résultats de validation sont identiques à ceux de la version
0.9.0.</p>
<ul>
<li>Guide d'utilisation (<code>UsersGuide</code>) : vue d'ensemble du modèle et choix d'un
    composant, tutoriel (écrire le record d'une LED à partir de son datasheet, sur le DS55,
    avec un prompt pour faire préparer un premier jet par une IA, puis le contrôler),
    validation (méthode, résultats, limites), conventions (unités, tracé paramétrique dans
    OMEdit, signes, résistances thermiques), références, licence, contact.</li>
<li>Documentation de toutes les classes ; schéma du modèle de LED
    (<code>Resources/Images/LEDModel.svg</code>).</li>
<li>Exemples <code>Basics</code> : documentation « à observer » avec les valeurs attendues ;
    <code>LEDSimplePhoto</code> refait (deux LED en série, jonctions à 25 et 85 °C, rampe de
    0 à 20 mA) ; valeurs saisies directement sur les composants (plus de paramètres de
    premier niveau, que le dialogue d'OMEdit n'affiche pas).</li>
<li>Images : les deux photos de <code>LEDHeatSinkInCase</code>, de provenance inconnue, sont
    remplacées par des schémas SVG dessinés pour le projet (CC BY 4.0).</li>
<li><code>LEDData</code> : les choix de modèle sont des listes déroulantes (énumérations du
    package <code>Types</code>) au lieu de cases à cocher, et la description de chaque
    paramètre dépendant indique quand il sert. Dans le sous-dialogue <code>data</code>
    d'OMEdit 1.26, le grisage des paramètres non utilisés ne fonctionne pas.</li>
<li><code>LEDData.RthJA</code> vaut 0 par défaut (« non fournie ») au lieu de 360 K/W (valeur
    de la LED Vishay, héritée sans message par les autres records) ; nouveau
    <code>RthJA_heat</code>, avec la même convention que <code>RthJC_heat</code>.
    <code>LEDWithPlate</code> utilise <code>RthJA_heat &minus; RthJC_heat</code> et s'arrête
    avec un message explicite si <code>useDatasheetRth</code> est cochée sans RthJA, ou si
    la résistance obtenue n'est pas positive.</li>
<li>Dépôt : README en français et en anglais, licences (BSD-3-Clause pour le code,
    CC BY 4.0 pour la documentation et les images), mode d'emploi des scripts de
    <code>outils/</code>.</li>
</ul>
<p><strong>Migration</strong> depuis la version 0.9.0 :</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>0.9.0</th><th>1.0.0</th></tr>
<tr><td><code>Examples.Basics.LEDSimpleThermal_FirstOrder</code></td>
    <td><code>Examples.Basics.LEDJunctionFirstOrder</code></td></tr>
<tr><td><code>Examples.Basics.LEDSimpleThermal_ExternalHeatSink</code></td>
    <td><code>Examples.Basics.LEDHeatSinkInCase</code></td></tr>
<tr><td>paramètres de premier niveau des exemples (<code>Iset</code>, <code>Tamb</code>,
    <code>Rth</code>, <code>dVf</code>)</td><td>supprimés : valeurs saisies sur les composants</td></tr>
<tr><td>instance <code>led_3p3V_20mA</code> des exemples</td><td><code>led</code></td></tr>
<tr><td><code>shockleyParamsProvided = false</code> / <code>true</code></td>
    <td><code>ivCurveModel = ThreePointFit</code> / <code>ShockleyParameters</code></td></tr>
<tr><td><code>useLinearVfTemp = true</code> / <code>false</code></td>
    <td><code>vfTemperatureModel = Linear</code> / <code>Table</code></td></tr>
<tr><td><code>useIvTempTable = true</code> / <code>false</code></td>
    <td><code>lightTemperatureModel = Table</code> / <code>Linear</code></td></tr>
<tr><td><code>RthJA</code> = 360 K/W par défaut</td>
    <td>0 (« non fournie ») : un record personnel qui comptait sur l'ancien défaut doit
    renseigner <code>RthJA</code></td></tr>
</table>
<p>Les valeurs des énumérations s'écrivent en nom complet dans un record, par exemple
<code>vfTemperatureModel = LEDSystems.Types.VfTemperatureModel.Table</code>.</p>

<h4>Version 0.9.0 (2026-11-09)</h4>
<p>Trois LED réelles, chacune calée et validée sur son datasheet, avec un exemple par cas
d'usage. Les résultats de la LED Vishay sont <strong>inchangés</strong> (calcul de
<code>PartialLED</code> identique à la version 0.8.0).</p>
<ul>
<li>Nouveaux records de données (chaque valeur commentée avec sa source : page, figure ou
    tableau, conditions de mesure) :
  <ul>
  <li><code>Data.Bridgelux_BXEN_57E_11L</code> : SMD 2835 0,2 W, 5700 K (DS55 Rev. B) ;</li>
  <li><code>Data.Bridgelux_BXEN_30G_11M</code> : SMD 2835 0,5 W, 3000 K, IRC 90 (DS242 Rev. F) ;</li>
  <li><code>Data.Lumileds_LUXEON_FX2L_Plus_CW</code> : LED de puissance blanc froid
      (DS394), références à 85 °C, variation de Vf avec la température par table.</li>
  </ul></li>
<li><code>LEDData</code> : nouveau paramètre <code>RthJC_onElectricalPower</code>. Certains
    fabricants (Bridgelux) calculent la résistance thermique sur la puissance électrique
    totale, alors que le modèle fait passer la seule chaleur Qth = P_elec &minus; P_opt.
    Le record en déduit <code>eta_ref</code> (rendement au point de référence) et
    <code>RthJC_heat</code> = RthJC/(1 &minus; eta_ref), seule résistance utilisée par
    <code>LEDMatrix</code>, <code>LEDWithPlate</code> et les exemples. Sans effet si la case
    n'est pas cochée (valeur par défaut).</li>
<li>Nouvelle fonction <code>Functions.dispersion</code> : valeurs tirées selon une loi
    normale tronquée entre le minimum et le maximum du datasheet (&sigma; = (max &minus; min)/6),
    reproductibles (même graine, mêmes valeurs), pour la dispersion de fabrication d'une matrice.</li>
<li>Nouveaux exemples, un par cas d'usage :
  <ul>
  <li><code>Examples.SolarSpot.LiFePO4DirectDrive</code> : 66 LED en parallèle directement
      sur un élément LiFePO4 (3,0 à 3,4 V), à 0 °C ;</li>
  <li><code>Examples.DomesticLamp.LEDBulbWarmUp</code> : 18 LED en série sur un radiateur,
      courant constant de 120 mA ; le flux baisse de 6 % pendant la mise en température ;</li>
  <li><code>Examples.Automotive.HeadlampLowHighBeam</code> : LED de phare sur plaque, air à
      85 °C, passage du feu de croisement (1000 mA) au feu de route (1500 mA), marge sur
      Tj max.</li>
  </ul></li>
<li><code>Examples.Basics.LEDSimpleElec</code> : la rampe de courant dure 1 s (au lieu de
    10 s, pour une simulation de 1,2 s) : la LED atteint enfin 20 mA.</li>
</ul>
<p><strong>Validation</strong> (tolérances de mesure des datasheets) : DS55 29/29 points de
validation, LUXEON 33/33, DS242 30/32. Les 2 écarts du DS242 (flux à 85 °C, 42 et 120 mA :
+9,1 % et +8,3 %) viennent d'une incohérence du datasheet : sa Tab. 3 donne un rapport
&Phi;(85 °C)/&Phi;(25 °C) d'environ 0,83, contre 0,90 dans sa Tab. 2 et sa Fig. 4, que suit le
modèle.</p>
<p><strong>Migration</strong> : les exemples de la racine de <code>Examples</code> sont
déplacés dans <code>Examples.Basics</code>.</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>0.8.0</th><th>0.9.0</th></tr>
<tr><td><code>Examples.LEDSimpleElec</code></td><td><code>Examples.Basics.LEDSimpleElec</code></td></tr>
<tr><td><code>Examples.LEDSimplePhoto</code></td><td><code>Examples.Basics.LEDSimplePhoto</code></td></tr>
<tr><td><code>Examples.LEDSimpleThermal_FirstOrder</code></td><td><code>Examples.Basics.LEDSimpleThermal_FirstOrder</code></td></tr>
<tr><td><code>Examples.LEDSimpleThermal_ExternalHeatSink</code></td><td><code>Examples.Basics.LEDSimpleThermal_ExternalHeatSink</code></td></tr>
</table>

<h4>Version 0.8.0 (2026-11-08)</h4>
<p>Ensembles de LED. Les résultats d'une LED seule sont <strong>inchangés</strong>
(identiques au bit près à ceux de la version 0.7.0).</p>
<ul>
<li>Nouveau <code>Components.LEDArray</code> : réseau de Ns&nbsp;&times;&nbsp;Np LED
    <strong>identiques</strong> (Np branches en parallèle de Ns LED en série), calculé comme
    une seule LED mise à l'échelle ; même température de jonction pour toutes les LED.
    Rapide, pour une lampe de nombreuses LED identiques sur un même support.</li>
<li>Nouveau <code>Components.LEDMatrix</code> : matrice de LED <strong>individuelles</strong>,
    avec résistance de ballast par branche et dispersion de fabrication par LED
    (<code>dVf</code> : écart de tension directe ; <code>kIv</code> : facteur d'intensité).
    Son <code>heatPort</code> représente la <strong>carte commune</strong> : chaque LED y est
    reliée par sa résistance RthJC et a sa propre température de jonction. Pour étudier
    le partage du courant entre branches en parallèle.</li>
<li><code>LED</code> reçoit les paramètres <code>dVf</code> et <code>kIv</code> (onglet
    « Avancé », groupe « Dispersion »), sans effet avec leurs valeurs par défaut (0 et 1).</li>
<li>Nouveaux exemples : <code>Examples.Basics.LEDArrayEquivalence</code> (un
    <code>LEDArray</code> 3&nbsp;&times;&nbsp;2 donne les mêmes résultats que 6 LED câblées
    une par une) et <code>Examples.Basics.LEDMatrixCurrentSharing</code> (4 LED en parallèle
    sous tension imposée : un écart de &plusmn;0,2&nbsp;V sur Vf donne un rapport 3,2 entre
    les courants, ramené à 2,1 par un ballast de 10&nbsp;&Omega;).</li>
<li>Garde-fou du rendement : tolérance de 1&nbsp;nW, pour éviter une fausse alerte à
    courant nul.</li>
</ul>
<p>Pour les développeurs : le calcul de <code>LED</code> est désormais dans
<code>Components.BaseClasses.PartialLED</code>, dont héritent <code>LED</code> et
<code>LEDArray</code>. Aucun changement pour les modèles qui utilisent <code>LED</code>.</p>

<h4>Version 0.7.0 (2026-11-08)</h4>
<p>Correction des calculs électriques et photométriques. <strong>Les résultats changent</strong>
par rapport à la version 0.6.0 : le modèle reproduit désormais les courbes du datasheet
(test sur le Vishay VLMW41S1T1 : 8 points sur 8 dans la tolérance, contre 3 auparavant).</p>
<ul>
<li><strong>Calage I-V exact</strong> : <code>fitShockley3Points</code> résout exactement le
    système à 3 points ; le modèle repasse par les 3 points de la courbe If = f(Vf)
    (Vishay, 20&nbsp;mA : 3,30&nbsp;V au lieu de 3,48&nbsp;V). Des points incohérents
    (résistance série négative) arrêtent la simulation avec un message.</li>
<li><strong>Photométrie par les courbes du datasheet</strong> : intensité relative en
    fonction du courant (interpolation log-log) et de la température (table), normalisée
    au point de référence. Il n'y a plus de seuil d'extinction : sous le premier point de
    la courbe, l'intensité est proportionnelle au courant (rendement constant).</li>
<li>La correction de température de l'intensité utilise la température de référence
    photométrique <code>Tj_refLight</code> (et non plus celle du calage I-V).</li>
<li>Référence photométrique donnée en intensité (mcd) <em>ou</em> en flux (lm) :
    paramètre <code>photometricInput</code> (nouveau type <code>Types.PhotometricInput</code>).</li>
<li>Option <code>useLinearVfTemp = false</code> : variation de Vf avec la température par
    la table <code>Vf_T_table</code>.</li>
<li>Avertissements : rendement supérieur à 100&nbsp;% (P_opt &gt; P_elec, donnée
    incohérente) ; courant au-delà du dernier point de la courbe Iv = f(If).</li>
</ul>
<p><strong>Migration d'un record de données écrit en 0.6.0</strong></p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>0.6.0</th><th>0.7.0</th></tr>
<tr><td><code>If_emitMin</code> (seuil d'extinction)</td><td>supprimé (émission dès les faibles courants)</td></tr>
<tr><td><code>alpha_I</code> (exposant de Iv = f(If))</td><td>supprimé : la courbe <code>IvRel_If_table</code> est utilisée</td></tr>
<tr><td><code>If_refLight</code></td><td>supprimé : la courbe est normalisée au courant <code>If_nom</code></td></tr>
<tr><td><code>If_minTable</code>, <code>If_maxTable</code></td><td>supprimés : les bornes sont celles de <code>IvRel_If_table</code></td></tr>
<tr><td><code>TCIV</code> (toujours utilisé)</td><td>utilisé seulement si <code>useIvTempTable = false</code> ; par défaut, <code>IvRel_T_table</code></td></tr>
<tr><td>&mdash;</td><td>nouveaux : <code>photometricInput</code>, <code>Phi_nom</code>, <code>useIvTempTable</code></td></tr>
</table>

<h4>Version 0.6.0 (2026-11-08)</h4>
<p>Refonte du composant LED et de ses données. <strong>Les calculs électriques et
photométriques sont inchangés</strong> : à température de jonction égale, les résultats
sont identiques à ceux de la version 0.5.0.</p>
<ul>
<li>Le <code>heatPort</code> de <code>LED</code> est désormais <strong>toujours présent</strong> et
    représente la jonction : il doit être relié à un environnement thermique. Les modes
    thermiques internes (Constant, Physical, FirstOrder, Table) et le paramètre
    <code>useInternalHeatsink</code> sont supprimés.</li>
<li>Nouveau package <code>Thermal</code> : <code>FixedTemperature</code>,
    <code>TemperatureTable</code>, <code>TemperatureFirstOrder</code> (rejeu) et
    <code>Plate</code> (plaque dissipatrice, prédiction de l'échauffement).</li>
<li>Nouveau modèle prêt à l'emploi <code>Components.LEDWithPlate</code> (LED + RthJC + plaque).</li>
<li>Identifiants en anglais, unités sur toutes les grandeurs (températures en °C à
    l'affichage, courants en mA, intensité en mcd), onglets « Thermique »,
    « Lumière », « Avancé ».</li>
<li>Exemples : <code>LEDSimpleThermal_ExternalHeatSink</code> réparé (valeurs plausibles
    documentées) ; <code>LEDSimpleElec_1</code> à <code>_4</code> (identiques) regroupés en
    <code>LEDSimpleElec</code> ; nouveaux exemples dans <code>Examples.Basics</code>.</li>
<li>Initialisation explicite partout : plus aucun avertissement d'initialisation.</li>
</ul>
<p><strong>Migration d'un modèle écrit en 0.5.0</strong></p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>0.5.0</th><th>0.6.0</th></tr>
<tr><td><code>Interfaces.LuxFlowPort</code>, instance <code>luxPort</code></td><td><code>Interfaces.LightPort</code>, instance <code>lightPort</code></td></tr>
<tr><td><code>Data.Data_3p3V_20mA_Cool_White</code></td><td><code>Data.Vishay_VLMW41S1T1</code></td></tr>
<tr><td><code>LED(useInternalHeatsink=true)</code> + <code>thermalInputMode</code></td><td><code>LED</code> + un composant de <code>Thermal</code> relié au <code>heatPort</code></td></tr>
<tr><td>mode Constant, <code>Tinternal_const_degC</code></td><td><code>Thermal.FixedTemperature</code>, <code>T</code></td></tr>
<tr><td>mode FirstOrder, <code>Tinternal_start_degC</code>, <code>Tinternal_max_degC</code>, <code>tau63_internal</code></td><td><code>Thermal.TemperatureFirstOrder</code>, <code>T_start</code>, <code>T_end</code>, <code>tau63</code></td></tr>
<tr><td>mode Table, <code>Tinternal_table</code>, <code>tauTableFilter</code></td><td><code>Thermal.TemperatureTable</code>, <code>table</code>, <code>tauFilter</code></td></tr>
<tr><td>mode Physical, <code>RthJA</code>, <code>hsArea_mm2</code>, <code>hsThickness_mm</code>, <code>hsRho</code>, <code>hsCp</code>, <code>Tamb</code></td><td><code>Thermal.Plate</code>, <code>R</code>, <code>area</code>, <code>thickness</code>, <code>rho</code>, <code>cp</code>, <code>T_ambient</code></td></tr>
<tr><td><code>LED(useInternalHeatsink=false)</code> : RthJC inclus dans la LED</td><td>placer un <code>ThermalResistor(R=data.RthJC)</code> entre le <code>heatPort</code> et le dissipateur</td></tr>
<tr><td><code>Tj_degC</code>, <code>Tjonc</code></td><td><code>Tj</code> (en K, affichée en °C)</td></tr>
<tr><td><code>VF_typ</code>, <code>IF_typ</code>, <code>IF_nom</code></td><td><code>Vf_typ</code>, <code>If_typ</code>, <code>If_nom</code></td></tr>
<tr><td><code>IV_nom_mcd</code> (en mcd, ex. 275)</td><td><code>Iv_nom</code> (en cd, ex. 0.275)</td></tr>
<tr><td><code>I_emit_min</code></td><td><code>If_emitMin</code></td></tr>
<tr><td><code>eta_lm_per_W</code></td><td><code>LER</code></td></tr>
<tr><td><code>alphaVf_T</code>, <code>Tref_Vf</code>, <code>Tref_IV</code></td><td><code>TCVf</code>, <code>Tj_refVf</code>, <code>Tj_refIV</code></td></tr>
<tr><td><code>Iref_light</code>, <code>Tref_light</code></td><td><code>If_refLight</code>, <code>Tj_refLight</code></td></tr>
<tr><td><code>YI_table</code>, <code>YT_table</code></td><td><code>IvRel_If_table</code>, <code>IvRel_T_table</code></td></tr>
<tr><td><code>I_min_table</code>, <code>I_max_table</code></td><td><code>If_minTable</code>, <code>If_maxTable</code></td></tr>
<tr><td><code>T_min_table_degC</code>, <code>T_max_table_degC</code> (°C)</td><td><code>T_minTable</code>, <code>T_maxTable</code> (K, affichées en °C)</td></tr>
<tr><td><code>Ids</code>, <code>N</code>, <code>Rs</code>, <code>EG</code>, <code>TNOM</code>, <code>XTI</code>, <code>Maxexp</code>, <code>Rd_dyn</code>, <code>TCVF</code>, <code>I_min_safe</code>, <code>V_max_exp</code></td><td>supprimés (inutilisés)</td></tr>
<tr><td><code>Types.ThermalInputMode</code></td><td>supprimé</td></tr>
</table>
<p>Limites connues : le modèle s'écarte toujours du datasheet Vishay VLMW41S1T1 sur la
tension à 20&nbsp;mA et sur l'intensité lumineuse (3 points sur 8 dans la tolérance) ;
correction prévue en 0.7.0.</p>

<h4>Version 0.5.0 (2026-11-08)</h4>
<p>Restructuration de la bibliothèque, <strong>sans modification des calculs</strong> :
les résultats de simulation sont identiques à ceux de la version 0.4.0.</p>
<ul>
<li>Bibliothèque renommée de <code>Led</code> en <code>LEDSystems</code>.
    Dans un modèle existant, remplacer <code>Led.</code> par <code>LEDSystems.</code>.</li>
<li>Dépendance passée à la Modelica Standard Library 4.1.0.</li>
<li>Nouveau package <code>Types</code> : l'énumération <code>ThermalInputMode</code>
    est déplacée du record <code>LEDData</code> vers <code>LEDSystems.Types.ThermalInputMode</code>.
    Dans un modèle existant, remplacer <code>Led.Data.LEDData.ThermalInputMode</code>
    par <code>LEDSystems.Types.ThermalInputMode</code>.</li>
<li>Icônes conformes à la MSL : <code>Functions</code> et <code>Data</code> utilisent les icônes
    de package adaptées ; les exemples étendent <code>Modelica.Icons.Example</code>,
    les records <code>Modelica.Icons.Record</code>.</li>
<li>Images déplacées dans <code>Resources/Images</code> et référencées par
    <code>modelica://LEDSystems/Resources/Images/...</code> au lieu d'être incorporées en base64.</li>
<li>Supprimés : le package vide <code>LedMatrix</code>, l'ébauche
    <code>Components.MatrixLED</code> et des fichiers résiduels.</li>
<li>Annotation <code>version</code> ajoutée au package racine.</li>
</ul>
<p>Limites connues (inchangées depuis la version 0.4.0) :</p>
<ul>
<li>l'exemple <code>LEDSimpleThermal_ExternalHeatSink</code> ne compile pas
    (paramètres des composants thermiques sans valeur) ;</li>
<li>le modèle s'écarte du datasheet Vishay VLMW41S1T1 sur la tension à 20&nbsp;mA
    et sur l'intensité lumineuse (3 points sur 8 dans la tolérance) ;</li>
<li>dans OMEdit, les paramètres thermiques du record de données ne se grisent pas
    selon le mode choisi.</li>
</ul>

<h4>Version 0.4.0</h4>
<p>Version de départ, non fonctionnelle.</p>
</html>"));
end ReleaseNotes;
