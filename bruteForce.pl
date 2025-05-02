:- use_module(graphe).
:- consult('utils.pl').
:- consult('colors.pl').

% Depth First Brute Force
assign_colors_bf([], [], _).
assign_colors_bf([Node | RestNodes], [(Node, Color) | ColoringRest], Colors) :-
    assign_colors_bf(RestNodes, ColoringRest, Colors),
    member(Color, Colors),
    safe(Node, Color, ColoringRest).


mainBF :-
    colors(Colors),

    getNodes(Nodes),
    writeln("Nodes : "),
    writeln(Nodes),

    (assign_colors_bf(Nodes, Coloring, Colors) ->
        writeln('Coloring found:'),
        writeln(Coloring)
    ;
        writeln('Not enough colors to color the graph.')
    ).
