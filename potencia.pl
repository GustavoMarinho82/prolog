% Potencia O(n)

% Caso base
potencia(_, 0, 1) :- !. % Caso o expoente seja 0, essa declaracao da regra eh executada e 1 eh retornado como R
						% O ! aqui impede que a execucao da outra declaracao de potencia seja forcada (o que pode ser feito enviando ';' no terminal)

% B = base; E = expoente; R = resultado
potencia(B, E, R) :-
	E < 0,					% Verifica se E eh negativo. Se nao for, o Prolog tenta executar a proxima declaracao de potencia via backtracking automatico, porque essa ja falhou
	!,						% Se ele chegar nessa clausula, o expoente eh menor que 0 e a recursao vai funcionar. O ! impede que o Prolog tente a outra declaracao de potencia apos essa finalizar
	B2 is 1 / B,			% B2 = 1 / B
	E2 is -E,				% E2 = -E
	potencia(B2, E2, R).	% Faz a recursao com potencia(1 / B, -E, R)
	
potencia(B, E, R) :-
	E2 is E - 1,			% E2 = E-1
	potencia(B, E2, R2),	% Faz a recursao de potencia com o novo expoente e salva o resultado em R2
	R is B * R2.			% R = B * B^(E-1)