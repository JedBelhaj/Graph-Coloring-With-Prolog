:- use_module(graphe).
:- consult('utils.pl').
:- consult('colors.pl').

% Depth First Brute Force with MRV heuristic
assign_colors_mrv([], [], _).
assign_colors_mrv([Node | RestNodes], [(Node, Color) | ColoringRest], Colors) :-
    assign_colors_mrv(RestNodes, ColoringRest, Colors),
    member(Color, Colors),
    safe(Node, Color, ColoringRest).


mainMRV :-
    colors(Colors),

    getNodes(Nodes),
    writeln("Nodes : "),
    writeln(Nodes),

    sort_by_degree(Nodes, SortedNodes),
    writeln("Sorted (by degree) : "),
    writeln(SortedNodes),

    (assign_colors_mrv(SortedNodes, Coloring, Colors) ->
        writeln('Coloring found:'),
        writeln(Coloring)
    ;
        writeln('Not enough colors to color the graph.')
    ).