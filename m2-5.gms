$TITLE: M2-5, Structure of a general-equilibrium model
* simple (almost trivial) example of a one-good, one-factor,
* one-consumer economy

$ontext
formulated as an NLP
the first theorem of welfare economics says that a competitive
equilibrium is Pareto optimal
in some very simple situation, such as with a single consumer
this means that equilibrium can also be found as the solution to a
simple NLP: maximizing utility subject to constraints.
$offtext


PARAMETERS
 LBAR    labor supply (fixed and inelastic)
 ALPHA   productivity parameter  X = ALPHA*L;

LBAR = 100;
ALPHA = 2;

* unload data to use in the Julia/JuMP version
EXECUTE_UNLOAD "m2_5_data.gdx" LBAR,ALPHA;
EXECUTE 'python3 ../gdx2json.py --in=m2_5_data.gdx';


NONNEGATIVE VARIABLES
 P         price of X
 X         quantity of X
 W         wage rate
 INCOME    income from labor supply;

VARIABLE
  U;


EQUATIONS
 ZPROFIT      zeroprofits in X production
 CMKTCLEAR    commodity (X) market clearing
 LMKTCLEAR    labor market clearing
 CONSINCOME   consumer income balance
 OBJECTIVE    utility;


ZPROFIT..    W/ALPHA =G= P;

CMKTCLEAR..  X =G= INCOME/P;

LMKTCLEAR..  LBAR =G= X/ALPHA;

CONSINCOME.. INCOME =G= W*LBAR;

OBJECTIVE..  U =E= X**0.5;


MODEL GE_NLP / OBJECTIVE, ZPROFIT, CMKTCLEAR, LMKTCLEAR, CONSINCOME/;


* set some starting values
P.L = 1;
W.L = 1;
X.L = 200;
INCOME.L = 100;

* choose a numeraire
W.FX = 1;

OPTION NLP=IPOPT;
SOLVE GE_NLP USING NLP MAXIMIZING U;

PARAMETER report(*,*);

report('bmk',"X") = X.L;
report('bmk',"P") = P.L;
report('bmk',"W") = W.L;
report('bmk',"INCOME") = INCOME.L;
report('bmk',"U") = U.L;


* double labor productivity
ALPHA = 4;
SOLVE GE_NLP USING NLP MAXIMIZING U;

report('solve_2',"X") = X.L;
report('solve_2',"P") = P.L;
report('solve_2',"W") = W.L;
report('solve_2',"INCOME") = INCOME.L;
report('solve_2',"U") = U.L;



* change numeraire
W.UP = +INF;
W.LO = 0;
P.FX = 1;

ALPHA = 2;
SOLVE GE_NLP USING NLP MAXIMIZING U;

report('solve_3',"X") = X.L;
report('solve_3',"P") = P.L;
report('solve_3',"W") = W.L;
report('solve_3',"INCOME") = INCOME.L;
report('solve_3',"U") = U.L;


* double labor productivity
ALPHA = 4;
SOLVE GE_NLP USING NLP MAXIMIZING U;

report('solve_4',"X") = X.L;
report('solve_4',"P") = P.L;
report('solve_4',"W") = W.L;
report('solve_4',"INCOME") = INCOME.L;
report('solve_4',"U") = U.L;

EXECUTE_UNLOAD 'm2_5_soln.gdx';
