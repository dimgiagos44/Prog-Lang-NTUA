empty_stack([]).
    % member_stack tests if an element is a member of a stack

empty_stack([]).
    % member_stack tests if an element is a member of a stack

member_stack(E, S) :- member(E, S).

    % stack performs the push, pop and peek operations
    % to push an element onto the stack
        % ?- stack(a, [b,c,d], S).
    %    S = [a,b,c,d]
    % To pop an element from the stack
    % ?- stack(Top, Rest, [a,b,c]).
    %    Top = a, Rest = [b,c]
    % To peek at the top element on the stack
    % ?- stack(Top, _, [a,b,c]).
    %    Top = a

stack(E, S, [E|S]).

% FIFO Queue implementation
fifo_empty(Q):-
    empty_assoc(X),
    Q = (-1, -1, X).

% fifo_insert(Q1, X, Q2)
% makes a new FIFO queue Q2, which is Q1 with X inserted
fifo_insert((-1, -1, A), X, Q2):-
    put_assoc(0, A, X, NewTree),
    Q2 = (0, 1, NewTree),
    !.

fifo_insert((Head, Tail, T), X, Q2):-
    NewTail is Tail + 1,
    put_assoc(Tail, T, X, NewT),
    Q2 = (Head, NewTail, NewT),
    !.

fifo_insert_list(Q1, [], Q2):-
    Q2 = Q1.

fifo_insert_list(Q1, [Head | Rest], Q2):-
    fifo_insert(Q1, Head, Q_),
    !,
    fifo_insert_list(Q_, Rest, Q2),
    !.

% fifo_pop(Q1,X,Q2)
% Pops an item from Q1.
% X is the item popped and Q2 is the remaining queue
% Returns false if Q1 is empty.
fifo_pop((Head, Tail, T), X, Q2):-
    Head =\= Tail,
    del_assoc(Head, T, X, NewT),
    NewHead is Head + 1,
    Q2 = (NewHead, Tail, NewT),
    !.

fifo_ordered2_loop(Q2, _):-
    fifo_isEmpty(Q2).

fifo_ordered2_loop((Head, Tail, T), X):-
    Head =\= Tail,
    get_assoc(Head, T, Y),
    NewHead is Head+1,
    Q2 = (NewHead, Tail, T),
    X =< Y,
    fifo_ordered2_loop(Q2, Y).

fifo_ordered2((Head, Tail, T)):-
    Head =\= Tail,
    get_assoc(Head, T, X),
    NewHead is Head + 1,
    Q2 = (NewHead, Tail, T),
    fifo_ordered2_loop(Q2, X),
    !.


% fifo_isEmpty(Q)
% Is true if Q is empty
fifo_isEmpty((Head,Tail,_)) :-
  Head =:= Tail.

fifo_ordered_loop(Q2, _):-
    fifo_isEmpty(Q2).
fifo_ordered_loop(Q2, X):-
    fifo_pop(Q2, Y, Q3),
    X =< Y,
    fifo_ordered_loop(Q3, Y).

fifo_ordered(Q):-
    fifo_isEmpty(Q),
    !.
fifo_ordered(Q1):-
    fifo_pop(Q1, X, Q2),
    fifo_ordered_loop(Q2, X),
    !.


nodeNotVisited(Queue, Stack, Parent):-
    \+ get_assoc((Queue, Stack), Parent, _).


%[Queue, Stack] is the current node
%Parent is the assoc list we use to keep track of
%visited nodes and their parents.
findNeighbors3(Queue, Stack, Parent, Neighbors, NewParent):-
    (
         \+ empty_stack(Stack) ->
             (
              stack(TopElem, Stack1, Stack),
              fifo_pop(Queue, Element, _),
              \+ TopElem = Element,
              fifo_insert(Queue, TopElem, Queue1),
              nodeNotVisited(Queue1, Stack1, Parent) ->
                          Res1 = [(Queue1, Stack1)],
                          put_assoc((Queue1, Stack1), Parent, ('S', Queue, Stack), Parent_)
                          ;
                          Res1 = [],
                          Parent_ = Parent
             )
             ;
             Res1 = [],
             Parent_ = Parent
     ),
     (
          \+ fifo_isEmpty(Queue) ->
              (
                fifo_pop(Queue, Element, Queue2),
                stack(Element, Stack, Stack2),
                nodeNotVisited(Queue2, Stack2, Parent_) ->
                        Neighbors = [(Queue2, Stack2) | Res1],
                        put_assoc((Queue2, Stack2), Parent_, ('Q', Queue, Stack), NewParent)
                        ;
                        Neighbors = Res1,
                        NewParent = Parent_
              )
              ;
              Neighbors = Res1,
              NewParent = Parent_
      ).

isAnswer(Queue, Stack):-
    empty_stack(Stack),
    fifo_ordered(Queue),
    !.

checkForAnswer([], Ans, A):-
    A = -1,
    Ans = (-73, -73).

checkForAnswer([H|L], Ans, A):-
    (Queue, Stack) = H,
    (
        isAnswer(Queue, Stack) ->
          Ans = H,
          A = 1
          ;
          checkForAnswer(L, Ans, A)
     ).

findPath((-73, -73), _, Acc, Answer):-
    atomic_list_concat(Acc, Answer).

findPath((Queue, Stack), Parent, Acc, Answer):-
    get_assoc((Queue, Stack), Parent, (Move, ParentQueue, ParentStack)),
    (
        (ParentQueue, ParentStack) = (-73, -73) ->
         findPath((-73, -73), Parent, Acc, Answer)
    ;
         findPath((ParentQueue, ParentStack), Parent, [Move|Acc], Answer)
    ).

bfs(Queue, Stack, Answer):-
    (
        isAnswer(Queue, Stack) ->
          Answer = 'empty'
    ;
        empty_assoc(X),
        put_assoc((Queue, Stack), X, ('start', -73, -73), Parent),
        fifo_empty(Q),
        fifo_insert(Q, (Queue, Stack), Q1),
        bfsLoop(Q1, Parent, Answer)
    ).

bfsLoop(Q, _, Answer):-
    fifo_isEmpty(Q),
    Answer = 'empty'.

bfsLoop(Q, Parent, Answer):-
    fifo_pop(Q, (Queue, Stack), Q_),
    findNeighbors3(Queue, Stack, Parent, Neighbors, NewParent),
    %reverse(Neighbors, RevNeighbors),
    checkForAnswer(Neighbors, Node, FoundAnswer),
    (
        FoundAnswer =:= 1 ->
         findPath(Node, NewParent, [], Answer),
         !
         ;
         fifo_insert_list(Q_, Neighbors, NewQ),
         !,
         bfsLoop(NewQ, NewParent, Answer)
    ).

solver(List, Answer):-
    fifo_empty(E),
    fifo_insert_list(E, List, Queue),
    bfs(Queue, [], Answer).



read_input(File, N, Queue) :-
    open(File, read, Stream),
    read_line(Stream, [N]),
    read_line(Stream, Queue).

read_line(Stream, L):-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

qssort(File, Answer):-
    read_input(File, _, Queue),
    statistics(walltime, [ _ | [_]]),
    solver(Queue, Answer),
    statistics(walltime, [ _ | [ExecutionTime]]),
    write('Exec = '),
    write(ExecutionTime),
    writeln(' ms').
