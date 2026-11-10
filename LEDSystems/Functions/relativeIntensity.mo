within LEDSystems.Functions;
function relativeIntensity
  "Intensité lumineuse relative fI(If) interpolée dans la courbe du datasheet"
  extends Modelica.Icons.Function;

  input Real table[:, 2] "Courbe du datasheet : If (A), intensité relative (1)";
  input Modelica.Units.SI.Current I "Courant direct";
  input Boolean logLog = true
    "true : interpolation log-log (courbe tracée en échelles log) ; false : linéaire";
  output Real y(unit = "1") "Intensité relative";

protected
  Integer n = size(table, 1);
  Integer j "Indice du point de fin du segment utilisé";
  Real s(unit = "1") "Pente log-log du segment";

algorithm
  assert(n >= 2, "relativeIntensity : la table doit contenir au moins 2 points.");
  if I <= 0 then
    // Sens inverse ou courant nul : pas d'émission
    y := 0;
  elseif I <= table[1, 1] then
    // Sous le premier point : intensité proportionnelle au courant (rendement constant).
    // Prolonger la pente de la courbe donnerait un rendement supérieur à 100 %.
    y := table[1, 2]*I/table[1, 1];
  else
    // Segment [j-1, j] qui contient I ; au-delà du dernier point, le dernier segment
    // est prolongé (extrapolation).
    j := 2;
    while j < n and I > table[j, 1] loop
      j := j + 1;
    end while;
    if logLog then
      s := log(table[j, 2]/table[j - 1, 2])/log(table[j, 1]/table[j - 1, 1]);
      y := table[j - 1, 2]*(I/table[j - 1, 1])^s;
    else
      y := table[j - 1, 2] + (table[j, 2] - table[j - 1, 2])*(I - table[j - 1, 1])
           /(table[j, 1] - table[j - 1, 1]);
    end if;
  end if;

  annotation (Documentation(info = "<html>
<p>Interpole la courbe « intensité lumineuse relative en fonction du courant » du
datasheet (points If croissants, en A).</p>
<ul>
<li>Entre deux points : interpolation <strong>log-log</strong> (droite en échelles
    logarithmiques, comme le graphe du datasheet), ou linéaire si <code>logLog = false</code>.</li>
<li>Sous le premier point : intensité <strong>proportionnelle</strong> au courant.
    Le rendement lumineux reste celui du premier point ; prolonger la pente de la courbe
    (souvent inférieure à 1) donnerait un rendement qui augmente quand le courant
    diminue, jusqu'à dépasser 100 %.</li>
<li>Au-delà du dernier point : le dernier segment est prolongé (hors du domaine du
    datasheet, à utiliser avec prudence).</li>
<li>Courant nul ou négatif : 0.</li>
</ul>
</html>"));
end relativeIntensity;
