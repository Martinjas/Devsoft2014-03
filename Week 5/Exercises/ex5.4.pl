%% Ex 5.4
%% Implementar fatorial em Prolog.
%% Exemplo de query:
%% ?- fat(10, X)
fatorial(x,y):-
	x>0,
	y=fatorial(x-1,y)*x.
	