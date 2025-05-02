:- use_module(graphe).
:- consult('utils.pl').
:- consult('colors.pl').

% Main Welsh-Powell entry point
mainWP :-
    colors(Colors),
    getNodes(Nodes),
    sort_by_degree(Nodes, SortedNodes),
    color_nodes_welsh(SortedNodes, Colors, [], Coloring),
    writeln("Coloring found:"),
    writeln(Coloring).

% Assign colors
color_nodes_welsh([], _, Acc, Acc).
color_nodes_welsh([Node | Rest], Colors, Acc, Result) :-
    exclude(is_adjacent(Node, Acc), Colors, Available),
    Available = [Color | _],
    color_nodes_welsh(Rest, Colors, [(Node, Color) | Acc], Result).

% Check if Color is used by a neighbor of Node
is_adjacent(Node, Coloring, Color) :-
    neighbor(Node, N),
    member((N, Color), Coloring).
