%%%-------------------------------------------------------------------
%%% @author Ernest
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Apr 2024 17:46
%%%-------------------------------------------------------------------
-module(pollution_value_collector_gen_statem).
-author("Ernest").

-behaviour(gen_statem).

%% API
-export([start_link/0]).
-export([stop/0,set_station/1,add_value/3,store_data/0]).

%% gen_statem callbacks
-export([init/1, callback_mode/0,terminate/3,setter/3,adder/3]).

-define(SERVER, ?MODULE).

-record(pollution_value_gen_statem_state, {}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
  gen_statem:start_link({local, ?SERVER}, ?MODULE, [], []).

stop() -> gen_statem:stop(?SERVER).

set_station(NameOrGeolocation) ->
  io:format("Funny number: 69 ~n"),
  gen_statem:cast(?SERVER, {set_station, NameOrGeolocation}).
add_value(Date, Type, Value) -> gen_statem:cast(?SERVER, {add_value, Date, Type, Value}).
store_data() -> gen_statem:cast(?SERVER, {store_data} ).


%%%===================================================================
%%% gen_statem callbacks
%%%===================================================================

init([]) -> {ok, setter, []}.
callback_mode()->state_functions.

setter(_Event, {set_station,NameOrGeolocation}, []) ->
  io:format("DEBUG: setter set ~p~n", [NameOrGeolocation]),
  {next_state, adder, [NameOrGeolocation]}.
adder(_Event, {add_value, Date,Type,Value},[NameOrGeolocation|Rest]) ->
  io:format("DEBUG: adder add ~p~n", [Value]),
  NewRest =  [{Date,Type,Value}] ++ Rest,
  {next_state, adder, [NameOrGeolocation|NewRest]};
adder(_Event, {store_data},[NameOrGeolocation|Data]) ->
  add_values(NameOrGeolocation, Data).


add_values(_NameOrGeolocation, []) ->
  io:format("DEBUG: storer setting state setter ~n"),
  {next_state, setter, []};
add_values(NameOrGeolocation,[{Date,Type,Value}|T_Data]) ->
  io:format("DEBUG: storer adding ~p~n", [Value]),
  pollution_gen_server:addValue(NameOrGeolocation,Date,Type,Value),
  add_values(NameOrGeolocation, T_Data).



terminate(_Reason, _StateName, _State = #pollution_value_gen_statem_state{}) ->
  ok.


%%%===================================================================
%%% Internal functions
%%%===================================================================
