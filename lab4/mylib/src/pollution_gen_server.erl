%%%-------------------------------------------------------------------
%%% @author Ernest
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(pollution_gen_server).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-export([addStation/2,addValue/4,removeValue/3,getOneValue/4,getStationMean/2,getDailyMean/2,
  getMaximumGradientStation/1,crash/0]).

-record(pollution_gen_server_state, {}).



%%UI

addStation(Name, Geolocation) ->
  gen_server:call(?MODULE, {add_station, Name, Geolocation}).

addValue(NameOrGeolocation,Date,Type,Value) ->
  gen_server:call(?MODULE, {add_value, NameOrGeolocation, Date,Type,Value}).

removeValue(NameOrGeolocation,Date,Type) ->
  gen_server:call(?MODULE, {remove_value, NameOrGeolocation, Date, Type}).

getOneValue(NameOrGeolocation, Date, Type, Value) ->
  gen_server:call(?MODULE, {get_one_value, NameOrGeolocation, Date, Type, Value}).

getStationMean(NameOrGeolocation, Type) ->
  gen_server:call(?MODULE, {get_station_mean,NameOrGeolocation,Type}).

getDailyMean(Type,Date) ->
  gen_server:call(?MODULE, {get_daily_mean, Type, Date}).

getMaximumGradientStation(Type) ->
  gen_server:call(?MODULE, {get_maximum_gradient_station,Type}).

crash() -> 1/0.

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
  {ok, pollution:create_monitor()}.

handle_call({add_station, Name, Geolocation}, _From, Monitor) ->
  case pollution:add_station(Name,Geolocation,Monitor) of
    {error, V} ->
      {reply,{error, V}, Monitor};
    NewMonitor ->
      {reply, ok, NewMonitor}
  end;

handle_call({add_value, NameOrGeolocation, Date,Type,Value}, _From, Monitor) ->
  case pollution:add_value(NameOrGeolocation,Date,Type,Value,Monitor) of
    {error, V} ->
      {reply,{error, V}, Monitor};
    NewMonitor ->
      {reply, ok, NewMonitor}
  end;

handle_call({remove_value, NameOrGeolocation, Date, Type},_From,Monitor) ->
  case pollution:remove_value(NameOrGeolocation,Date,Type,Monitor) of
    {error, V} ->
      {reply,{error, V}, Monitor};
    NewMonitor ->
      {reply, ok, NewMonitor}
  end;
handle_call({get_one_value, NameOrGeolocation, Date, Type}, _From, Monitor) ->
  case pollution:get_one_value(NameOrGeolocation,Date,Type,Monitor) of
    {error, V} ->
      {reply,{error, V}, Monitor};
    ReturnValue ->
      {reply, {ok, ReturnValue}, Monitor}
  end;
handle_call({get_station_mean,NameOrGeolocation,Type},_From,Monitor) ->
  case pollution:get_station_mean(NameOrGeolocation,Type,Monitor) of
    {error, V} ->
      {reply,{error, V}, Monitor};
    ReturnValue ->
      {reply, {ok, ReturnValue}, Monitor}
  end;
handle_call({get_daily_mean, Type, Date}, _From, Monitor) ->
  case pollution:get_daily_mean(Type,Date,Monitor) of
    {error, V} ->
      {reply,{error, V}, Monitor};
    ReturnValue ->
      {reply, {ok, ReturnValue}, Monitor}
  end;
handle_call({get_maximum_gradient_station,Type}, _From, Monitor) ->
  case pollution:get_maximum_gradient_station(Type,Monitor) of
    {error, V} ->
      {reply,{error, V}, Monitor};
    ReturnValue ->
      {reply, {ok, ReturnValue}, Monitor}
  end.


handle_cast(_Request, State = #pollution_gen_server_state{}) ->
  {noreply, State}.

handle_info(_Info, State = #pollution_gen_server_state{}) ->
  {noreply, State}.

terminate(_Reason, _State = #pollution_gen_server_state{}) ->
  %%jakoś zapisac informacje o monitorze np do pliku
  ok.

code_change(_OldVsn, State = #pollution_gen_server_state{}, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

