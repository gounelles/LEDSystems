within LEDSystems.Examples;
package Automotive "Éclairage automobile : LED de puissance d'un phare"
  extends Modelica.Icons.ExamplesPackage;

  annotation (Documentation(info="<html>
<p>Cas d'usage du phare automobile : LED blanche de puissance alimentée à courant
constant, montée sur le radiateur d'un phare dont l'air intérieur est chaud (85&nbsp;°C
et plus, près du moteur et sous le soleil). Enjeux : flux en lumens, fléchissement du
flux aux forts courants, baisse du flux avec la température, limite de température de
jonction.</p>
<p>LED : Lumileds LUXEON FX2-L Plus Cool White, A1F2-5850F3C003800
(<code>Data.Lumileds_LUXEON_FX2L_Plus_CW</code>, datasheet DS394), validée par
<code>outils/tester_cas_usage.py</code> de 50 à 1500&nbsp;mA et de &minus;40 à 150&nbsp;°C.</p>
</html>"));
end Automotive;
