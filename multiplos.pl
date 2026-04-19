% REGRAS
multiplo(X, Y) :- 0 is X mod Y.	% Checa se (X % Y) eh igual a 0

multiplo_6(X) :-		% Confere se X eh multiplo de 6. O que acontece quando:
	multiplo(X, 2),		% 1 - X eh multiplo de 2; e
	multiplo(X, 3).		% 2 - X eh multiplo de 3.

multiplos_6(I, F, Lista) :-
	findall(X, 								% Encontra todos os X que
		(between(I, F, X), multiplo_6(X)), 	% estao entre I e F, e sao multiplos de 6
		Lista).								% e salva eles em Lista