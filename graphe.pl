:- module(graphe, [load_graph/1, print_graph/0, getNodes/1, neighbor/2, node/1, edge/2]).

:- use_module(library(http/json)).
:- dynamic edge/2.
:- dynamic node/1.

:- initialization(load_graph('graphe.json')).

load_graph(File) :-
    retractall(edge(_, _)),
    retractall(node(_)),
    open(File, read, Stream),
    json_read_dict(Stream, Dict),
    close(Stream),
    assert_nodes(Dict.nodes),
    assert_edges(Dict.edges).

assert_nodes([]).
assert_nodes([N | Rest]) :-
    assertz(node(N)),
    assert_nodes(Rest).

assert_edges([]).
assert_edges([[A, B] | Rest]) :-
    assertz(edge(A, B)),
    assertz(edge(B, A)),
    assert_edges(Rest).

getNodes(Result) :-
    findall(N, node(N), All),
    sort(All, Result).

neighbor(X, Y) :- edge(X, Y).
print_graph :-
    getNodes(Nodes),
    forall(member(Node, Nodes), print_node_neighbors(Node)).

print_node_neighbors(Node) :-
    findall(Neighbor, neighbor(Node, Neighbor), Neighbors),
    sort(Neighbors, Sorted),
    format('Node ~w has neighbors: ~w~n', [Node, Sorted]).
