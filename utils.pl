:- consult('graphe.pl').

safe(_, _, []). % check color compatibility
safe(Node, Color, [(OtherNode, OtherColor) | Rest]) :-
    (neighbor(Node, OtherNode) ->
        Color \== OtherColor  % Ensure the node doesnt share a color with its neighbor
    ;
        true  % No edge to check, continue
    ),
    safe(Node, Color, Rest).  % Continue checking remaining assignments

% Calculate degree (number of neighbors) of each node
node_degree(Node, Degree) :-
    findall(N, neighbor(Node, N), Neighbors),
    sort(Neighbors, Unique),
    length(Unique, Degree).

% Sort nodes by degree descending (Most constrained first)
sort_by_degree(Nodes, Sorted) :-
    map_list_to_pairs(node_degree, Nodes, Pairs),
    keysort(Pairs, Asc),
    reverse(Asc, Desc),
    pairs_values(Desc, Sorted).

cls :- write('\e[H\e[2J'). % clear terminal

inc(X, X1) :-
    X1 is X+1.

assign_numbers([], [], _). % for testing purposes
assign_numbers([Node | Rest], [(Node, Number) | RestAssignments], CurrentNumber) :-
    Number = CurrentNumber, % Assign the current number to the node
    NextNumber is CurrentNumber + 1, % Increment the number
    assign_numbers(Rest, RestAssignments, NextNumber).