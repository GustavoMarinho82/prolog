:- encoding(utf8). % para poder usar o acento

% FATOS
pai(pablo_escobar, sebastian).
pai(pablo_escobar, manuela).
pai(abel, pablo_escobar).

mae(tata, sebastian).
mae(tata, manuela).
mae(hermilda, pablo_escobar).

% REGRA
avô(X, Y) :- pai(X, Z), (pai(Z, Y); mae(Z, Y)).
avó(X, Y) :- mae(X, Z), (pai(Z, Y); mae(Z, Y)).

% OU
% avô(X, Y) :- pai(X, Z), pai(Z, Y).
% avô(X, Y) :- pai(X, Z), mae(Z, Y).
% avó(X, Y) :- mae(X, Z), pai(Z, Y).
% avó(X, Y) :- mae(X, Z), mae(Z, Y).

% OU
% progenitor(X, Y) :- pai(X, Y).
% progenitor(X, Y) :- mae(X, Y).
%
% avô(X, Y) :- pai(X, Z), progenitor(X, Y).
% avó(X, Y) :- mae(X, Z), progenitor(X, Y).