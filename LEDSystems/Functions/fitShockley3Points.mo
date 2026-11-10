within LEDSystems.Functions;
function fitShockley3Points
  "Calage exact des paramètres de Shockley (Is, n, Rs) sur 3 points de la courbe If = f(Vf)"
  extends Modelica.Icons.Function;

  import Modelica.Constants.k;
  import Modelica.Constants.q;
  import Modelica.Math.log;
  import Modelica.Math.exp;

  input Modelica.Units.SI.Voltage V1 "Point 1 : tension";
  input Modelica.Units.SI.Current I1 "Point 1 : courant";
  input Modelica.Units.SI.Voltage V2 "Point 2 : tension";
  input Modelica.Units.SI.Current I2 "Point 2 : courant";
  input Modelica.Units.SI.Voltage V3 "Point 3 : tension";
  input Modelica.Units.SI.Current I3 "Point 3 : courant";
  input Modelica.Units.SI.Temperature T = 298.15 "Température de jonction de la courbe";

  output ShockleyParams p "Paramètres calés : Is, n, Rs";

protected
  Modelica.Units.SI.Voltage Vt "Tension thermique kT/q";
  Modelica.Units.SI.Voltage A "Pente n*Vt (V par unité de ln(I))";
  Modelica.Units.SI.Voltage B "Ordonnée à l'origine : -A*ln(Is)";
  Real L21(unit="1") "ln(I2/I1)";
  Real L32(unit="1") "ln(I3/I2)";
  Modelica.Units.SI.Current D21 "I2 - I1";
  Modelica.Units.SI.Current D32 "I3 - I2";
  Real det(unit="A") "Déterminant du système 2x2";

algorithm
  assert(I1 > 0 and I2 > I1 and I3 > I2,
    "fitShockley3Points : il faut 0 < I1 < I2 < I3.");

  Vt := k*T/q;

  // Modèle : V = A*ln(I) + B + Rs*I   (A = n*Vt, B = -A*ln(Is) ; le "-1" de la loi
  // de Shockley est négligé : I/Is est de l'ordre de 1e12). Ce système est linéaire
  // en (A, B, Rs) : on le résout exactement.

  // 1) Différences entre points : B disparaît
  //    V2 - V1 = A*ln(I2/I1) + Rs*(I2 - I1)
  //    V3 - V2 = A*ln(I3/I2) + Rs*(I3 - I2)
  L21 := log(I2/I1);
  L32 := log(I3/I2);
  D21 := I2 - I1;
  D32 := I3 - I2;

  // 2) Système 2x2 en (A, Rs), résolu par la règle de Cramer
  det := L21*D32 - L32*D21;
  assert(abs(det) > 1e-12,
    "fitShockley3Points : les 3 points sont alignés en (ln(I), I), calage impossible.");
  A := ((V2 - V1)*D32 - (V3 - V2)*D21)/det;
  p.Rs := (L21*(V3 - V2) - L32*(V2 - V1))/det;

  // 3) B depuis le point 1, puis n et Is
  B := V1 - A*log(I1) - p.Rs*I1;
  p.n := A/Vt;
  p.Is := exp(-B/A);

  assert(A > 0,
    "fitShockley3Points : pente négative ou nulle (n <= 0), points incohérents.");
  assert(p.Rs >= 0,
    "fitShockley3Points : résistance série négative, points incohérents "
    + "(vérifier les 3 points lus sur la courbe If = f(Vf)).");

  annotation (Documentation(info = "<html>
<p>Calcule les paramètres du modèle de diode de Shockley avec résistance série,</p>
<p>I = Is&middot;(exp((V &minus; Rs&middot;I)/(n&middot;Vt)) &minus; 1), &nbsp; Vt = k&middot;T/q,</p>
<p>à partir de 3 points (V, I) lus sur la courbe If = f(Vf) du datasheet.</p>
<p><strong>Méthode (exacte)</strong> : en négligeant le &laquo;&nbsp;&minus;1&nbsp;&raquo;
(I est très grand devant Is), V = A&middot;ln(I) + B + Rs&middot;I avec A = n&middot;Vt et
B = &minus;A&middot;ln(Is). Cette relation est <em>linéaire</em> en (A, B, Rs) :</p>
<ol>
<li>en soustrayant les équations deux à deux, B disparaît ; il reste un système 2&times;2
    en (A, Rs), résolu par la règle de Cramer ;</li>
<li>B se déduit du point 1 ;</li>
<li>n = A/Vt et Is = exp(&minus;B/A).</li>
</ol>
<p>Le modèle repasse alors exactement par les 3 points.</p>
<p>Choix des points : dans la zone où la LED conduit, bien répartis (par exemple
1&nbsp;mA, courant nominal, courant maximal). Si les points sont incohérents
(résistance série ou facteur d'idéalité négatifs), la fonction s'arrête avec un message.</p>
</html>"));
end fitShockley3Points;
