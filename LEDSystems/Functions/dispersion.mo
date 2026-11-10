within LEDSystems.Functions;
function dispersion
  "Valeurs pseudo-aléatoires reproductibles (loi normale tronquée aux bornes du datasheet)"
  extends Modelica.Icons.Function;

  input Integer n(min = 1) "Nombre de valeurs";
  input Real typ "Valeur typique (datasheet)";
  input Real minVal "Valeur minimale (datasheet)";
  input Real maxVal "Valeur maximale (datasheet)";
  input Integer seed = 1 "Graine : la même graine donne toujours les mêmes valeurs";
  output Real y[n] "Valeurs tirées, toutes comprises entre minVal et maxVal";

protected
  Integer state[Modelica.Math.Random.Generators.Xorshift64star.nState];
  Real u "Nombre uniforme entre 0 et 1";

algorithm
  assert(minVal < typ and typ < maxVal, "dispersion : il faut minVal < typ < maxVal.");
  state := Modelica.Math.Random.Generators.Xorshift64star.initialState(seed, 0);
  for k in 1:n loop
    (u, state) := Modelica.Math.Random.Generators.Xorshift64star.random(state);
    y[k] := Modelica.Math.Distributions.TruncatedNormal.quantile(
      u, y_min = minVal, y_max = maxVal, mu = typ, sigma = (maxVal - minVal)/6);
  end for;

  annotation (Documentation(info = "<html>
<p>Tire <code>n</code> valeurs représentant la dispersion de fabrication d'une grandeur
dont le datasheet donne la valeur typique et les bornes garanties (min et max, par
exemple les classes de tension directe ou de flux).</p>
<p><strong>Hypothèse</strong> (le datasheet ne donne pas la distribution) : loi normale
centrée sur la valeur typique, d'écart type (max &minus; min)/6, <em>tronquée</em> aux bornes :
toutes les valeurs sont dans [min, max], et 99,7&nbsp;% le seraient sans troncature.</p>
<p>Le tirage est <strong>reproductible</strong> : générateur xorshift64* de la MSL
(<code>Modelica.Math.Random.Generators.Xorshift64star</code>), initialisé par
<code>seed</code>. Avec la même graine, toute une classe obtient exactement les mêmes LED.
Utiliser des graines différentes pour des grandeurs indépendantes (tension et flux).</p>
<p>Exemple, pour <code>LEDMatrix</code> (1 branche de 66 LED en parallèle) :</p>
<pre>dVf = {dispersion(66, 3.1, 2.8, 3.4, seed = 1) .- 3.1}
kIv = {dispersion(66, 26, 22, 32, seed = 2) ./ 26}</pre>
</html>"));
end dispersion;
