:- set_prolog_flag(encoding, utf8).	% Permite o uso de caracteres UTF-8


%%% HELP %%%

help_derivacao :- nl,
	write('| ========================================================================================================================'), nl,
    write('| Para calcular a derivada DU da expressão U em relação a expressão X, digite d(U, X, DU).'), nl,
    write('| Não passe as expressões de U e X com as variáveis em maiúsculo (como d(2*X, X, DU)), pois senão o Prolog'), nl,
	write('| irá interpretá-los como variáveis na ótica de programação, resultando em comportamento inesperado.'), nl,
	write('| Não são feitas simplificações pesadas nas funções trigonométricas e nas inversas trigonométricas,'), nl,
	write('| gerando outputs maiores que poderiam ser simplificados.'), nl,
	write('| ========================================================================================================================'), nl,
	write('| Digite raizes como raiz(índice, radicando) (também é possível usar sqrt(radicando) em vez de raiz(2, radicando)).'), nl,
	write('| Digite logaritmos normais como log(base, logaritmando) e naturais como ln(logaritmando) ou log(e, logaritmando).'), nl,
	write('| Digite as funções trigonométricas como: sen, cos, tg, cossec, sec, cotg, arcsen, arccos, arctg, arcsec, arccossec, arccotg.'), nl,
	write('| ========================================================================================================================'), nl,
	write('| Exemplos de uso: d(3*x^2 - x, x, DU), d(sen(x^2), x, DV), d(e^(2*y) * ln(y), y, R)'), nl,
	write('| ========================================================================================================================'), nl, nl.

:- initialization(help_derivacao).


%%% REGRAS PARA REFATORAÇÃO %%%

operador_unario(Operador) :- member(Operador, [-, abs, ln, sen, cos, tg, cossec, sec, cotg, arcsen, arccos, arctg, arcsec, arccossec, arccotg]).

