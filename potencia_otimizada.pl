% Potência O(log n)

% Quando uma regra eh chamada e ela possui varias declaracoes com o mesmo numero de argumentos, o Prolog tenta executar 
% cada uma na ordem em que elas forem declaradas no arquivo. Ate uma regra ter sucesso, ou seja, retornar true

% Caso base
potencia(_, 0, 1) :- !.	% Caso o expoente seja 0, essa declaracao da regra eh executada e 1 eh retornado como R
						% O ! aqui impede que a execucao das outras declaracoes da regra sejam forcadas (o que pode ser feito enviando ';' no terminal)

% B = base; E = expoente; R = resultado
potencia(B, E, R) :-
	E mod 2 =:= 0,			% Verifica se o expoente eh par. Se nao for, o Prolog tenta executar a proxima declaracao de potencia via backtracking automatico, porque essa ja falhou
	!,						% Se ele chegar nessa clausula, o expoente eh par e a recursao vai funcionar. O ! impede que o Prolog tente a outra declaracao de potencia apos essa finalizar
	E2 is E // 2,			% E2 = E / 2
	potencia(B, E2, R2),	% Faz a recursao de potencia com o novo expoente e salva o resultado em R2
	R is R2 * R2.			% R = B^(E/2) * B^(E/2)

potencia(B, E, R) :-
	E2 is E - 1,			% E2 = E-1
	potencia(B, E2, R2),	% Faz a recursao de potencia com o novo expoente e salva o resultado em R2
	R is B * R2.			% R = B * B^(E-1)