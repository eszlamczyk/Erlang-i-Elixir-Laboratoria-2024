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
-export([get_rand_locations/1,find_closest/2,find_closest_parallel/2]).

get_rand_locations(Number) -> get_rand_locations(Number, []).

get_rand_locations(0, NumberTable) -> NumberTable;
get_rand_locations(Number, NumberTable) ->
  Tuple = {rand:uniform(10000), rand:uniform(10000)},
  get_rand_locations(Number-1,[Tuple] ++ NumberTable).


dist({X1,Y1},{X2,Y2}) ->
  math:sqrt(math:pow((X1-X2),2)+math:pow((Y1-Y2),2)).

find_for_person(PersonLocation,SensorLocations) ->
  lists:min([{dist(PersonLocation,Location),{PersonLocation,Location}} || Location <- SensorLocations]).


find_closest(PersonLocations,SensorLocations) ->
  lists:min([find_for_person(Person,SensorLocations)|| Person <- PersonLocations]).

%%czas wykonania ~4s dla [sensor_dist:get_rand_locations(20000),sensor_dist:get_rand_locations(1000)]

find_for_person(PersonLocation, SensorLocations, ParentPID) ->
  ParentPID ! lists:min([{dist(PersonLocation,Location),{PersonLocation,Location}} || Location <- SensorLocations]).

find_for_person_handler(PersonLocation, SensorLocations, ParentPID) ->
  spawn(fun() -> find_for_person(PersonLocation,SensorLocations,ParentPID) end),
  receive N -> N end.

find_closest_parallel(PersonLocations,SensorLocations) ->
  lists:min([find_for_person_handler(Person, SensorLocations, self()) || Person <- PersonLocations]).

%%czas wykonania ~7s???
