# Projet : bibliothèque Modelica de LED

Bibliothèque OpenModelica pour simuler des LED (électrique, photométrique,
thermique), seules ou en matrice. Double usage :

- **pédagogique** : enseignement STI2D (Sciences de l'ingénieur, 1ère et terminale),
  les élèves utilisent les composants dans OMEdit ;
- **publication** sur GitHub, sous licence libre.

L'utilisateur est enseignant en Sciences de l'ingénieur : inutile de vulgariser,
mais toujours expliquer les choix techniques. **Toutes les réponses en français.**

## Décisions du projet

Tant qu'une décision est marquée « À DÉCIDER », ne fais aucun travail qui en
dépend : pose la question.

| Sujet | Décision |
|---|---|
| Nom de la bibliothèque | `LEDSystems` (ancien nom : `Led`). Renommage fait à l'étape 1.1 : `git mv` pour conserver l'historique, remplacement de toutes les références `Led.` par `LEDSystems.`, valeur par défaut de `--lib` passée à `LEDSystems` dans `verifier.py` et `tester_datasheet.py`, commandes de ce fichier mises à jour |
| Langue des identifiants (classes, variables, paramètres) | Anglais. Traduction à l'étape 2, en même temps que la refonte du composant LED et du record de données (pour ne pas retoucher deux fois les mêmes fichiers) |
| Langue de la documentation (`Documentation(info=...)`, descriptions des paramètres, commentaires) | Français |
| Convention de nommage | Style MSL : classes en `UpperCamelCase`, paramètres et variables en `lowerCamelCase`. Symboles physiques des datasheets conservés tels quels (`Vf`, `If`, `Iv`, `Phi_v`, `Tj`, `Is`, `n`, `Rs`, `RthJA`, `RthJC`, `TCIV`), avec suffixe après un tiret bas pour les variantes (`Vf_typ`, `If_nom`, `Tj_refIV`). Tables suffixées `_table` |
| Licence | MPL-2.0 pour le code, CC BY-SA 4.0 pour la documentation et les images, depuis la 1.1.0 (décision du 2026-11-11 : les modifications de la bibliothèque distribuées doivent rester libres, sans contraindre les modèles qui l'utilisent). Versions ≤ 1.0.0 : BSD-3-Clause et CC BY 4.0. Avis MPL (Exhibit A) dans les scripts Python, pas dans les `.mo` (avis placé dans `LICENSE`, le package racine et `UsersGuide.License`) |
| Version de la bibliothèque | 0.4.0 au départ (non fonctionnelle). Numérotation sémantique : chaque étape validée du plan monte la version mineure (étape 1 → 0.5.0 … étape 5 → 0.9.0), l'étape 6 (publication) donne 1.0.0 |
| Version de la MSL | 4.1.0 (seule version installée, effectivement chargée par OpenModelica). À l'étape 1 : mettre à jour l'annotation `uses` et la valeur par défaut de `--msl` dans les deux scripts |
| Version d'OpenModelica | 1.26.1 |
| Titulaire des droits et contact | Stéphane Gounelle (gounelles@gmail.com) : ligne de copyright (MPL-2.0), attribution CC BY-SA 4.0, `UsersGuide.Contact`, README |
| Images de `Resources/Images/` | Provenance de `LEDCase.jpg` et `LEDHeatsink.jpg` inconnue : remplacées par des schémas SVG dessinés pour le projet (CC BY-SA 4.0 depuis la 1.1.0, Stéphane Gounelle) |
| Publication de `CLAUDE.md` | Publié. Le README et le `UsersGuide` précisent l'origine : bibliothèque écrite à la main par l'auteur (version 0.4.0, non fonctionnelle), restructurée, corrigée, validée et documentée avec Claude Code (étapes 1 à 6) |
| Dépôt GitHub | https://github.com/gounelles/LEDSystems (nom = nom de la bibliothèque) ; branche `main` (renommage local de `master` à l'étape 6.8, sans réécriture d'historique) |
| Historique publié | Dépôt neuf : un commit initial propre (sans les anciennes images JPEG de provenance inconnue, présentes dans l'historique y compris en base64 dans le commit initial) ; l'historique complet reste dans le dépôt local actuel |
| Langue du README | Français et anglais, traduction complète (deux versions du même contenu) |

## Commandes

À lancer depuis la racine du projet :

```bash
python3 outils/verifier.py                    # vérifie, compile et simule tous les exemples
python3 outils/verifier.py --sans-simulation  # vérification seule, rapide
python3 outils/verifier.py --modele LEDSystems.Examples.Basics.LEDSimplePhoto
python3 outils/tester_datasheet.py            # compare le modèle au datasheet Vishay
python3 outils/tester_cas_usage.py            # LED des cas d'usage : calage et validation
python3 outils/calculs_reference.py           # calages exacts, V(λ), LER (hors Modelica)
```

Rapport détaillé : `build/rapport_verification.txt`.
Fichiers générés par omc : `build/<modèle>/` (dont `sortie_omc.txt`).
Valeurs par défaut des scripts : `--lib LEDSystems`, `--msl 4.1.0`.

## Règles de travail

1. **Une étape du plan à la fois.** Avant de modifier des fichiers, présente ton
   plan pour la sous-étape et attends mon accord.
2. **Toujours vérifier.** Après chaque modification, lance `verifier.py`.
   Une sous-étape n'est terminée que si tous les exemples passent, sans nouvel
   avertissement non expliqué.
3. **Ne jamais affaiblir les tests.** Dans `outils/tester_datasheet.py`, les
   valeurs de `REFERENCES` et les tolérances viennent du datasheet : ne jamais
   les modifier pour faire passer un test. Si une référence semble fausse,
   signale-le et demande. Seule la partie « 2) BANC DE TEST » peut être adaptée
   quand l'interface du composant LED change.
4. **Git.** Un commit par sous-étape validée, message en français préfixé par
   l'étape (ex. `[Étape 1] Déplacement de ThermalInputMode dans Types`).
   Ne jamais faire `git push`, `git reset --hard` ni réécrire l'historique.
5. **Versions.** À la fin d'une étape validée (et seulement avec mon accord) :
   mettre à jour `version` et `versionDate` dans l'annotation du `package.mo`
   racine, noter les changements dans les notes de version (`UsersGuide`,
   dès qu'il existe), puis poser le tag Git correspondant (ex. `v0.5.0`).
   Ne jamais annoncer une version 1.0.0 avant la fin de l'étape 6.
6. **Suppressions.** Ne supprime aucun fichier sans m'en donner la liste et
   obtenir mon accord (sauf le contenu de `build/`).
7. **Annotations graphiques.** Ne modifie `Placement`, `Line`, `Icon`, `Diagram`
   que si c'est nécessaire, et signale-moi quand une vérification visuelle dans
   OMEdit est utile.
8. **Commentaires pédagogiques.** Conserve les commentaires explicatifs des
   records de données (ils servent aux élèves pour paramétrer une LED depuis
   un datasheet). Tu peux les reformuler, pas les supprimer.
9. **Dépendances.** Aucune bibliothèque Modelica autre que la MSL. Scripts Python :
   bibliothèque standard uniquement.
10. **Encodage** UTF-8 pour tous les fichiers.

## Conventions Modelica à respecter

- Arborescence en dossiers : un fichier par classe, `package.mo` et
  `package.order` dans chaque dossier, nom du dossier = nom du package.
- Chaque package étend l'icône adaptée de `Modelica.Icons`
  (`Package`, `ExamplesPackage`, `FunctionsPackage`, `InterfacesPackage`,
  `TypesPackage`, `Information`…). Un package n'étend jamais une fonction.
- Un composant conditionnel (`... if condition`) n'apparaît **que** dans des
  `connect`, jamais dans des équations.
- Pas d'accès à une classe définie dans un record ou un modèle depuis
  l'extérieur : les types (énumérations…) vont dans un package `Types`.
- Unités partout : `Modelica.Units.SI`. Températures en `SI.Temperature` avec
  `displayUnit="degC"` (saisie et affichage en °C dans OMEdit, calcul en K, aucune
  conversion `+273.15` dans les équations). Les tables issues des datasheets restent
  en °C, et leur description le précise. `displayUnit` aussi pour mm, mm², mcd…
  Courants affichés en mA (`displayUnit="mA"`), sauf le courant de saturation de
  Shockley (de l'ordre de 1e-18 A), laissé en A.
  Pas de `Real` sans unité pour une grandeur physique.
- Ce qui ne varie pas pendant la simulation est un `parameter` (éventuellement
  `final`), pas une variable.
- Tout état (`der(x)`) a une initialisation explicite (`initial equation` ou
  `fixed=true` justifié).
- Chaque exemple étend `Modelica.Icons.Example`, a une annotation `experiment`
  cohérente avec ce qu'il montre, et une documentation qui dit quoi observer.
- Les images vont dans `Resources/Images/` et sont référencées par
  `modelica://LEDSystems/Resources/Images/...` (pas d'image en base64).

## État au départ (analyse de la version 0.4.0)

### Résultats constatés des outils
- `verifier.py` : **6/7 exemples OK**. Échec : `LEDSimpleThermal_ExternalHeatSink`
  à la compilation (`RConvHeatsink.R` sans valeur). Réparation prévue à l'étape 2.
- `tester_datasheet.py` : **3/8 points OK** (échecs : Vf à 20 mA, Iv à 1, 3,
  30 et 100 mA).

### Conformité
- `heatPort` est conditionnel mais utilisé dans des équations de `LED.mo`.
- `Functions/package.mo` étend `Modelica.Icons.Function` (une fonction).
- L'énumération `ThermalInputMode` est déclarée dans le record `LEDData` et
  référencée depuis l'extérieur.
- `Tj` n'a pas d'initialisation explicite (modes FirstOrder et Physical).
- Grandeurs sans unité (`*_degC`, `*_mm`, `*_mm2`, `IV_nom_mcd`).
- Grandeurs constantes déclarées comme variables (`hsArea_m2`, `hsMass`,
  `Cth_internal`, `tau_hs`…).
- `Tamb` grisé dans la boîte de dialogue précisément quand il sert
  (`enable=not useInternalHeatsink` : condition inversée).
- Dans l'onglet *Thermal* du record `data`, les champs propres à chaque mode
  (`Tinternal_const_degC`, `Tinternal_start_degC`, `Tinternal_table`…) ne se
  grisent pas selon `thermalInputMode` dans OMEdit, alors qu'ils portent des
  conditions `enable=`. Constaté en version 0.4.0 / 1.1 comme après la
  sous-étape 1.2 : défaut d'origine, à traiter à l'étape 2 (refonte du record
  et des modes thermiques).
- 22 paramètres de `LEDData` inutilisés (dont `YI_table`, `YT_table`,
  `Vf_T_table`, `useLinearVfTemp`, `Rd_dyn`, `TCVF`, paramètres SPICE), ainsi
  que `Rth_internal` dans `LED`.
- Fichiers résiduels : `*.old`, `*.v0`, `arborescence_dossier_LedMatrix.txt`.

### Calculs
- **Calage I–V** (`fitShockley3Points`) : `n` est calculé en négligeant `Rs`,
  le modèle ne repasse pas par le point 2 (3,48 V au lieu de 3,30 V à 20 mA).
  Correction : V = A·ln(I) + B + Rs·I est linéaire en (A, B, Rs) → système 3×3
  exact (attendu : n ≈ 3,95 ; Is ≈ 1,9e-15 A ; Rs ≈ 13 Ω).
- **Photométrie** : au point de référence, Iv = 0,9 × Iv_nom (I_emit_min non
  retranché au dénominateur) ; α = 1 donne +32 % à 30 mA et +52 % à 100 mA ;
  extinction sous I_emit_min alors qu'une LED émet dès quelques µA ; correction
  thermique sur `Tref_IV` au lieu de `Tref_light`. Les tables `YI_table` et
  `YT_table` contiennent les bonnes courbes mais ne sont pas utilisées.
- Ajouter un garde-fou `P_opt <= P_elec`.
- **Thermique** : le mode Physical combine un RthJA de datasheet (carte
  standard) avec la capacité d'une plaque alu ; les modes Constant, FirstOrder
  et Table imposent Tj sans tenir compte de la puissance (rejeu de mesures,
  pas prédiction).

### Exemples
- `LEDSimpleElec_1` à `_4` identiques ; rampe de 10 s pour un StopTime de 1,2 s.
- Paramètre `Iset` inutilisé dans plusieurs exemples.
- `LEDSimpleThermal_ExternalHeatSink` : composants MSL sans paramètres
  (`R`, `C`, `Gr`) et entrées `Gc` des `Convection` non connectées ;
  75 ko d'images en base64.
- `MatrixLED` (66 LED non connectées) et le package `LedMatrix` sont vides.

## Architecture cible

```
LEDSystems/
├── UsersGuide/     Overview, Conventions, ReleaseNotes, License, Contact
├── Types/          énumérations
├── Interfaces/     connecteur photométrique
├── Functions/      calage I–V, interpolations
├── Data/           LEDData + un record par référence de LED
├── Components/     LED (heatPort permanent), LEDArray (Ns×Np mis à l'échelle),
│                   LEDMatrix (tableau explicite, dispersion)
├── Thermal/        plaque alu, MCPCB, boîtier, température imposée / table
├── Examples/       Basics/, Automotive/, DomesticLamp/, SolarSpot/
└── Resources/Images/
```

Principe clé : le composant `LED` a **toujours** un `heatPort` (sa jonction).
Les anciens modes thermiques internes deviennent des composants du package
`Thermal`. Un modèle prêt à l'emploi « LED + plaque » garde la simplicité d'un
bloc unique pour les élèves.

Les systèmes complets (spot solaire avec panneau, batterie, régulateur) ne vont
**pas** dans cette bibliothèque : ils iront dans une bibliothèque séparée qui
l'utilise.

## Conception actuelle (après l'étape 5)

Les tables de migration (0.5.0 → 0.6.0, 0.6.0 → 0.7.0, 0.8.0 → 0.9.0) sont dans
`UsersGuide.ReleaseNotes`.

### Composants `LED`, `LEDArray`, `LEDMatrix`
- Base commune `Components.BaseClasses.PartialLED` (tout le calcul) : `heatPort`
  **permanent** = jonction (`heatPort.T = Tj`, `heatPort.Q_flow = -Qth`), ni masse ni
  mode thermique. Ports `p`/`n` (`OnePort`), `heatPort`, `lightPort` ; `data` (record
  remplaçable) + résumé en lecture seule.
- Assemblage `Ns` × `Np` : vLED = v/Ns, iLED = i/Np. Sorties : `Vf`, `If` **d'une LED** ;
  `Iv`, `Phi_v`, `P_elec`, `P_opt`, `Qth` **totaux** ; `Tj` commune.
- Dispersion par instance : `dVf` (décalage de Vf) et `kIv` (facteur d'intensité),
  onglet « Avancé », groupe « Dispersion ».
- `LED` : `final Ns = Np = 1`. `LEDArray` : Ns × Np LED **identiques**, modèle agrégé,
  `heatPort` = jonction commune (une string serait une chaîne en série : nom écarté).
- `LEDMatrix` : tableau public `LED led[Ns, Np]` (indice [position, branche]), Np
  branches de Ns LED en série, `R_ballast` par branche, `dVf[Ns, Np]`, `kIv[Ns, Np]` ;
  `heatPort` = **carte** commune, chaque LED reliée par `rthJC[j, k]` ; sorties
  `If_branch[Np]`, `Tj_max`. Le diagramme interne d'OMEdit ne trace pas les connexions
  écrites en boucle (schéma en texte dans la documentation).
- Variables internes : `IsShockley`, `nShockley`, `RsShockley` (pas `n` : c'est la
  broche négative de `OnePort`), `Vt`, `dVf_T`, `vEff`, `xExp`, `mLambert`, `shockleyFit`.
- Boucle électrothermique : `Tj` porte l'annotation OpenModelica
  `__OpenModelica_tearingSelect = TearingSelect.avoid` (et `xExp` une valeur de départ
  au courant typique). Sans elle, omc itère sur `Tj` et calcule Vf à rebours depuis le
  bilan thermique (≈ 5 V/K) : échec d'initialisation dès que la jonction est reliée à
  une capacité. Toute copie de `Tj` dans un modèle englobant doit porter la même
  annotation (cas de `LEDWithPlate.Tj`). « TearingSelect.prefer » sur `xExp` ne suffit pas.

### Modèle électrique
- Shockley + Rs + Rp. `fitShockley3Points` : calage **exact** sur 3 points de If = f(Vf)
  (V = A·ln(I) + B + Rs·I, élimination de B puis Cramer) ; Rs < 0 ou n ≤ 0 → erreur.
  Vishay : n = 3,9465 ; Is = 1,892e-15 A ; Rs = 12,960 Ω.
- Vf(T) : `TCVf` linéaire par défaut, ou `Vf_T_table` (`vfTemperatureModel = Table`).
- Choix de modèle du record par énumérations de `Types` (listes déroulantes, 6.7) :
  `ivCurveModel` (`IVCurveModel` : `ThreePointFit` / `ShockleyParameters`),
  `vfTemperatureModel` (`VfTemperatureModel` : `Linear` / `Table`),
  `lightTemperatureModel` (`LightTemperatureModel` : `Table` / `Linear`). Chaque paramètre
  dépendant porte « sert si … » dans sa description.

### Photométrie
- Iv = Iv_ref · fI(If)/fI(If_nom) · fT(Tj)/fT(Tj_refLight) ; `Iv_ref` = `Iv_nom`, ou
  déduite de `Phi_nom` (Φ = 2π·Iv/(m+1)) selon `Types.PhotometricInput`.
- fI (`Functions.relativeIntensity`) : log-log dans `IvRel_If_table` ; **sous le premier
  point, Iv ∝ I** (prolonger une pente < 1 donnerait un rendement > 100 %) ; au-delà du
  dernier point, dernier segment prolongé et avertissement.
- fT (`Functions.interpolateClamped`) : `IvRel_T_table` en °C, bornée ; option `TCIV`
  (`lightTemperatureModel = Linear`). Approximation : la Fig. 7 (fonction de Tamb) est
  appliquée à Tj.
- Garde-fou : `assert(P_opt <= P_elec + 1e-9, …, AssertionLevel.warning)`, sans
  écrêtage ; tolérance de 1 nW (bruit numérique à courant nul sur des LED en série).

### Package `Thermal` (un seul port `port`, à brancher sur le `heatPort`)
- Rejeu (imposent Tj sans tenir compte de la puissance) : `FixedTemperature`,
  `TemperatureTable` (t en s, T en °C, filtre optionnel), `TemperatureFirstOrder`.
- Prédiction : `Plate` (C = ρ·c_p·aire·épaisseur, R vers l'ambiance, T(0) = `T_start`).
- `Components.LEDWithPlate` : `LED` + `RthJC` + `Plate`. Résistance plaque - air : case
  `useDatasheetRth` (RthJA − RthJC) ou valeur littérale `R_plate` (OMEdit n'affiche
  pas un défaut calculé à partir d'un autre paramètre).

### Dialogues
- Onglet standard « General » d'OMEdit (aucun `tab` indiqué, pour ne pas créer un
  second onglet « Général »), puis « Thermique », « Lumière », « Avancé ».
- Exemples : saisir les valeurs **directement sur les composants**. OMEdit n'ouvre pas
  de dialogue pour les paramètres de l'exemple lui-même (visibles seulement dans le
  texte et le navigateur de variables), et une icône `%Np` affiche l'expression
  (`N`), pas sa valeur. Aucun exemple n'a de paramètre de premier niveau (corrigé en 6.2 ;
  une valeur utilisée à plusieurs endroits est saisie sur chaque composant et la
  documentation de l'exemple le signale).

### Données datasheet et validation (étape 5)
- Validation sur datasheet seul (pas de mesures). PDF dans `datasheets/` (racine),
  **exclu de Git** (droit d'auteur, jamais publiés) ; les records ne contiennent que les
  valeurs extraites, chacune commentée avec sa source (page, figure ou tableau,
  conditions de mesure). Courbes vectorielles : points extraits des tracés.

| Cas | Record (`Data/`) | LED | Document |
|---|---|---|---|
| Spot solaire | `Bridgelux_BXEN_57E_11L` | SMD 2835 0,2 W 3 V, 5700 K, IRC 80 | DS55 Rev. B (07/2016) |
| Lampe domestique | `Bridgelux_BXEN_30G_11M` | SMD 2835 0,5 W 3 V, 3000 K, IRC 90 | DS242 Rev. F (04/2024) |
| Automobile | `Lumileds_LUXEON_FX2L_Plus_CW` | LUXEON FX2-L Plus CW, réf. …003800 | DS394 (20231206) |

- Les records ne contiennent que les **données de calage** ; les points de validation
  sont dans `outils/references_cas_usage.py`, jamais dans un record.
- **Convention de RthJC** : `RthJC_onElectricalPower` (Bridgelux : RthJ-SP sur la
  puissance électrique totale) → `eta_ref` (suppose If_typ = If_nom) et
  `RthJC_heat` = RthJC/(1 − eta_ref), seule résistance utilisée par les modèles
  (DS55 : 29 → ≈ 53 K/W ; DS242 : 24 → 45 K/W ; LUXEON : 5,6 K/W réelle).
- **LER** (absente des datasheets) : spectre du datasheet pondéré par V(λ) de Wyman
  et al. (±0,005 de la CIE) ; spectres échantillonnés à 5 nm dans `calculs_reference.py`
  (`SPECTRES`) : 309,4 (DS55, 6500 K), 290,5 (DS242), 313,1 lm/W (LUXEON).
- `Functions.dispersion(n, typ, min, max, seed)` : loi normale tronquée,
  σ = (max − min)/6, xorshift64* de la MSL, reproductible.
- **Température des points** : chaque point de référence porte `T_mesuree` =
  `"jonction"` ou `"soudure"` ; un point « soudure » reçoit `decalage_Tsp_Tj`.
- **Hypothèses par datasheet** :
  - DS55 : Fig. 2, Fig. 3, Tab. 3 supposées pulsées (Tj = 25 °C ; en continu, écart
    ≤ −14 mV et ≤ −1 %, invérifiable) ; Fig. 4 et Tab. 2 (continu, 60 mA) : décalage
    Tsp → Tj de 5,4 K. Spot solaire en classe de tension F ; froid et courants < 10 mA
    extrapolés, non validés.
  - DS242 : **tout pulsé, Fig. 4 comprise** (`decalage_Tsp_Tj` = 0 ; Tab. 2 : 55/61 =
    0,902, Fig. 4 lue en pulsé 0,897, en continu 0,917). Calage I–V sur la Fig. 2, la
    Tab. 3 (jusqu'à −46 mV) en validation secondaire. n = 1,47, Rs = 1,69 Ω :
    ln(I/Is) ≈ 73 à 240 mA, proche de `xExp_max` = 80, à surveiller.
  - **Incohérence du DS242** : Tab. 3 à 85 °C, de 42 à 120 mA, Φ(85)/Φ(25) ≈ 0,83
    contre 0,90 à 150 mA (Tab. 2, Fig. 4) ; même motif pour les autres teintes. Le
    modèle suit la Fig. 4 : +9,1 % à 42 mA, +8,3 % à 120 mA (tolérance ±7,5 %). La
    Rev. F est la version en ligne (vérifié le 2026-11-09, fichier identique, sans
    erratum) ; le DS242-3 est un autre produit (…-3C3, Vf typ. 3,1 V). Points de 42 à
    120 mA à 85 °C marqués « écart probable du datasheet » (5.6, décision de
    l'utilisateur).
  - LUXEON : tout en monopulse (Tj = Tsp) ; références à 85 °C (`Tj_refIV`, `Tj_refVf`,
    `Tj_refLight`), calage I–V à 85 °C (n = 1,98, Rs = 0,29 Ω) ; Vf(T) par `Vf_T_table`
    (ΔVf de la Fig. 6, pas de 10 °C) ; Φ(T) non monotone (maximum vers 50 °C) par la
    table ; Φ = 380 lm (minimum de la référence, pas de typique). Limites mises en
    évidence par des données indépendantes : courbe I–V à 25 °C, écart max +53 mV
    (n constant) ; flux à 25 °C sous 100 mA, −4,8 % (facteur thermique indépendant du
    courant).
- **Protocole** : tolérances = tolérances de mesure des datasheets, fixées avant
  simulation, jamais ajustées (règle 3) : Vf ±0,1 V et flux ±7,5 % (Bridgelux) ;
  Vf ±0,06 V et flux ±6,5 % (Lumileds).

| LED | Calage | Validation |
|---|---|---|
| DS55 | I–V 10 / 33,5 / 79,3 mA ; 6 points Φ(I) ; 6 points Φ(T) | 10 autres points I–V ; Vf Table 3 ; 4 points Φ(I) ; Φ Table 3 ; 4 points Φ(T) ; flux à 85 °C (Table 2) |
| DS242 | I–V 10 / 90 / 240 mA ; 5 points Φ(I) ; Φ(T) à 25 / 65 / 105 °C | 6 autres points I–V ; Table 3 ; 4 points Φ(I) ; Φ(T) à 45 / 85 °C ; flux et Vf à 85 °C (Table 2) |
| LUXEON | I–V à 85 °C 100 / 500 / 1500 mA ; table ΔVf(T) ; 5 points Φ(I) ; 7 points Φ(T) | 6 autres points I–V à 85 °C ; courbe I–V complète à 25 °C ; 4 points Φ(I) ; Φ(I) à 25 °C ; 5 points Φ(T) |

- **`tester_cas_usage.py`** : un point portant `ecart_datasheet` (marquage posé sur une
  plage, d'après l'analyse du datasheet, jamais d'après le résultat) qui sort de la
  tolérance est affiché « ÉCART DS », compté hors tolérance dans le bilan, mais ne fait
  pas échouer le code de retour (résumé « OK* »). Résultats 0.9.0 : DS55 calage 15/15,
  validation 29/29 ; DS242 11/11, 30/32 (2 écarts DS) ; LUXEON 15/15, 33/33 ; code 0.
- **Exemples des cas d'usage** : `SolarSpot.LiFePO4DirectDrive` (66 LED classe F en
  parallèle, 3,0 → 3,4 V en 2 h, 0 °C : 8 à 76 mA par LED) ; `DomesticLamp.LEDBulbWarmUp`
  (18 LED en série, 120 mA, radiateur 27 g, 10 K/W : 883 → 834 lm, Tj max 67,8 °C) ;
  `Automotive.HeadlampLowHighBeam` (`LEDWithPlate`, R_plate = 8 K/W, 50 g, air à 85 °C,
  1000 → 1500 mA à 30 min : Tj 110,8 → 129,0 °C, marge 21 K).
- Dans un exemple, un composant nommé `matrix` masque la fonction `matrix()` :
  colonne construite par `transpose({...})`.

### Points ouverts
- Grisage par `enable` dans le sous-dialogue `data` d'une LED : **ignoré par OMEdit 1.26**
  (constaté en 6.7 sur capture d'écran). omc transmet bien les conditions, préfixées
  (`data.useLinearVfTemp`) ; OMEdit ne les évalue pas dans ce sous-dialogue. Limite
  documentée (`LEDData`, `Types`, tutoriel) ; les descriptions disent « sert si … ».
  Rapport de bogue OpenModelica possible (non fait).
- `ExternalHeatSink` : rayonnement dissipateur - paroi modélisé par deux
  `BodyRadiation` en série (un seul échange en réalité) ; LED de 66 mW, échauffements
  faibles. Laissé en l'état (accord de l'utilisateur en 5.5), documenté dans l'exemple.
- Piste si l'annotation de tearing se révèle fragile : petite capacité thermique de
  jonction (≈ 1e-4 J/K, τ ≈ 1 ms), qui supprime la boucle algébrique.
- `Case` et `MCPCB` (package `Thermal`) : non créés en 5.4 / 5.5 (`Plate` et
  `LEDWithPlate` suffisent aux cas d'usage).
- `tester_datasheet.py` 8/8 ne fait que reproduire les données d'entrée (3 points de
  calage, 5 points de la Fig. 5) : la validation sur données indépendantes est faite
  par `tester_cas_usage.py`.

## Conception de l'étape 6

Validée le 2026-11-09.

| Sous-étape | Contenu |
|---|---|
| 6.2 | Exemples `Basics` : paramètres de premier niveau (`Iset`, `Tamb`, `Rth`) reportés sur les composants ; `LEDSimplePhoto` complété ; relecture des documentations « quoi observer » |
| 6.3 | Documentation des classes : `Data` et `Interfaces` (packages), `Interfaces.LightPort`, `Functions.ShockleyParams`, `Types.PhotometricInput`, package racine ; relecture de cohérence des autres |
| 6.4 | `UsersGuide` : `Overview`, `Tutorial` (paramétrer une LED depuis un datasheet, sur le DS55), `Validation` (méthode, résultats, limites, incohérence du DS242), `Conventions`, `References`, `License`, `Contact` (avec l'origine de la bibliothèque) |
| 6.5 | (fait avant 6.3, à la demande de l'utilisateur) Images : schémas SVG d'un dissipateur et d'un boîtier, à la place des JPEG, dans `LEDHeatSinkInCase` (ex-`LEDSimpleThermal_ExternalHeatSink`) ; vérification visuelle dans OMEdit |
| 6.6 | Fichiers de dépôt : `README.md`, `LICENSE` (BSD-3-Clause), licence CC BY 4.0 de la documentation et des images, `.gitignore` relu, mode d'emploi des outils de `outils/` |
| 6.7 | Relecture par l'utilisateur (OMEdit et texte), corrections |
| 6.8 | Version 1.0.0, tag `v1.0.0`, branche `main` ; commandes de publication fournies à l'utilisateur (jamais de `git push` par Claude) |

- **À reporter dans les notes de version 1.0.0** (migration 0.9.0 → 1.0.0) :
  `Examples.Basics.LEDSimpleThermal_FirstOrder` → `LEDJunctionFirstOrder` ;
  `Examples.Basics.LEDSimpleThermal_ExternalHeatSink` → `LEDHeatSinkInCase` ;
  `LEDSimplePhoto` refait (deux LED en série à 25 et 85 °C, rampe 0 → 20 mA) ; paramètres de
  premier niveau des exemples supprimés (`Iset`, `Tamb`, `Rth`, `dVf`) ; instances
  `led_3p3V_20mA` → `led`, résistance série inutile retirée.
  `LEDData.RthJA` vaut 0 par défaut (« non fournie », au lieu de 360 K/W, valeur de la
  Vishay) : un record personnel qui comptait sur l'ancien défaut doit renseigner RthJA.
  Nouveau `RthJA_heat` ; `LEDWithPlate` utilise `RthJA_heat − RthJC_heat` et s'arrête avec un
  message si `useDatasheetRth` est cochée sans RthJA.
  Choix de modèle du record `LEDData` : cases remplacées par des énumérations (6.7) :
  `shockleyParamsProvided = false/true` → `ivCurveModel = ThreePointFit/ShockleyParameters` ;
  `useLinearVfTemp = true/false` → `vfTemperatureModel = Linear/Table` ;
  `useIvTempTable = true/false` → `lightTemperatureModel = Table/Linear`. Groupes du
  dialogue réorganisés (Lumière : « Effet du courant », « Effet de la température »,
  « Puissance optique » ; Avancé : « Courbe I-V », « Calage sur 3 points »).
- `LEDWithPlate` (6.3 bis) : `RthJA` = 0 par défaut (« non fournie ») ; la convention
  `RthJC_onElectricalPower` s'applique aussi à RthJA (`RthJA_heat`) ; `R_plateUsed =
  RthJA_heat − RthJC_heat` ; `assert` (à la traduction) si `useDatasheetRth` sans RthJA,
  ou si `R_plateUsed` ≤ 0.
- Vishay VLMW41S1T1 : courant continu maximal 20 mA (Tamb ≤ 80 °C), Tj max 110 °C
  (datasheet Vishay vlmw41.pdf, doc. 82411) : plafond des rampes des exemples `Basics`.
- Vérifié en 6.1 : aucun PDF de datasheet dans l'historique Git. Images JPEG présentes
  dans l'historique (`Led/Images/`, dont `Test_LED_simple_ExternalHeatSink.jpg` supprimée
  en 1.5, et en base64 dans le commit initial) : d'où la décision « Historique publié ».

## Cas d'usage à couvrir

- **LED automobile** (phare : mono-LED blanche de puissance ou matrice) : flux donné
  en lm, fléchissement du flux aux forts courants, ambiance jusqu'à 85–105 °C,
  limite Tj. Une LED rouge/ambre (très sensible à la température, feu arrière) pourra
  être ajoutée plus tard si un datasheet est fourni.
- **Lampe domestique** : dizaines de LED moyenne puissance en série sur un PCB
  commun (nœud thermique partagé), driver à courant constant.
- **Spot solaire** (projecteur solaire) : LED en parallèle directement sur un élément
  LiFePO4 (commande en tension, 3,0 à 3,4 V), extérieur froid. La plage de 10 à 80 mA
  par LED suppose la **classe de tension haute F** (3,3 à 3,4 V à 60 mA, Tab. 7 du DS55) :
  une LED typique (3,1 V) dépasse le maximum de 80 mA dès 3,2 V (115 mA à 3,4 V).
  Le calage I–V est critique ici. Le froid et les courants < 10 mA sont extrapolés
  (pas de données dans le datasheet retenu).

## Plan de travail

| Étape → version | Contenu | Terminée quand |
|---|---|---|
| 1 → 0.5.0 | Restructuration sans changer les calculs : renommage `Led` → `LEDSystems`, passage à la MSL 4.1.0 (`uses`, `--msl`), arborescence, `Types`, `Resources`, icônes de packages, nettoyage, annotation `version="0.4.0"` dans le `package.mo` racine | **Exactement les mêmes résultats qu'au départ** : `verifier.py` 6/7 (seul `LEDSimpleThermal_ExternalHeatSink` échoue, pour la même raison) ; `tester_datasheet.py` 3/8 avec les mêmes chiffres |
| 2 → 0.6.0 | Refonte du composant LED et du record de données : heatPort permanent, package `Thermal`, unités, initialisation, traduction des identifiants en anglais, réparation de `LEDSimpleThermal_ExternalHeatSink` | `verifier.py` : tous les exemples OK (9/9 en fin d'étape, exemples `Basics` compris), sans avertissement d'initialisation |
| 3 → 0.7.0 | Correction des calculs : calage exact, photométrie par tables (entrée mcd ou lm), températures de référence | `tester_datasheet.py` : 8/8 points OK |
| 4 → 0.8.0 | `LEDArray` et `LEDMatrix` | exemples de matrice OK |
| 5 → 0.9.0 | Un exemple validé par cas d'usage, comparé à un datasheet réel | un test datasheet par cas d'usage |
| 6 → 1.0.0 | Documentation (UsersGuide), README, licence, vérification des droits sur chaque image de `Resources/Images/` (auteur ou licence compatible CC BY 4.0, source citée), publication | relecture par l'utilisateur |

Résultats de référence au départ : `verifier.py` **6/7**, `tester_datasheet.py`
**3/8 points OK** (détail dans « Résultats constatés des outils »).

## Journal des étapes

<!-- Après chaque étape validée, ajoute une ligne : date, étape, résumé. -->
- 2026-11-08 — Préparation — Décisions du projet fixées (nom `LEDSystems`,
  identifiants en anglais, licences BSD-3-Clause / CC BY 4.0, OpenModelica 1.26.1,
  MSL 4.1.0) et état de départ constaté (`verifier.py` 6/7, `tester_datasheet.py` 3/8).
- 2026-11-08 — Étape 1.1 — Renommage `Led` → `LEDSystems` (`git mv`), annotation
  `uses` en MSL 4.1.0, valeurs par défaut `--lib` / `--msl` des scripts mises à jour.
  Résultats identiques au départ.
- 2026-11-08 — Étape 1.2 — Package `Types` créé ; `ThermalInputMode` déplacé du record
  `LEDData` vers `LEDSystems.Types` (références en nom complet, y compris dans le
  banc de test de `tester_datasheet.py`, partie 2). Résultats identiques.
- 2026-11-08 — Étape 1.3 — Icônes : `Functions` → `FunctionsPackage` (n'étend plus
  une fonction), `Data` → `RecordsPackage`, `Modelica.Icons.Example` sur les 7 exemples,
  `Modelica.Icons.Record` sur `LEDData` et `ShockleyParams`. Résultats identiques.
- 2026-11-08 — Étape 1.4 — `Images/` déplacé en `Resources/Images/` (`git mv`) ; les
  2 `Bitmap` en base64 de `LEDSimpleThermal_ExternalHeatSink` remplacés par des
  références `modelica://LEDSystems/Resources/Images/...` (images identiques octet
  pour octet ; fichier 78,7 ko → 8,5 ko). Résultats identiques.
- 2026-11-08 — Étape 1.5 — Nettoyage (accord de l'utilisateur) : suppression de
  `Components/LED.mo.old`, `Functions/fitShockley3Points.mo.v0`,
  `arborescence_dossier_LedMatrix.txt`, du package vide `LedMatrix`, de l'ébauche
  `Components/MatrixLED.mo` et de la capture `Test_LED_simple_ExternalHeatSink.jpg` ;
  `package.order` mis à jour. Tout reste récupérable dans l'historique (commit 3912530).
  Résultats identiques.
- 2026-11-08 — Étape 1.6 — Annotation `version="0.4.0"` ajoutée au `package.mo`
  racine (sans `versionDate`, date réelle de la 0.4.0 inconnue). Résultats identiques.
- 2026-11-08 — **Étape 1 terminée → version 0.5.0** (tag `v0.5.0`) — `version="0.5.0"`,
  `versionDate="2026-11-08"` ; notes de version créées dans `UsersGuide.ReleaseNotes`.
  Critère rempli : `verifier.py` 6/7 et `tester_datasheet.py` 3/8, identiques au départ.
- 2026-11-08 — Étape 2.1 — Conception validée : interface de `LED` (heatPort permanent),
  package `Thermal`, table de traduction, convention de nommage, températures en
  `SI.Temperature` (°C à l'affichage), critère de non-régression.
- 2026-11-08 — Étape 2.2 — Package `Thermal` (`FixedTemperature`, `TemperatureTable`,
  `TemperatureFirstOrder`, `Plate`) et 4 exemples dans `Examples.Basics`, contrôlés
  par rapport aux valeurs analytiques. Équivalence ancien mode Physical ↔ LED + `Plate`
  vérifiée (écart max sur Tj ≈ 3e-5 K). `verifier.py` 10/11, `tester_datasheet.py`
  3/8 inchangé.
- 2026-11-08 — Étape 2.3 — Refonte de `LED` (heatPort permanent = jonction, plus de
  modes internes) et de `LEDData` (noms anglais, unités, onglets en français, courants
  en mA, paramètres principaux dans l'onglet standard « General »). Renommages : `LightPort`, `Vishay_VLMW41S1T1`, `LEDSimpleElec`,
  `LEDSimpleThermal_FirstOrder`. Supprimés (avec accord) : `LEDSimpleElec_2` à `_4`,
  `Types/ThermalInputMode.mo`. Exemples migrés vers `Thermal`, banc de test adapté
  (partie 2). Trajectoires identiques (pire écart relatif 1,6e-7) ; `verifier.py` 7/8
  sans aucun avertissement ; `tester_datasheet.py` 3/8 identique.
- 2026-11-08 — Étape 2.4 — `LEDSimpleThermal_ExternalHeatSink` réparé (valeurs
  plausibles documentées, Gc par blocs `Constant`, capacités initialisées à Tamb,
  `RthJonction` = RthJC ; topologie conservée). Nouveau `Components.LEDWithPlate`
  (case `useDatasheetRth` cochée par défaut : plaque - air = RthJA − RthJC ; sinon `R_plate`, 350 K/W) et exemple `Basics.LEDWithPlateConstantCurrent`.
  Annotation de tearing sur `Tj`. `verifier.py` 9/9 sans avertissement ; bilans
  vérifiés (Tj établi = Tamb + Qth·RthJA à 5e-7 K près ; flux vers l'air = Qth) ;
  non-régression 2,2e-12 ; `tester_datasheet.py` 3/8 identique.
- 2026-11-08 — **Étape 2 terminée → version 0.6.0** (tag `v0.6.0`) — `version="0.6.0"` ;
  notes de version 0.6.0 (avec table de traduction) ; section de conception condensée.
  Critère rempli : `verifier.py` 9/9 sans aucun avertissement.
- 2026-11-08 — Étape 3.1 — Conception validée : calage I–V exact, photométrie par tables
  (pente 1 sous la table), `Types.PhotometricInput`, Vf(T) par table optionnelle,
  garde-fous, valeurs attendues calculées hors Modelica.
- 2026-11-08 — Étape 3.2 — `fitShockley3Points` réécrite : calage exact (élimination de
  B, système 2×2 par Cramer), Rs < 0 et n ≤ 0 deviennent des erreurs. n = 3,9465,
  Is = 1,892e-15 A, Rs = 12,960 Ω (écart à la référence Python ≈ 3e-14). Vf à 1 / 20 /
  100 mA : écarts −4e-5 / −3e-7 / −5e-8 V. `tester_datasheet.py` 4/8 (Iv inchangé) ;
  `verifier.py` 9/9 sans avertissement. Valeurs documentées des exemples non encore
  recalculées (prévu en 3.4).
- 2026-11-08 — Étape 3.3 — Photométrie par tables : fonctions `relativeIntensity`
  (log-log, pente 1 sous la table) et `interpolateClamped` ; `Types.PhotometricInput`,
  `Phi_nom`, `useIvTempTable` ; Vf(T) par `Vf_T_table` en option ; supprimés
  `If_emitMin`, `If_refLight`, `If_minTable`, `If_maxTable`. `tester_datasheet.py`
  8/8 ; balayage 1 µA - 150 mA identique à la référence Python (1,7e-15), croissant,
  P_opt/P_elec ≤ 0,17 ; température, options TCIV et table Vf(T), saisie mcd/lm,
  sens inverse conformes ; `verifier.py` 9/9 sans avertissement.
- 2026-11-08 — Étape 3.4 — Garde-fou `assert(P_opt <= P_elec, …, warning)` (muet sur les
  exemples, déclenché une fois avec LER = 10 lm/W) ; `alpha_I` supprimé, son explication
  rattachée à la courbe `IvRel_If_table` (pentes 0,67 et 0,90) ; valeurs documentées
  recalculées par simulation (`LEDWithPlateConstantCurrent` : Qth ≈ 60 mW, Tj ≈ 41,7 °C ;
  `ExternalHeatSink` : Tj ≈ 24,2 °C). `tester_datasheet.py` 8/8 ; `verifier.py` 9/9
  sans avertissement.
- 2026-11-08 — **Étape 3 terminée → version 0.7.0** (tag `v0.7.0`) — `version="0.7.0"` ;
  notes de version 0.7.0 (avec migration) ; conception condensée. Critère rempli :
  `tester_datasheet.py` 8/8 ; `verifier.py` 9/9 sans avertissement.
- 2026-11-08 — Étape 4.1 — Conception validée : base commune `PartialLED` (Ns, Np,
  dVf, kIv), `LEDString`, `LEDMatrix` (branches parallèles, ballast, carte commune,
  dispersion par tableaux explicites), valeurs de référence du partage de courant.
- 2026-11-08 — Étape 4.2 — `Components.BaseClasses.PartialLED` (contenu de `LED`, plus
  `Ns`, `Np`, `dVf`, `kIv`) ; `LED` en hérite (Ns = Np = 1) ; nouveau `LEDArray`
  (d'abord nommé `LEDString`, renommé : une string est une chaîne en série) et
  exemple `Basics.LEDArrayEquivalence`. Garde-fou P_opt ≤ P_elec avec tolérance de
  1 nW (fausse alerte à courant nul sur des LED en série). Non-régression de `LED` :
  écart nul sur 5 exemples ; équivalence `LEDArray` / 6 LED : ≤ 1e-9 ; dVf = +0,1 V
  → Vf +0,100 V ; kIv = 0,5 → Iv × 0,5. `verifier.py` 10/10 sans avertissement ;
  `tester_datasheet.py` 8/8 identique.
- 2026-11-08 — Étape 4.3 — `Components.LEDMatrix` (tableau `led[Ns, Np]` public, ballast
  par branche, `heatPort` = carte via `rthJC[Ns, Np]`, dispersion `dVf`/`kIv` en tableaux,
  sorties `If_branch`, `Tj_max`) et exemple `Basics.LEDMatrixCurrentSharing`. Courants
  conformes à la référence Python (8,8e-8) : 32,0 / 25,9 / 14,8 / 10,0 mA sans ballast,
  27,4 / 23,7 / 16,6 / 13,2 mA avec 10 Ω ; équivalence sans dispersion avec `LEDArray`
  (via RthJC/6) : 3e-15 ; `kIv` agit sur la seule LED visée. `verifier.py` 11/11 sans
  avertissement ; `tester_datasheet.py` 8/8 identique.
- 2026-11-08 — **Étape 4 terminée → version 0.8.0** (tag `v0.8.0`) — `version="0.8.0"` ;
  notes de version 0.8.0 ; comparaison `LEDArray` / `LEDMatrix` dans la documentation du
  package `Components` ; conception condensée. Critère rempli : exemples de matrice
  OK ; `verifier.py` 11/11 sans avertissement ; `tester_datasheet.py` 8/8.
- 2026-11-08 — Étape 5.1 — Préparation : 3 datasheets (Bridgelux DS55, DS242 ; Lumileds
  DS394) dans `datasheets/` exclu de Git ; choix de modélisation (convention RthJS, LER
  par le spectre, Tsp → Tj) ; protocole calage / validation avec les tolérances des
  datasheets ; cas d'usage précisés (phare blanc, spot sur LiFePO4).
- 2026-11-08 — Étape 5.2 — Exemples de la racine déplacés dans `Examples.Basics` (`git mv`,
  rapports identiques) ; rampe de `LEDSimpleElec` corrigée (1 s) ; `outils/tester_cas_usage.py`
  et `outils/references_cas_usage.py` (135 points datasheet, calage / validation, Tsp en
  attente de conversion) : entrée Vishay identique à `tester_datasheet.py`, 3 LED en
  attente de leur record ; `outils/calculs_reference.py` (calages, V(λ) de Wyman et al.
  à ±0,005 de la CIE, LER, Tsp → Tj).
- 2026-11-09 — Étape 5.3 — Spot solaire : record `Bridgelux_BXEN_57E_11L` (DS55),
  convention RthJC sur puissance électrique (`RthJC_heat`), `Functions.dispersion`,
  exemple `SolarSpot.LiFePO4DirectDrive` (66 LED classe F en parallèle, rampe 3,0 → 3,4 V
  en 2 h, 0 °C, plaque alu) ; étiquette `T_ref` renommée `T_mesuree` ; hypothèse
  « pulsé » documentée. DS55 : calage 15/15, validation 29/29. Exemple : 8 à 76 mA par
  LED (< 80 mA), cohérence avec un calcul Python (dVf retrouvé constant à 2e-8 V),
  P_opt/P_elec ≤ 0,53. `verifier.py` 12/12 sans avertissement ; `tester_datasheet.py` 8/8.
- 2026-11-09 — Étape 5.4 — Lampe domestique : record `Bridgelux_BXEN_30G_11M` (DS242),
  LER par le spectre 3000 K IRC 90 (290,5 lm/W ; spectres DS55 et DS242 rangés dans
  `calculs_reference.py`), DS242 entièrement supposé pulsé (Fig. 4 comprise) ; exemple
  `DomesticLamp.LEDBulbWarmUp` (18 LED en série, 120 mA, radiateur 27 g, 10 K/W, 25 °C) :
  883 → 834 lm (−6 %), radiateur 58,6 °C, Tj max 67,8 °C ; bilans vérifiés (Tj à 2e-13 K,
  régime établi à 0,025 K = reste du transitoire). DS242 : calage 11/11, validation 30/32
  (2 échecs dus à l'incohérence de la Tab. 3 à 85 °C, gardés). `verifier.py` 13/13 sans
  avertissement ; `tester_datasheet.py` 8/8 ; DS55 inchangé.
- 2026-11-09 — Étape 5.5 — Phare automobile : record `Lumileds_LUXEON_FX2L_Plus_CW` (DS394,
  monopulse, références à 85 °C, ΔVf(T) en table, Rθj-c réelle, LER 313,1 lm/W) ; exemple
  `Automotive.HeadlampLowHighBeam` (air à 85 °C ; croisement 1000 mA : Tj 110,8 °C,
  360 lm ; route 1500 mA : Tj 129,0 °C, 481 lm, marge 21 K ; à 105 °C : Tj 149,8 °C) ;
  bilans vérifiés (Tj = Tplaque + Qth·RthJC exact, Qth = P_elec − P_opt, Tplaque à 0,1 K
  du régime établi après 5 τ). FX2L : calage 15/15, validation 33/33. `ExternalHeatSink`
  laissé en l'état ; ni `Case` ni `MCPCB`. `verifier.py` 14/14 sans avertissement ;
  `tester_datasheet.py` 8/8 ; DS55 et DS242 inchangés.
- 2026-11-09 — **Étape 5 terminée → version 0.9.0** (tag `v0.9.0`) — `version="0.9.0"`,
  `versionDate="2026-11-09"` ; notes de version 0.9.0 (records, `RthJC_heat`, `dispersion`,
  exemples des cas d'usage, validation, migration des exemples vers `Basics`). DS242 :
  Rev. F confirmée comme dernière version en ligne ; points Φ à 85 °C de 42 à 120 mA
  marqués « écart probable du datasheet » dans `tester_cas_usage.py` (affichés « ÉCART DS »,
  sans effet sur le code de retour, valeurs et tolérances inchangées). Remarque périmée
  de `ExternalHeatSink` corrigée ; conception condensée. Critère rempli : un test datasheet
  par cas d'usage ; `verifier.py` 14/14 sans avertissement ; `tester_datasheet.py` 8/8 ;
  `tester_cas_usage.py` code 0 (DS55 29/29, DS242 30/32 dont 2 écarts DS, FX2L 33/33).
- 2026-11-09 — Étape 6.1 — Conception validée : découpage 6.2 à 6.8 ; titulaire des
  droits et contact (Stéphane Gounelle) ; images JPEG de provenance inconnue remplacées
  par des SVG ; `CLAUDE.md` publié avec mention de l'origine (bibliothèque écrite à la
  main, finalisée avec Claude Code) ; dépôt `LEDSystems`, branche `main`. Restent à
  décider : historique publié (avant 6.8), langue du README (avant 6.6).
- 2026-11-09 — Étape 6.2 — Exemples `Basics` (décisions 6.1 complétées : dépôt neuf, README
  français et anglais complets) : renommages (`git mv`) `LEDSimpleThermal_FirstOrder` →
  `LEDJunctionFirstOrder`, `LEDSimpleThermal_ExternalHeatSink` → `LEDHeatSinkInCase` ;
  paramètres de premier niveau supprimés (valeurs saisies sur les composants) ; variables
  protégées, résistance série inutile et renvois `ledXX` retirés ; `LEDSimplePhoto` refait
  (25 / 85 °C : Iv85/Iv25 = 0,73, Φ/Iv = π, Iv non proportionnelle) ; valeurs attendues
  issues de la simulation dans chaque documentation ; `package.order` progressif et
  tableau de progression dans `Basics`. Trajectoires inchangées (écart nul ; 2,8e-7 sur
  `LEDHeatSinkInCase`, potentiels absolus exclus). `verifier.py` 14/14 sans avertissement ;
  `tester_datasheet.py` 8/8.
- 2026-11-09 — Étape 6.5 (avancée avant 6.3) — `LEDHeatsink.jpg` et `LEDCase.jpg` (photos de
  produits du commerce, provenance inconnue) remplacées par `LEDHeatsink.svg` (dissipateur
  à ailettes radiales, LED) et `LEDCase.svg` (coupe du boîtier fermé : convection
  intérieure, chaleur cédée vers l'extérieur, lumière par une fenêtre), dessinées pour le
  projet, © Stéphane Gounelle, CC BY 4.0 (mention dans chaque fichier). OMEdit lit le SVG
  (module Qt `libqsvg`). JPEG supprimés (`git rm`) ; `Bitmap` de `LEDHeatSinkInCase`
  pointées sur les SVG, coins du dissipateur remis dans le même ordre que ceux du boîtier
  (`{{-17, 21}, {17, -21}}`, l'ancien ordre retournait l'image). `verifier.py` OK.
- 2026-11-09 — Étape 6.3 — Documentation des classes : descriptions et documentations
  ajoutées (`Data`, `Interfaces`, `Interfaces.LightPort`, `Functions.ShockleyParams` et ses
  champs, `Types.PhotometricInput`, `UsersGuide` (description seule)) ; réécrites ou
  complétées (racine, `Examples`, `Functions`, `Vishay_VLMW41S1T1` avec sources et limites
  20 mA / 110 °C, `LEDData` avec le tableau des onglets du dialogue) ; liens
  `modelica://` ; `LightPort.Iv` en `displayUnit="mcd"` ; mentions de RthJC remplacées par
  `RthJC_heat` (`LED`, `LEDMatrix`, `LEDWithPlate`) et limite de `useDatasheetRth`
  documentée. Contrôle automatique : toutes les classes ont description et documentation,
  aucun lien cassé, aucun terme périmé (hors `UsersGuide`, 6.4). `verifier.py` 14/14 sans
  avertissement ; `tester_datasheet.py` 8/8.
- 2026-11-09 — Étape 6.3 bis — Correction de `LEDWithPlate` (accord de l'utilisateur) :
  `LEDData.RthJA` = 0 par défaut (« non fournie ») au lieu des 360 K/W de la Vishay, hérités
  sans message par les records Bridgelux et Lumileds ; nouveau `RthJA_heat` (même convention
  que RthJC) ; `R_plateUsed = RthJA_heat − RthJC_heat` ; garde-fous (`useDatasheetRth` sans
  RthJA → erreur explicite à la traduction ; `R_plateUsed` ≤ 0 → erreur). Contrôles : erreur
  déclenchée avec le record DS242 ; conversion juste avec RthJA fictif de 100 K/W (187,5 −
  45,0 = 142,5 K/W) ; exemples inchangés (écart nul) ; `verifier.py` 14/14 sans avertissement.
- 2026-11-09 — Étape 6.4 — `UsersGuide` : sommaire, `Overview` (modèle, rejeu / prédiction,
  choix d'un composant), `Tutorial` (record DS55 pas à pas, onglet par onglet, encadrés
  « LED en mcd », modèle de test et valeurs attendues recalculées par simulation :
  n = 2,51, Is = 2,2e-20 A, Rs = 6,0 Ω, eta_ref = 0,452, RthJC_heat = 53,0 K/W),
  `Conventions`, `Validation` (résultats et plus grands écarts tirés de
  `tester_cas_usage.py`, limites connues), `References`, `License` (texte BSD-3-Clause,
  résumé CC BY 4.0), `Contact` (auteur, dépôt github.com/gounelles/LEDSystems, origine du
  projet). Schéma `Resources/Images/LEDModel.svg` (CC BY 4.0) dans `Overview` et `LED`.
  Correction : `photometricInput` est dans l'onglet General (doc de `PhotometricInput`).
  Contrôle automatique sans problème ; `verifier.py` 14/14 sans avertissement ;
  `tester_datasheet.py` 8/8.
- 2026-11-09 — Étape 6.6 — Fichiers du dépôt : `README.md` (français) et `README.en.md`
  (traduction complète), liés entre eux, sans numéro de version (renvoi aux notes de
  version) ; `LICENSE` (BSD-3-Clause seule, pour la détection par GitHub) ;
  `LICENSE-CC-BY-4.0.txt` (texte officiel téléchargé de creativecommons.org,
  `legalcode.txt`, non modifié) ; `outils/README.md` (prérequis, scripts, sorties, codes de
  retour, `ÉCART DS`, règle des références) ; en-têtes SPDX + copyright dans les 6 scripts
  Python ; `.gitignore` complété (fichiers d'omc hors de `build/`, sauvegardes d'éditeur),
  aucun fichier suivi ignoré. Liens relatifs des README vérifiés. Libellé exact de la
  commande d'ouverture d'OMEdit non écrit (à vérifier par l'utilisateur). `verifier.py`
  14/14, `tester_datasheet.py` 8/8, `tester_cas_usage.py` code 0.
- 2026-11-10 — Étape 6.7 — Relecture OMEdit par l'utilisateur : tout validé, sauf le grisage. Corrections : (A) mode opératoire du tracé paramétrique (Maj + clic pour
  l'axe x) dans `UsersGuide.Conventions`, `LEDSimplePhoto` et le tutoriel ; (B) tutoriel,
  étape 8 « Se faire aider par une IA » (prompt de génération d'un record, avec bizarreries,
  points de contrôle indépendants et ordres de grandeur ; consignes de contrôle), mention
  dans le sommaire et les README ; (C) grisage ignoré par OMEdit dans le sous-dialogue
  `data` : cases `useLinearVfTemp`, `useIvTempTable`, `shockleyParamsProvided` remplacées
  par les énumérations `VfTemperatureModel`, `LightTemperatureModel`, `IVCurveModel`,
  descriptions « sert si … », limite documentée. Non-régression : trajectoires identiques
  (écart nul, 14 exemples), sorties de `tester_datasheet.py` et `tester_cas_usage.py`
  identiques à l'octet ; `verifier.py` 14/14 sans avertissement. Nouveaux dialogues contrôlés
  dans OMEdit par l'utilisateur.
- 2026-11-10 — **Étape 6 terminée → version 1.0.0** (tag `v1.0.0`, branche `main`) —
  `version="1.0.0"`, `versionDate="2026-11-10"` ; notes de version 1.0.0 (nouveautés de
  l'étape 6, table de migration 0.9.0 → 1.0.0). Contrôles du contenu publié (fichiers
  suivis) : aucun PDF ni JPEG, aucun lien `modelica://` cassé. `verifier.py` 14/14 sans
  avertissement ; `tester_datasheet.py` 8/8 ; `tester_cas_usage.py` code 0 (DS55 29/29,
  DS242 30/32 dont 2 écarts DS, FX2L 33/33). Branche locale `master` renommée `main`.
  Commandes de publication (dépôt neuf, commit initial unique) fournies à l'utilisateur.
- 2026-11-11 — Publication — Dépôt public https://github.com/gounelles/LEDSystems mis en
  ligne par l'utilisateur (push après `gh auth login`) : un seul commit `LEDSystems 1.0.0`,
  tag `v1.0.0`, branche `main`, préparés dans un dossier séparé à partir de `git archive v1.0.0`.
  Le dépôt de travail garde l'historique complet, sans remote. Toute évolution passera par une
  version 1.0.x / 1.1.0, avec notes de version et report dans le dépôt public à convenir.
- 2026-11-11 — **Version 1.1.0** (tag `v1.1.0`) — Changement de licence (décision de
  l'utilisateur) : code en MPL-2.0 (copyleft limité aux fichiers de la bibliothèque),
  documentation et images en CC BY-SA 4.0. `LICENSE` = texte MPL-2.0 officiel,
  `LICENSE-CC-BY-SA-4.0.txt` (legalcode.txt de creativecommons.org) remplace
  `LICENSE-CC-BY-4.0.txt` (supprimé avec accord) ; avis MPL dans les 6 scripts Python
  (SPDX `MPL-2.0`), pas dans les `.mo` ; SVG, README, `outils/README.md`, package racine,
  `UsersGuide.License` (réécrit) et notes de version mis à jour. Modèles inchangés.
  `verifier.py` 14/14 sans avertissement ; `tester_datasheet.py` 8/8.
