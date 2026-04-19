% Potencia O(n)

% Caso base
potencia(_, 0, 1) :- !. % Caso o expoente seja 0, essa declaracao da regra eh executada e 1 eh retornado como R
						% O ! aqui impede que a execucao da outra declaracao de potencia seja forcada (o que pode ser feito enviando ';' no terminal)

% B = base; E = expoente; R = resultado
potencia(B, E, R) :-
    E2 is E - 1,			% E2 = E-1
    potencia(B, E2, R2),	% Faz a recursao de potencia com o novo expoente e salva o resultado em R2
    R is B * R2.			% R = B * B^(E-1)