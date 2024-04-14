%%%-------------------------------------------------------------------
%%% @author Ernest
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. kwi 2024 12:28
%%%-------------------------------------------------------------------
-module(sensor_dist).
-author("Ernest").

%% API
-export([]).

get_rand_locations(Number) -> get_rand_locations(Number, []).

get_rand_locations(0, NumberTable) -> NumberTable;
get_rand_locations(Number, NumberTable) ->
  Tuple = {random:uniform(10000), random:uniform(10000)},
  get_rand_locations(Number-1,[Tuple] ++ NumberTable).


dist({X1,Y1},{X2,Y2}) ->
  math:sqrt(math:pow((X1-X2),2)+math:pow((Y1-Y2),2)).

find_for_person(_PersonLocation, [], LocationsTable) -> LocationsTable;
find_for_person(PersonLocation,[H_Location|T_Locations],LocationsTable) ->
  find_for_person(PersonLocation,T_Locations,[{dist(PersonLocation,H_Location)},PersonLocation,H_Location] ++ LocationsTable).

find_for_person(PersonLocation,SensorLocations) -> lists:min(find_for_person(PersonLocation,SensorLocations,[])).

find_closest([], _SensorLocations, LocationsTable) -> LocationsTable;
find_closest([H_Person|T_person],SensorLocations,LocationsTable) ->
  find_closest(T_person,SensorLocations,[find_for_person(H_Person,SensorLocations)] ++ LocationsTable).

find_closest(PersonLocations,SensorLocations) ->
  lists:min(find_closest(PersonLocations,SensorLocations,[])).


time_closest() ->
  Start = timer:start().


