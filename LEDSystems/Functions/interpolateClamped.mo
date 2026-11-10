within LEDSystems.Functions;
function interpolateClamped
  "Interpolation linéaire dans une table, valeur des extrémités maintenue au-delà"
  extends Modelica.Icons.Function;

  input Real table[:, 2] "Table (x croissants, y)";
  input Real x "Abscisse";
  output Real y "Valeur interpolée";

protected
  Integer n = size(table, 1);
  Integer j;

algorithm
  assert(n >= 1, "interpolateClamped : la table est vide.");
  if x <= table[1, 1] then
    y := table[1, 2];
  elseif x >= table[n, 1] then
    y := table[n, 2];
  else
    j := 2;
    while x > table[j, 1] loop
      j := j + 1;
    end while;
    y := table[j - 1, 2] + (table[j, 2] - table[j - 1, 2])*(x - table[j - 1, 1])
         /(table[j, 1] - table[j - 1, 1]);
  end if;

  annotation (Documentation(info = "<html>
<p>Interpolation linéaire entre les points d'une table (abscisses croissantes).
En dehors de la table, la valeur du premier ou du dernier point est maintenue :
pas d'extrapolation hors du domaine mesuré.</p>
<p>Utilisée pour l'intensité relative en fonction de la température (T en °C).</p>
</html>"));
end interpolateClamped;
