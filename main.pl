% Import all algorithm files
:- consult('bruteForce.pl').        % mainBF
:- consult('MRV.pl').               % mainMRV
:- consult('welshPowell.pl').       % mainWP
:- consult('clp_WelshPowell.pl').    % mainWP_CLP


% Number of runs per algorithm (for averaging)
num_runs(1000).

% Run a goal N times
run_many_times(_, 0) :- !.
run_many_times(Goal, N) :-
    (Goal -> true ; true),  % goal may fail, that's okay
    N1 is N - 1,
    run_many_times(Goal, N1).

% Run and time a goal N times, return average time
time_goal(Goal, AvgTime) :-
    num_runs(Runs),
    statistics(walltime, [Start|_]),
    run_many_times(Goal, Runs),
    statistics(walltime, [End|_]),
    Time is End - Start,
    AvgTime is Time / Runs.

% Run all algorithms, store and print their times
run_mains :-
    time_goal(mainBF, TimeBF),
    format('--- Running BruteForce ---~nAverage time: ~2f ms~n~n', [TimeBF]),

    time_goal(mainMRV, TimeMRV),
    format('--- Running MRV ---~nAverage time: ~2f ms~n~n', [TimeMRV]),

    time_goal(mainWP, TimeWP),
    format('--- Running Welsh-Powell ---~nAverage time: ~2f ms~n~n', [TimeWP]),

    time_goal(mainWP_CLP, TimeWP_CLP),
    format('--- Running Welsh-Powell with CLP(FD) ---~nAverage time: ~2f ms~n~n', [TimeWP_CLP]),

    % Final summary line
    format('--- Summary (avg times over ~d runs) ---~n', [100]),
    format('BruteForce: ~2f ms | MRV: ~2f ms | WP: ~2f ms | WP_CLP: ~2f ms~n',
           [TimeBF, TimeMRV, TimeWP, TimeWP_CLP]).

% Entry point
:- initialization(run_mains).



