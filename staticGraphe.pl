edge(a, b).
edge(a, c).
edge(a, d).
edge(a, e).
edge(b, c).
edge(b, d).
edge(b, e).
edge(c, d).
edge(c, e).
edge(d, e).

getNodes(Result) :-
    findall(Node, (edge(Node, _) ; edge(_, Node)), All),
    sort(All, Result).  % Sort ensures uniqueness

neighbor(X, Y) :- edge(X, Y) ; edge(Y, X).