% Import the graph from graphe.pl
:- consult('graphe.pl').

cls :- write('\e[H\e[2J').

inc(X, X1) :-
    X1 is X+1.

assign_numbers([], [], _).
assign_numbers([Node | Rest], [(Node, Number) | RestAssignments], CurrentNumber) :-
    Number = CurrentNumber, % Assign the current number to the node
    NextNumber is CurrentNumber + 1, % Increment the number
    assign_numbers(Rest, RestAssignments, NextNumber).

% Depth First Brute Force
assign_colors([], [], _).
assign_colors([Node | RestNodes], [(Node, Color) | ColoringRest], Colors) :-
    assign_colors(RestNodes, ColoringRest, Colors),
    member(Color, Colors),
    safe(Node, Color, ColoringRest).



safe(_, _, []).
safe(Node, Color, [(OtherNode, OtherColor) | Rest]) :-
    (neighbor(Node, OtherNode) ->
        Color \== OtherColor  % Ensure the node doesnt share a color with its neighbor
    ;
        true  % No edge to check, continue
    ),
    safe(Node, Color, Rest).  % Continue checking remaining assignments

getNodes(Result) :-
    findall(Node, (edge(Node, _) ; edge(_, Node)), All),
    sort(All, Result).  % Sort ensures uniqueness

main :-
    Colors = [red, green, blue, yellow, purple],
    
    getNodes(Nodes),
    writeln("Nodes : "),
    writeln(Nodes),

    (assign_colors(Nodes, Coloring, Colors) ->
        writeln('Coloring found:'),
        writeln(Coloring)
    ;
        writeln('Not enough colors to color the graph.')
    ),

    halt.