operador_binario(Operador) :- member(Operador, [+, -, *, /, //, ^, log]).


%%% REGRAS DE NORMALIZAÇÃO %%%

normalizar(sqrt(U), UNormalizado^(1/2)) :- 
	!,
	normalizar(U, UNormalizado).

normalizar(raiz(I, U), UNormalizado^(1/INormalizado)) :- 
	!,
	normalizar(I, INormalizado),
	normalizar(U, UNormalizado).

normalizar(log(e, U), ln(UNormalizado)) :- 
	!,
	normalizar(U, UNormalizado).

normalizar(sin(U), sen(UNormalizado)) :- 
	!,
	normalizar(U, UNormalizado).

normalizar(tan(U), tg(UNormalizado)) :- 
	!,
	normalizar(U, UNormalizado).

normalizar(E, cossec(UNormalizado)) :- 
	( E = cosec(U) ; E = csc(U) ),
	!,
	normalizar(U, UNormalizado).

normalizar(cotan(U), cotg(UNormalizado)) :- 
	!,
	normalizar(U, UNormalizado).

normalizar(arcsin(U), arcsen(UNormalizado)) :- 
	!,
	normalizar(U, UNormalizado).

normalizar(arctan(U), arctg(UNormalizado)) :- 
	!,
	normalizar(U, UNormalizado).

normalizar(E, arccossec(UNormalizado)) :- 
	( E = arccosec(U) ; E = arccsc(U) ),
	!,
	normalizar(U, UNormalizado).

normalizar(arccotan(U), arccotg(UNormalizado)) :- 
	!,
	normalizar(U, UNormalizado).

% Normaliza operadores unários
normalizar(E, ENormalizado) :- 
	E =.. [Operador, U],
	operador_unario(Operador),
	!,
    normalizar(U, UNormalizado),
	ENormalizado =.. [Operador, UNormalizado].

% Normaliza operadores binários
normalizar(E, ENormalizado) :- 
	E =.. [Operador, U, V],
	operador_binario(Operador),
	!,
    normalizar(U, UNormalizado),
	normalizar(V, VNormalizado),
	ENormalizado =.. [Operador, UNormalizado, VNormalizado].

normalizar(U, U).


%%% REGRAS DE SIMPLIFICAÇÃO BOTTOM-UP %%%

% Simplifica operadores unários
descer_e_simplificar(E, ESimplificado) :-
	E =.. [Operador, U],
	operador_unario(Operador),
	!,
    descer_e_simplificar(U, USimplificado),
	EIntermediario =.. [Operador, USimplificado],
    simplificar(EIntermediario, ESimplificado).

% Simplifica em operadores binários
descer_e_simplificar(E, ESimplificado) :- 
	E =.. [Operador, U, V],
	operador_binario(Operador),
	!,
	descer_e_simplificar(U, USimplificado),
	descer_e_simplificar(V, VSimplificado),
	EIntermediario =.. [Operador, USimplificado, VSimplificado],
	simplificar(EIntermediario, ESimplificado).

descer_e_simplificar(U, U).


%%% REGRAS DE SIMPLIFICAÇÃO MOLECULARES %%%

simplificar(-A, B) :- 
	number(A),
	!,
	B is -A.

simplificar(abs(A), B) :- 
	number(A),
	!,
	B is abs(A).

simplificar(U, V) :-
	U =.. [Operador, A, B],
	number(A),
	number(B),
	member(Operador, [+, -, *, ^]),
	!,
	V is U.

simplificar(A / B, U) :-
	integer(A),
	integer(B),
	B \== 0,
	A mod B =:= 0,	% Evita números quebrados, pro output não ficar feio
	!,
	U is A // B.

simplificar(A * (B * U), C * U) :- 
	number(A), 
	number(B), 
	!, 
	C is A * B.

simplificar(-0, 0) :- !.

simplificar(-(-U), U) :- !.

simplificar(E, 0) :- 
	( E = _ * 0 ; E = 0 * _ ),
	!.

simplificar(E, U) :- 
	( E = 1 * U ; E = U * 1 ),
	!.

simplificar(E, U) :- 
	( E = U + 0 ; E = 0 + U ; E = U - 0 ),
	!.

simplificar(0 - U, -U) :- !.

simplificar(U - U, 0) :- !.

simplificar(E, U) :- 
	( E = U / 1 ; E = U // 1 ),
	!.

simplificar(E, 0) :- 
	( E = 0 / U ; E = 0 // U ),
	U \== 0,	% Indeterminação matemática
	!.

simplificar(U^0, 1) :- 
	U \== 0,	% Indeterminação matemática
	!.

simplificar(U^1, U) :- !.

simplificar(U^A, 1 / U^B) :- 
	number(A),
	A < 0,
	!,
	B is -A.

simplificar(U^A * U^B, U^C) :- 
	number(A),
	number(B),
	!,
	C is A + B.

simplificar((U^A)^B, U^C) :- 
	number(A),
	number(B),
	!,
	C is A * B.

simplificar(U + U, 2 * U) :- !.

simplificar(U * U, U^2) :- !.

simplificar(log(U, U), 1) :- !.

simplificar(ln(e), 1) :- !.

simplificar(C^log(C, U), U) :- !.

simplificar(e^ln(U), U) :- !.

simplificar(U, U).


%%% REGRA PRINCIPAL %%%

d(U, X, DU) :-
	normalizar(U, UNormalizado),
	derivada(UNormalizado, X, DUBruto),
	descer_e_simplificar(DUBruto, DU).


%%% REGRAS DE DERIVAÇÃO %%%

% Derivação de uma constante ou em relação a uma constante
derivada(U, X, 0) :- 
	( number(U) ; number(X) ),
	!.

% Derivação de uma expressão em relacao a ela mesma
derivada(U, X, 1) :- 
	atom(U), 
	U == X, 
	!.

% Derivação de uma expressão multiplicada por uma constante C
derivada(E, X, C * DU) :- 
	( E = C * U; E = U * C),
	number(C), 
	!,
	derivada(U, X, DU).

% Derivação de uma soma
derivada(U + V, X, DU + DV) :-
	!,
	derivada(U, X, DU),
	derivada(V, X, DV).

derivada(U - V, X, DU - DV) :-
	!,
	derivada(U, X, DU),
	derivada(V, X, DV).

% Derivação de um negativo
derivada(-U, X, -DU) :-
    !,
    derivada(U, X, DU).

% Derivação de um produto
derivada(U * V, X, (V * DU) + (U * DV)) :-
	!,
	derivada(U, X, DU),
	derivada(V, X, DV).

% Derivação de uma divisão
derivada(U / V, X, (V * DU - U * DV) / V^2) :-
	!,
	derivada(U, X, DU),
	derivada(V, X, DV).

% Derivação de uma potência
derivada(U^C, X, C * U^(D) * DU) :-
	number(C),
	!,
	D is C - 1,
	derivada(U, X, DU).

% Derivação de uma potência com base constante
derivada(C^U, X, C^U * ln(C) * DU) :-
	number(C),
	C > 0,
	C \== 1,
	!,
	derivada(U, X, DU).

% Derivada de função elevada a função
derivada(U^V, X, U^V * (DV * ln(U) + V * (DU / U))) :-
    !,					% Não é necessário fazer testes para conferir se ambas são funções por causa das regras anteriores
    derivada(U, X, DU),
    derivada(V, X, DV).

% Derivação de uma potência com base número de Euler
derivada(e^U, X, e^U * DU) :-
	!,
	derivada(U, X, DU).

% Derivação de um logaritmo
derivada(log(B, U), X, DU * log(B, e) / U) :-
	number(B),
	B > 0,
	B \== 0,
	!,
	derivada(U, X, DU).

% Derivação de um logaritmo natural
derivada(ln(U), X, DU / U) :-
	!,
	derivada(U, X, DU).

% Derivação das funções trigonométricas
derivada(sen(U), X, cos(U) * DU) :-
	!,
	derivada(U, X, DU).

derivada(cos(U), X, -sen(U) * DU) :-
	!,
	derivada(U, X, DU).

derivada(tg(U), X, sec(U)^2 * DU) :-
	!,
	derivada(U, X, DU).

derivada(cossec(U), X, -cossec(U) * cotg(U) * DU) :-
	!,
	derivada(U, X, DU).

derivada(sec(U), X, sec(U) * tg(U) * DU) :-
	!,
	derivada(U, X, DU).

derivada(cotg(U), X, -cossec(U)^2 * DU) :-
	!,
	derivada(U, X, DU).

% Derivação das inversas trigonométricas
derivada(arcsen(U), X, DU / ((1 - U^2)^(1/2))) :-
	!,
	derivada(U, X, DU).

derivada(arccos(U), X, -DU / ((1 - U^2)^(1/2))) :-
	!,
	derivada(U, X, DU).

derivada(arctg(U), X, DU / (1 + U^2)) :-
	!,
	derivada(U, X, DU).

derivada(arccossec(U), X, -DU / (abs(U) * (U^2 - 1)^(1/2))) :-
    !,
    derivada(U, X, DU).

derivada(arcsec(U), X, DU / (abs(U) * (U^2 - 1)^(1/2))) :-
    !,
    derivada(U, X, DU).

derivada(arccotg(U), X, -DU / (1 + U^2)) :-
	!,
	derivada(U, X, DU).

% Caso final, onde a expressão não é diferenciável em relação a x
derivada(U, _, 0) :- atom(U).