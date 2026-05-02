:- set_prolog_flag(encoding, utf8).	% Permite o uso de caracteres UTF-8

% HELP
help_derivacao :- nl,
    write('| Para calcular a derivada DU da expressão U em relação a expressão X, digite d(U, X, DU).'), nl,
    write('| Não passe as expressões de U e X com as variáveis em maiúsculo (como d(2*X, X, DU)), pois senão o Prolog irá'), nl,
	write('| interpretá-los como variáveis na ótica de programação, resultando em comportamento inesperado.'), nl,
	write('| Exemplo de uso: d(2*x, x, DU), d(x + y, y, DV)'), nl, nl.

:- initialization(help_derivacao).

% REGRAS DE SIMPLIFICAÇÃO BOTTOM-UP
descer_e_simplificar(-U, ESimplificado) :-
	!,
    descer_e_simplificar(U, USimplificado),
    simplificar(-USimplificado, ESimplificado).

descer_e_simplificar(E, ESimplificado) :- 
	E =.. [Operador, U, V],					% Desconstroi a expressao
	member(Operador, [+, -, *, /, //, ^]),	% Confere se o functor de E é um dos operadores da lista
	!,
	descer_e_simplificar(U, USimplificado),
	descer_e_simplificar(V, VSimplificado),
	EIntermediario =.. [Operador, USimplificado, VSimplificado],
	simplificar(EIntermediario, ESimplificado).

% Só executa quando U é atômico ou contem um operador não listado no member acima
descer_e_simplificar(U, U).

% REGRAS DE SIMPLIFICAÇÃO MOLECULARES
simplificar(-0, 0) :- !.
simplificar(-(-U), U) :- !.

simplificar(U * 0, 0) :- !.
simplificar(0 * U, 0) :- !.

simplificar(1 * U, U) :- !.
simplificar(U * 1, U) :- !.

simplificar(U + 0, U) :- !.
simplificar(0 + U, U) :- !.

simplificar(U - 0, U) :- !.
simplificar(0 - U, -U) :- !.
simplificar(U - U, 0) :- !.

simplificar(U / 1, U) :- !.

simplificar(U^0, 1) :- !.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Simplificar 1 + 2
simplificar(U^X, 1 / U^Y) :- 
	number(X),
	X < 0,
	!,
	Y is -X.

simplificar(U^X * U^Y, U^Z) :- 
	number(X),
	number(Y),
	!,
	Z is X + Y.

simplificar(U + U, 2 * U) :- !.
simplificar(U * U, U^2) :- !.

simplificar(U, U).

% REGRA PRINCIPAL
d(U, X, DU) :-
	derivada(U, X, DUBruto),
	simplificar(DUBruto, DU).

% REGRAS DE DERIVAÇÃO
% Derivação de uma constante ou em relação a uma constante
derivada(U, X, 0) :- 
	( number(U) ; number(X) ),	% ( ; ) é um OU
	!.

% Derivação de uma expressão em relacao a ela mesma
derivada(U, X, 1) :- 
	atom(U), 
	U == X, 
	!.

% Derivação de uma expressão multiplicada por uma constante C
derivada(C * U, X, C * DU) :- 
	number(C), 
	!,
	derivada(U, X, DU).

derivada(U * C, X, C * DU) :- 
	number(C),
	!,
	derivada(U, X, DU).

% Derivação de uma soma
derivada(U + V, X, DU + DV) :-
	!,
	derivada(U, X, DU),
	derivada(V, X, DV).

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

% Caso final, onde a expressão não é diferenciável em relação a x
derivada(U, _, 0) :- atom(U).