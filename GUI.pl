:- use_module(library(pce)).
:- use_module(library(http/json)).
:- dynamic edge/2.
:- dynamic node/1.
:- dynamic node_position/3.

% GUI initialization
start_gui :-
    new(Window, dialog('Graph Creator')),
    send(Window, size, size(500, 450)),

    % Picture area to draw graph
    new(Picture, picture),
    send(Picture, size, size(500, 300)),
    send(Window, append, Picture),

    % Input fields
    new(NodeInput, text_item('Node')),
    send(Window, append, NodeInput),

    new(EdgeInput, text_item('Edge (format: A-B)')),
    send(Window, append, EdgeInput),

    % Buttons
    new(AddNodeButton, button('Add Node',
        message(@prolog, add_node, NodeInput?selection, Picture))),
    send(Window, append, AddNodeButton),

    new(AddEdgeButton, button('Add Edge',
        message(@prolog, add_edge, EdgeInput?selection, Picture))),
    send(Window, append, AddEdgeButton),

    new(FinishButton, button('Finish (Export JSON)',
        message(@prolog, export_graph_json))),
    send(Window, append, FinishButton),

    new(LoadButton, button('Load (From JSON)',
        message(@prolog, load_graph, Picture))),
    send(Window, append, LoadButton),

    send(Window, open).

% Add node if it doesn't already exist
add_node(NodeName, Picture) :-
    (   NodeName \= "",
        \+ node(NodeName)
    ->  random_between(50, 450, X),
        random_between(50, 250, Y),
        assertz(node(NodeName)),
        assertz(node_position(NodeName, X, Y)),
        draw_graph(Picture)
    ;   new(Msg, text('Node exists or name is empty!')),
        send(Msg, colour, red),
        send(Picture, display, Msg, point(150, 150))
    ).

% Add edge if valid and not duplicate
add_edge(EdgeText, Picture) :-
    (   EdgeText \= "",
        split_string(EdgeText, "-", "", [NodeA, NodeB]),
        NodeA \= "", NodeB \= "",
        atom_string(A, NodeA),
        atom_string(B, NodeB),
        A \= B,
        node(A),
        node(B),
        \+ edge(A, B)
    ->  assertz(edge(A, B)),
        assertz(edge(B, A)),
        draw_graph(Picture)
    ;   new(Msg, text('Invalid or duplicate edge!')),
        send(Msg, colour, red),
        send(Picture, display, Msg, point(120, 150))
    ).


% Draw the entire graph
draw_graph(Picture) :-
    send(Picture, clear),
    findall(Node, node(Node), Nodes),
    draw_nodes(Nodes, Picture),
    findall([A, B], edge(A, B), Edges),
    draw_edges(Edges, Picture),
    send(Picture, flush).

% Draw nodes
draw_nodes([], _).
draw_nodes([Node | Rest], Picture) :-
    get_node_position(Node, X, Y),
    new(Ellipse, ellipse(40, 40)),
    send(Ellipse, fill_pattern, colour(white)),
    send(Picture, display, Ellipse),
    send(Ellipse, move, point(X, Y)),

    new(Text, text(Node)),
    send(Text, font, font(helvetica, bold, 14)),
    send(Text, colour, black),
    send(Picture, display, Text),
    send(Text, move, point(X + 10, Y + 10)),

    draw_nodes(Rest, Picture).

% Draw edges
draw_edges([], _).
draw_edges([[NodeA, NodeB] | Rest], Picture) :-
    get_node_position(NodeA, X1, Y1),
    get_node_position(NodeB, X2, Y2),
    new(Line, line(X1 + 20, Y1 + 20, X2 + 20, Y2 + 20)),
    send(Line, colour, blue),
    send(Picture, display, Line),
    draw_edges(Rest, Picture).

% Get node position
get_node_position(Node, X, Y) :-
    node_position(Node, X, Y).

% Export graph to JSON file
export_graph_json :-
    findall(N, node(N), Nodes),
    findall([A, B], (edge(A, B), A @< B), UniqueEdges),  % avoid duplicates
    Graph = json([nodes=Nodes, edges=UniqueEdges]),
    open('graphe.json', write, Stream),
    json_write(Stream, Graph),
    close(Stream),
    send(@display, inform, 'Graph saved to graphe.json').

load_graph(Picture) :-
    exists_file('graphe.json'),
    open('graphe.json', read, Stream),
    json_read_dict(Stream, Dict),
    close(Stream),

    % Clear current graph state
    retractall(node(_)),
    retractall(edge(_, _)),
    retractall(node_position(_, _, _)),

    % Load nodes
    Nodes = Dict.nodes,
    forall(member(N, Nodes), (
        atom_string(NodeAtom, N),
        assertz(node(NodeAtom)),
        random_between(50, 450, X),
        random_between(50, 250, Y),
        assertz(node_position(NodeAtom, X, Y))
    )),

    % Load edges
    Edges = Dict.edges,
    forall(member([A0, B0], Edges), (
        atom_string(A, A0),
        atom_string(B, B0),
        A \= B,
        \+ edge(A, B)
    ->  assertz(edge(A, B)),
        assertz(edge(B, A))
    ;   true
    )),

    draw_graph(Picture),
    send(@display, inform, 'Graph loaded successfully.').

load_graph(_) :-
    send(@display, inform, 'graphe.json file not found.').


% Start GUI at load
:- start_gui.
