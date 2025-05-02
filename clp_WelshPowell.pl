:- use_module(library(clpfd)).
:- use_module(graphe).
:- consult('utils.pl').

mainWP_CLP :-
    getNodes(Nodes),
    length(Nodes, N),
    length(Vars, N),
    Vars ins 1..N,  % Maximum of N colors

    % Apply constraints: no same color for adjacent nodes
    constrain_neighbors(Nodes, Vars),

    labeling([ff], Vars),  % 'ff' = first-fail heuristic

    assign_colors(Nodes, Vars, Coloring),
    writeln("Coloring found (Welsh-Powell + CLP):"),
    writeln(Coloring).

% Impose constraints for all neighbor pairs
constrain_neighbors([], []).
constrain_neighbors([Node | RestNodes], [Var | RestVars]) :-
    constrain_node_neighbors(Node, Var, RestNodes, RestVars),
    constrain_neighbors(RestNodes, RestVars).

% Ensure Nodes color differs from each neighbors
constrain_node_neighbors(_, _, [], []).
constrain_node_neighbors(Node, Var, [OtherNode | RestNodes], [OtherVar | RestVars]) :-
    (neighbor(Node, OtherNode) ->
        Var #\= OtherVar
    ; true),
    constrain_node_neighbors(Node, Var, RestNodes, RestVars).

% Pair nodes with their color values
assign_colors([], [], []).
assign_colors([N | Ns], [V | Vs], [(N, ColorName) | Rest]) :-
    color_name(V, ColorName),
    assign_colors(Ns, Vs, Rest).

% Map integers to color names
color_name(1, red).
color_name(2, green).
color_name(3, blue).
color_name(4, yellow).
color_name(5, purple).
color_name(6, orange).
color_name(_, unknown).
