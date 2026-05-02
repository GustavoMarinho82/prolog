:- set_prolog_flag(encoding, utf8).	% Permite o uso de caracteres UTF-8

% HELP
help_derivacao :- nl,
    write('| Para calcular a derivada DU da expressão U em relação a expressão X, digite d(U, X, DU).'), nl,
    write('| Não passe as expressões de U e X com as variáveis em maiúsculo (como d(2*X, X, DU)), pois senão o Prolog irá'), nl,
	write('| interpretá-los como variáveis na ótica de programação, resultando em comportamento inesperado.'), nl,
	write('| Exemplo de uso: d(2*x, x, DU), d(x + y, y, DV)'), nl, nl.

:- initialization(help_derivacao).

% REGRAS
% Derivação de uma constante ou em relação a uma constante
d(U, X, 0) :- 
	( number(U) ; number(X) ),	% ( ; ) é um OU
	!.

% Derivação de uma expressão em relacao a ela mesma
d(U, X, 1) :- 
	atom(U), 
	U == X, 
	!.

% Derivação de uma expressão multiplicada por uma constante C
d(C * U, X, C * DU) :- 
	number(C), 
	!,
	d(U, X, DU).

d(U * C, X, C * DU) :- 
	number(C),
	!,
	d(U, X, DU).

% Derivação de uma soma
d(U + V, X, DU + DV) :-
	!,
	d(U, X, DU),
	d(V, X, DV).

% Derivação de um produto
d(U * V, X, V * DU + U * DV) :-
	!,
	d(U, X, DU),
	d(V, X, DV).

% Caso final, onde a expressão não é diferenciável em relação a x
d(U, _, 0) :- atom(U), !.