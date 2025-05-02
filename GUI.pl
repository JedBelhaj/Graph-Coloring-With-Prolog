:- use_module(library(pce)) 
   ; writeln('Error: XPCE library is not available. Please install SWI-Prolog with XPCE support.').


hello_world :-
    new(Window, dialog('Hello Window')),
    new(Button, button('Click Me', message(@prolog, say_hello))),
    send(Window, append, Button),
    send(Window, open).

say_hello :-
    writeln('Hello from Prolog!').