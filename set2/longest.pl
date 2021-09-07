read_input(File, N, K, C) :-
    open(File, read, Stream),
    read_line(Stream, [N, K]),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).


mult(Xs, Ys) :- 
    maplist(mult(-1), Xs, Ys).
mult(N, X, Y) :- 
    Y is X*N.

subs([], [], _).
subs([X|Y], [X1|Y1], Sub) :- X1 is X-Sub, subs(Y, Y1, Sub).

find_minim([], [], _).
find_minim([X|Y], [X1|Y1], Sum) :- X1 is min(Sum, X), find_minim(Y, Y1, X1).

find_maxim([], [], _).
find_maxim([X|Y], [X1|Y1], Sum) :- X1 is max(Sum, X), find_maxim(Y, Y1, X1).


prefix_sum([], [], _). 
prefix_sum([X|Y], [X1|Y1], Sum) :- 
    X1 is Sum + X, prefix_sum(Y, Y1, X1).

maxDiff([],_,_,_,Longest,_,_,S) :-
    /*writeln('first out'), */ 
    S is Longest.

maxDiff(_, [],I,J, Longest, N, _,S) :-  
    J =:= N,
    /*writeln('J =:= N'), */ 
    Dif is J-I,
    S is max(Longest,Dif).
    


maxDiff(_, [],_,J, Longest, N, _,S) :-
    J =\= N,   
    /*writeln('J != N'), */ 
    S is Longest. 

maxDiff([X|Y], [K|L], I,J, Longest, N, Dif ,S) :-
    X >= K,  
    NewI is I+1,
    /*writeln('I++') , */
    maxDiff(Y, [K|L], NewI , J, Longest, N, Dif,S).

maxDiff([X|Y], [K|L], I, J, Longest, N, _, S) :-
    X < K,
    /*writeln('J++'), */ 
    NewDif is J-I,
    NewJ is J+1,
    NewLongest is max(Longest, NewDif), 
    maxDiff([X|Y], L, I, NewJ, NewLongest, N, NewDif,S).

longest(File,Answer):-
    read_input(File,N,K,C),
    mult(C,C1),
    subs(C1,C2,K),
    prefix_sum(C2,C3,0),
    find_minim(C3, LMin,0),
    reverse(C3, C4),
    find_maxim(C4, C5,-100000000000000),
    reverse(C5,RMax),
    maxDiff(LMin, RMax, 0, 0, -1, N, 0, Answer).
