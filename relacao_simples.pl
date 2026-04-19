% FATOS
professor(francisco).			% francisco eh um professor
professor(alexandre).			% alexandre eh um professor
aluno(gustavo).					% gustavo eh um aluno
aluno(cristian).				% cristian eh um aluno
aluno(pedro).					% pedro eh um aluno
disciplina(edl, francisco, 1).	% edl eh uma disciplina dada por francisco na turma 1
disciplina(lp2, alexandre, 2).	% lp2 eh uma disciplina dada por alexandre na turma 2
matriculado(gustavo, edl, 1).	% gustavo esta matriculado em edl turma 1
matriculado(cristian, edl, 1).	% cristian esta matriculado em edl turma 1
matriculado(pedro, lp2, 2).		% pedro esta matriculado em lp2 turma 2

% REGRA
tem_aula_com(Aluno, Professor) :- 				% Regra para checar se um aluno tem aula com tal professor. O que acontece quando:
    matriculado(Aluno, Disciplina, Turma),		% 1 - o aluno esta matricula em Discplina na turma Turma; e
    disciplina(Disciplina, Professor, Turma).	% 2 - professor dá aula da Disciplina na turma Turma