%%%-------------------------------------------------------------------
%%% @author Ernest
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Mar 2024 15:15
%%%-------------------------------------------------------------------
-module(pollution).
-author("Ernest").

%% API
-export([create_monitor/0, add_station/3, add_value/5, remove_value/4, get_one_value/4,
  get_station_mean/3, get_daily_mean/3,get_maximum_gradient_station/2]).

-record(station, {name,geolocation}).
-record(reading, {station,date,type,value}).
-record(monitor, {stations = [], readings = []}).


%helper fun
station_exists(Records,Value) ->
  lists:filter(fun(Record) -> element_match(Value, Record) end, Records).

element_match(Value, Record) ->
  lists:any(fun(Field) -> Field == Value end, tuple_to_list(Record)).

%%%
reading_exists_S_D_T(Readings, Station, Date, Type) ->
  lists:filter(fun(Record) ->
    element_match_S_D_T(Record, Station,Date,Type)
               end, Readings).

element_match_S_D_T(Record,Station,Date,Type) ->
  case Record of
    #reading{station = Station, date = Date, type = Type} -> true;
    _ -> false
  end.

%reading_exists_S_T(Readings, Station, Type) ->
%  lists:filter(fun(Record) -> element_match_S_T(Record, Station,Type) end, Readings).

element_match_S_T(Record,Station,Type) ->
  case Record of
    #reading{station = Station, type = Type} -> true;
    _ -> false
  end.

get_min_value([H_Reading|T],Type,Min) ->
  case H_Reading of
    #reading{type = Type} -> get_min_value(T,Type,min(H_Reading#reading.value,Min));
    _ -> get_min_value(T,Type,Min)
  end;
get_min_value([],_,Min) -> Min.


get_max_value([H_Reading|T],Type,Max) ->
  case H_Reading of
    #reading{type = Type} -> get_max_value(T,Type,max(H_Reading#reading.value,Max));
    _ -> get_max_value(T,Type,Max)
  end;
get_max_value([],_,Max) -> Max.

%%%

%primary Functions
create_monitor() -> #monitor{}.

add_station(Name, Geolocation,Monitor) ->
  case station_exists(Monitor#monitor.stations,Geolocation) of
    [] -> Monitor#monitor{stations = [#station{name = Name, geolocation = Geolocation}|Monitor#monitor.stations]};
    _ -> {error, {"Station already exists!", Name,Geolocation}}
  end.

add_value(NameOrGeolocation,Date,Type,Value,Monitor) ->
  case station_exists(Monitor#monitor.stations,NameOrGeolocation) of
    [ ] -> {error, "station does not exist"};
    [Station | _] ->
      case reading_exists_S_D_T(Monitor#monitor.readings,Station,Date,Type) of
        [ ] -> Monitor#monitor{readings = [#reading{station = Station,date = Date,type = Type, value = Value}|Monitor#monitor.readings]};
        _ -> {error, "measurement in specified station already exists"}
      end
  end.

remove_value(NameOrGeolocation,Date,Type,Monitor) ->
  case station_exists(Monitor#monitor.stations,NameOrGeolocation) of
    [ ] -> {error, "station does not exist"};
    [Station | _ ] ->
      case reading_exists_S_D_T(Monitor#monitor.readings,Station,Date,Type) of
        [ ] -> {error, "no reading to remove found"};
        [Removed | _ ] ->
          Filtered = lists:delete(Removed,Monitor#monitor.readings),
          Monitor#monitor{readings = Filtered}
      end
  end.

get_one_value(NameOrGeolocation, Date, Type, Monitor) ->
  case station_exists(Monitor#monitor.stations,NameOrGeolocation) of
    [ ] ->
      {error, "station does not exist"};
    [Station | _T] ->
      case reading_exists_S_D_T(Monitor#monitor.readings, Station, Date, Type) of
        [ ] ->
          {error, "no reading to get found"};
        [Reading | _] ->
          Reading#reading.value
      end
  end.

sum_readings([]) -> 0;
sum_readings([H|T]) ->
  H#reading.value + sum_readings(T).



get_station_mean(NameOrGeolocation,Type,Monitor) ->
  case station_exists(Monitor#monitor.stations,NameOrGeolocation) of
    [ ] -> {error, "station does not exist"};
    [Station | _T] ->
      Filtered = lists:filter(fun (X) -> element_match_S_T(X,Station,Type) end, Monitor#monitor.readings),
      case length(Filtered) of
        0 -> {error, "no readings found with specified type"};
        Count -> sum_readings(Filtered)/Count
      end
  end.

filter_by_date_and_type(Reading,Date,Type) ->
  case Reading of
    #reading{date = {Date,_},type = Type} -> true;
    _ -> false
  end.

get_daily_mean(Type,Date,Monitor) ->
  Filtered = lists:filter(fun (X) -> filter_by_date_and_type(X,Date,Type) end, Monitor#monitor.readings),
  case length(Filtered) of
    0 -> {error, "no readings found with specified type"};
    Count -> sum_readings(Filtered)/Count
  end.


filter_by_station(Reading,Station) ->
  case Reading of
    #reading{station = Station} -> true;
    _ -> false
  end.

%%Station gradients

get_station_gradient(Station, Type, Readings) ->
  Filtered = lists:filter(fun(X) -> filter_by_station(X,Station) end, Readings),
  %me omw to chill in temperature bigger than trillion
  get_max_value(Filtered,Type,-1000000000)-get_min_value(Filtered,Type,1000000000).

parse_stations_to_gradient([H_Station|T],Type,Readings,{Best_Station,Best_Value}) ->
  New_Value = get_station_gradient(H_Station,Type,Readings),
  if
    New_Value > Best_Value ->
      parse_stations_to_gradient(T,Type,Readings,{H_Station,New_Value});
    true ->
      parse_stations_to_gradient(T,Type,Readings,{Best_Station,Best_Value})
  end;
parse_stations_to_gradient([],_,_,{Best_station,_}) -> Best_station#station.name.

get_maximum_gradient_station(Type,Monitor) ->
  parse_stations_to_gradient(Monitor#monitor.stations,Type,Monitor#monitor.readings,{placeholder,0}).


