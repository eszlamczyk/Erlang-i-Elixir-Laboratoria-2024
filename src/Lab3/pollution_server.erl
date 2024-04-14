%%%-------------------------------------------------------------------
%%% @author Ernest
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Apr 2024 13:42
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("Ernest").

%% API
-export([start/0,stop/0,add_station/2,add_value/4,remove_value/3,get_one_value/3,get_station_mean/2,get_daily_mean/2,
  get_maximum_gradient_station/1,init/0]).

init() ->
  loop(pollution:create_monitor()).

loop(Monitor) ->
  receive
    {request, Pid, add_station, Name, Geolocation} ->
      case pollution:add_station(Name,Geolocation,Monitor) of
        {error, V} ->
          Pid ! {error, V},
          loop(Monitor);
        NewMonitor ->
          Pid ! {reply, ok},
          loop(NewMonitor)
      end;
    {request, Pid, add_value, NameOrGeolocation, Date, Type, Value} ->
      case pollution:add_value(NameOrGeolocation,Date,Type,Value,Monitor) of
        {error, V} ->
          Pid ! {error, V},
          loop(Monitor);
        NewMonitor ->
          Pid ! {reply, ok},
          loop(NewMonitor)
      end;
    {request, Pid, remove_value, NameOrGeolocation,Date,Type} ->
      case pollution:remove_value(NameOrGeolocation,Date,Type,Monitor) of
        {error, V} ->
          Pid ! {error, V},
          loop(Monitor);
        NewMonitor ->
          Pid ! {reply, ok},
          loop(NewMonitor)
      end;
    {request, Pid, get_one_value, NameOrGeolocation, Date, Type} ->
      case pollution:get_one_value(NameOrGeolocation, Date, Type, Monitor) of
        {error, Msg} ->
          Pid ! {error, Msg};
        Value ->
          Pid ! {reply, Value}
      end,
      loop(Monitor);
    {request, Pid, get_station_mean, NameOrGeolocation,Type} ->
      case pollution:get_station_mean(NameOrGeolocation,Type,Monitor) of
        {error, Msg} ->
          Pid ! {error, Msg};
        Mean ->
          Pid ! {reply, Mean}
      end,
      loop(Monitor);
    {request, Pid, get_daily_mean, Type,Date} ->
      case pollution:get_daily_mean(Type,Date,Monitor) of
        {error, Msg} ->
          Pid ! {error, Msg};
        Mean ->
          Pid ! {reply, Mean}
      end,
      loop(Monitor);
    {request, Pid,get_maximum_gradient_station, Type} ->
      case pollution:get_maximum_gradient_station(Type,Monitor) of
        {error, Msg} ->
          Pid ! {error, Msg};
        Station ->
          Pid ! {reply, Station}
      end,
      loop(Monitor);
    {request, Pid, stop} ->
      Pid ! {reply, ok}
  end.


%%API

start() ->
  register (pollutionServer, spawn(pollution_server, init, [])),
  ok.

stop() ->
  pollutionServer ! {request, self(), stop},
  receive
    {reply, ok} -> ok
  end.

add_station(Name,Geolocation) ->
  pollutionServer ! {request, self(), add_station, Name,Geolocation},
  receive
    {error, Msg} -> {error, Msg};
    {reply, Msg} -> Msg
  end.

add_value(NameOrGeolocation, Date, Type, Value) ->
  pollutionServer ! {request, self(), add_value, NameOrGeolocation, Date, Type, Value},
  receive
    {error, Msg} -> {error, Msg};
    {reply, Msg} -> Msg
  end.

remove_value(NameOrGeolocation,Date,Type) ->
  pollutionServer ! {request, self(), remove_value,NameOrGeolocation,Date,Type},
  receive
    {error, Msg} -> {error, Msg};
    {reply, Msg} -> Msg
  end.

get_one_value(NameOrGeolocation, Date, Type) ->
  pollutionServer ! {request, self(), get_one_value, NameOrGeolocation, Date, Type},
  receive
    {error, Msg} -> {error, Msg};
    {reply, Msg} -> Msg
  end.

get_station_mean(NameOrGeolocation,Type) ->
  pollutionServer ! {request, self(), get_station_mean, NameOrGeolocation,Type},
  receive
    {error, Msg} -> {error, Msg};
    {reply, Msg} -> Msg
  end.

get_daily_mean(Type,Date) ->
  pollutionServer ! {request, self(), get_daily_mean, Type,Date},
  receive
    {error, Msg} -> {error, Msg};
    {reply, Msg} -> Msg
  end.

get_maximum_gradient_station(Type) ->
  pollutionServer ! {request, self(), get_maximum_gradient_station, Type},
  receive
    {error, Msg} -> {error, Msg};
    {reply, Msg} -> Msg
  end.