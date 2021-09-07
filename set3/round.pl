read_input(File, N, K, C) :-
    open(File, read, Stream),
    read_line(Stream, [N, K]),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

removehead([_|T],T).

cityList([],[K], Helper, Counter,Size):-
    Size =:= Helper,
    K is Counter.

cityList([],[K|L], Helper, Counter,Size):-
    Size =\= Helper,
    Helper1 is Helper+1,
    K is Counter,
    cityList([],L, Helper1, 0, Size).

cityList([H|T], [K|L], Helper, Counter,Size):-
    H=:=Helper,
    Counter1 is Counter+1,
    cityList(T, [K|L], Helper,Counter1,Size).

cityList([H|T], [K|L], Helper, Counter,Size):-
    H=\=Helper,
    Helper1 is Helper+1,
    K is Counter,
    cityList([H|T], L, Helper1, 0,Size).

calc_pos([],_, _, _, _, MinSum, MinPos,_,_,_,_,_,_,_,_,L1,L2):-
    L1 is MinSum,
    L2 is MinPos.

calc_pos([H|T],[K|L], MainPointer, MaxPointer, HelpPointer, MinSum, MinPos,Max,Sum,Cars,Cities,Helper,Candidate,Flag,Metro,L1,L2):-
    (MainPointer =:= MaxPointer; HelpPointer =:= MaxPointer; K=:=0),
    MaxPointer1 is MaxPointer+1,
    calc_pos([H|T], L, MainPointer, MaxPointer1, HelpPointer, MinSum, MinPos,Max,Sum,Cars,Cities,Helper,Candidate,Flag,Metro,L1,L2).

calc_pos([H|T],[K|L], MainPointer, MaxPointer, HelpPointer, MinSum, MinPos,_,Sum,Cars,Cities ,_,_,Flag,Metro,L1,L2):-
    K=\=0,
    Max1 is HelpPointer-MaxPointer,
    Helpp is (Cars - (Cities*H))*Flag,
    Candidate1 is (Sum + Helpp),
    Helper1 is (Candidate1+1)/2,
    appropriate([H|T], [K|L], MainPointer, MaxPointer,HelpPointer, MinSum, MinPos,Max1,Sum,Cars,Cities,Helper1,Candidate1,1,Metro,L1,L2).

appropriate([_|T], [K|L], MainPointer, MaxPointer,HelpPointer, _, MinPos,Max,_,Cars,Cities,Helper,Candidate,Flag,Metro,L1,L2):-
    Helper >= Max,
    MinSum1 is min(Metro, Candidate),  
    change_pos(MinSum1,Metro,MinPos,MainPointer,MinPos1),
    MainPointer1 is MainPointer+1,
    HelpPointer1 is HelpPointer+1,
    calc_pos(T, [K|L], MainPointer1, MaxPointer, HelpPointer1, MinSum1, MinPos1 ,Max,Candidate,Cars,Cities,Helper,Candidate,Flag,MinSum1,L1,L2).

appropriate([_|T], [K|L], MainPointer, MaxPointer,HelpPointer, MinSum, MinPos,Max,_,Cars,Cities,Helper,Candidate,Flag,Metro,L1,L2):-
    Helper < Max,
    MainPointer1 is MainPointer+1,
    HelpPointer1 is HelpPointer+1,
    calc_pos(T, [K|L], MainPointer1, MaxPointer,HelpPointer1, MinSum, MinPos,Max,Candidate,Cars,Cities,Helper,Candidate,Flag,Metro,L1,L2).


change_pos(MinSum,Metro,MinPos,MainPointer,NewPosition):-
    (MinSum =:= Metro ->
    NewPosition is MinPos;
    NewPosition is MainPointer).

first_sum([],_,_,Sum,Sum).

first_sum([H|L], N, Acc, Flag, Sum):-
    Helper is (N-Acc)*H,
    Sum1 is Flag+Helper,
    Acc1 is Acc+1,
    first_sum(L, N, Acc1, Sum1, Sum).

round(File,M,C):-
    read_input(File,Cit,Cars,Circle),
    msort(Circle,Circles),
    Cities is Cit-1,
    cityList(Circles, CityL, 0,0, Cities),
    append(CityL,CityL,MaxCity),
    removehead(CityL, Helper),
    first_sum(Helper,Cit,1,0,Sum),
    calc_pos(CityL, MaxCity, 0, 0, Cit, 0, 0, 0,Sum,Cars,Cit ,0,0,0,10000000000,M,C), !.
