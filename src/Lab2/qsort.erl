%%%-------------------------------------------------------------------
%%% @author Ernest
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. mar 2024 11:48
%%%-------------------------------------------------------------------
-module(qsort).
-author("Ernest").

%% API
-export([qs/1,compare_speeds/3,random_elems/3]).

less_than(List,Arg) -> [X || X <- List, X < Arg].

grt_eq_than(List,Arg) -> [X || X <- List, X >= Arg].

qs([]) -> [];
qs([A]) -> [A];
qs([Pivot|Tail]) -> qs(less_than(Tail,Pivot)) ++ [Pivot]
                          ++ qs(grt_eq_than(Tail,Pivot)).

random_elems(N,Min,Max) -> [random:uniform(Max)+Min || _X <-lists:seq(1,N)].

compare_speeds(List,Fun1,Fun2) ->
  {T1,_A} = timer:tc(Fun1,[List]),
  {T2,_B} = timer:tc(Fun2,[List]),
  io:format("Czas wykonania Funkcji Mojej: ~p ms~n", [T1]),
  io:format("Czas wykonania Funkcji Bibliotecznej: ~p ms~n", [T2]).
