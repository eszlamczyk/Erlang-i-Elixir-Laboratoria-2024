%%%-------------------------------------------------------------------
%%% @author Ernest
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Feb 2024 20:14
%%%-------------------------------------------------------------------
-module(myLists).
-author("Ernest").

%% API
-export([contains/2, duplicateElements/1,sumFloats/1]).

contains([ ], _ ) -> false;
contains([H|_],H) -> true;
contains([_|T],Value) -> contains(T,Value).

duplicateElements([]) -> [];
duplicateElements([H|T]) ->  [H,H] ++ duplicateElements(T).

sumFloats(List) -> sumFloats(List,0).

sumFloats([ ], Sum) -> Sum;
sumFloats([H|T],Sum) ->
  if
    is_float(H) -> sumFloats(T,Sum+H);
    true -> sumFloats(T,Sum)
  end.
