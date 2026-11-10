within LEDSystems.Types;
type PhotometricInput = enumeration(
    LuminousIntensity "Intensité lumineuse de référence Iv_nom (mcd)",
    LuminousFlux "Flux lumineux de référence Phi_nom (lm)")
  "Grandeur photométrique de référence donnée par le datasheet"
  annotation (Documentation(info = "<html>
<p>Choix de la grandeur photométrique de référence, paramètre
<code>photometricInput</code> du record
<a href=\"modelica://LEDSystems.Data.LEDData\">LEDData</a> (onglet « General », groupe « Référence photométrique ») :</p>
<ul>
<li><code>LuminousIntensity</code> : le datasheet donne l'intensité lumineuse dans l'axe,
    en mcd (LED de signalisation, LED 5&nbsp;mm…). Renseigner <code>Iv_nom</code> ;</li>
<li><code>LuminousFlux</code> : le datasheet donne le flux lumineux, en lm (LED
    d'éclairage). Renseigner <code>Phi_nom</code>.</li>
</ul>
<p>L'autre grandeur est calculée à partir de l'angle de demi-intensité
<code>phi_half</code>, pour une émission de la forme I(&theta;) = Iv&middot;cos<sup>m</sup>(&theta;) :
&Phi; = 2&pi;&middot;Iv/(m+1), avec m = &minus;ln(2)/ln(cos(phi_half)). Pour
phi_half = 60° (émission lambertienne), m = 1 et &Phi; = &pi;&middot;Iv.</p>
</html>"));
