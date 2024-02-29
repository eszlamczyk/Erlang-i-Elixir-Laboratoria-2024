%%%-------------------------------------------------------------------
%%% @author Ernest
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Feb 2024 20:24
%%%-------------------------------------------------------------------
-module(pollutionCalculator).
-author("Ernest").

%% API
-export([number_of_readings/2, generate_readings/0, calculate_max/2, calculate_mean/2]).
-import(myLists,[contains/2]).

%%Struktura z zadania 3: {"Miasto",{{day,month,year}, {hour,minute}}, [{Rodzaj Pomiaru, Wartość},...]}

%useful functions
generate_readings() ->
  [
    {"Warsaw", {{27, 2, 2024}, {15, 30}}, [{"Temperature", 8}, {"Humidity", 65}, {"Wind Speed", 14}, {"PM10", 25}, {"PM2.5", 48}, {"PM1", 10}]},
    {"Krakow", {{27, 2, 2024}, {16, 00}}, [{"Temperature", 6}, {"Humidity", 70}, {"Wind Speed", 10}, {"PM10", 30}, {"PM2.5", 37}, {"PM1", 12}]},
    {"Gdansk", {{27, 2, 2024}, {15, 45}}, [{"Temperature", 5}, {"Humidity", 75}, {"Wind Speed", 20}, {"PM10", 20}, {"PM2.5", 35}, {"PM1", 8}]},
    {"Wroclaw", {{27, 2, 2024}, {16, 15}}, [{"Temperature", 7}, {"Humidity", 68}, {"Wind Speed", 12}, {"PM10", 28}, {"PM2.5", 29}, {"PM1", 9}]},
    {"Poznan", {{27, 2, 2024}, {14, 30}}, [{"Humidity", 60}, {"Wind Speed", 11}, {"PM10", 22}, {"PM2.5", 36}, {"PM1", 7}]},
    {"Lodz", {{27, 2, 2024}, {15, 00}}, [{"Temperature", 8}, {"Humidity", 67}, {"Wind Speed", 15}, {"PM10", 26}, {"PM2.5", 40}, {"PM1", 1}]},
    {"Warsaw", {{28, 2, 2024}, {9, 00}}, [{"Temperature", 3}, {"Humidity", 40}, {"Wind Speed", 14}, {"PM10", 26}, {"PM2.5", 38}, {"PM1", 4}]},
    {"Krakow", {{28, 2, 2024}, {9, 00}}, [{"Temperature", 6}, {"Humidity", 42}, {"Wind Speed", 10}, {"PM10", 34}, {"PM2.5", 42}, {"PM1", 5}]},
    {"Gdansk", {{28, 2, 2024}, {9, 45}}, [{"Temperature", 2}, {"Humidity", 49}, {"Wind Speed", 20}, {"PM10", 26}, {"PM2.5", 45}]},
    {"Wroclaw", {{28, 2, 2024}, {10, 15}}, [{"Temperature", 7}, {"Humidity", 39}, {"Wind Speed", 12}, {"PM10", 22}, {"PM2.5", 39}, {"PM1", 5}]},
    {"Poznan", {{28, 2, 2024}, {8, 30}}, [{"Temperature", 4}, {"Humidity", 50}, {"Wind Speed", 11}, {"PM10", 21}, {"PM1", 11}]},
    {"Lodz", {{28, 2, 2024}, {8, 45}}, [{"Temperature", 5}, {"Humidity", 30}, {"Wind Speed", 15}, {"PM10", 28}, {"PM2.5", 40}, {"PM1", 9}]},
    {"Warsaw", {{28, 2, 2024}, {18, 30}}, [{"Temperature", 4}, {"Humidity", 20}, {"Wind Speed", 14}, {"PM10", 35}, {"PM1", 12}]},
    {"Krakow", {{28, 2, 2024}, {19, 00}}, [{"Temperature", 7}, {"Humidity", 15}, {"Wind Speed", 10}, {"PM10", 40}, {"PM2.5", 12}, {"PM1", 14}]},
    {"Gdansk", {{28, 2, 2024}, {18, 45}}, [{"Temperature", 2}, {"Humidity", 27}, {"Wind Speed", 20}, {"PM10", 21}, {"PM2.5", 15}, {"PM1", 10}]},
    {"Wroclaw", {{28, 2, 2024}, {19, 15}}, [{"Temperature", 8}, {"Humidity", 10}, {"Wind Speed", 12}, {"PM10", 22}, {"PM2.5", 15}, {"PM1", 11}]},
    {"Poznan", {{28, 2, 2024}, {17, 30}}, [{"Temperature", 6}, {"Humidity", 12}, {"Wind Speed", 11}, {"PM10", 36}, {"PM2.5", 16}, {"PM1", 10}]},
    {"Lodz", {{28, 2, 2024}, {19, 00}}, [{"Temperature", 5},  {"Wind Speed", 15}, {"PM10", 38}, {"PM2.5", 13}, {"PM1", 10}]},
    {"Warsaw", {{29, 2, 2024}, {15, 30}}, [{"Temperature", 12}, {"Humidity", 80}, {"Wind Speed", 22}, {"PM10", 32}, {"PM1", 6}]},
    {"Krakow", {{29, 2, 2024}, {16, 00}}, [{"Temperature", 15}, {"Humidity", 75}, {"Wind Speed", 25}, {"PM10", 30}, {"PM2.5", 22}, {"PM1", 5}]},
    {"Gdansk", {{29, 2, 2024}, {15, 45}}, [{"Temperature", 10}, {"Humidity", 95}, {"Wind Speed", 29}, {"PM10", 22}, {"PM2.5", 15}, {"PM1", 4}]},
    {"Wroclaw", {{29, 2, 2024}, {16, 15}}, [{"Temperature", 18}, {"Humidity", 88}, {"Wind Speed", 17}, {"PM10", 26}, {"PM2.5", 19}, {"PM1", 8}]},
    {"Poznan", {{29, 2, 2024}, {14, 30}}, [{"Temperature", 13}, {"Humidity", 91}, {"PM10", 28}, {"PM2.5", 16}, {"PM1", 10}]},
    {"Lodz", {{29, 2, 2024}, {15, 00}}, [{"Temperature", 14}, {"Wind Speed", 11}, {"PM10", 27}, {"PM2.5", 20}, {"PM1", 12}]}
  ].

find_existing([],_Type) -> false;
find_existing([{Type,Value}|_T],Type) -> Value;
find_existing([_H|T],Type) -> find_existing(T,Type).

compare(A,B) ->
  if
    A > B -> A;
    true -> B
  end.


%number_of_readings(Readings,Date) -> int
number_of_readings(Readings, Date) -> number_of_readings(Readings,Date,0).

number_of_readings([],_Date,Amount) -> Amount;
number_of_readings([{_City,{Date,_Time},_Measurements}|T],Date,Amount) -> number_of_readings(T,Date,Amount+1);
number_of_readings([_H|T],Date,Amount) -> number_of_readings(T,Date,Amount).





%acceptableTypes: {"Temperature", "Humidity", "Wind Speed", "PM10", "PM2.5", "PM1"}

%calculate_max(Readings, Type) -> float
calculate_max(Readings, Type)  ->
  case myLists:contains(["Temperature", "Humidity", "Wind Speed", "PM10", "PM2.5", "PM1"],Type) of
    true -> calculate_max(Readings,Type,0);
    _ -> {error, incorrectType}
  end.


calculate_max([], _Type ,Max) -> Max;
calculate_max([{_City,_Date,Measurements}|T], Type, Max) ->
  %Measurement = find_existing(Measurements,Type),
  case find_existing(Measurements,Type) of
    false -> calculate_max(T,Type,Max);
    _ -> calculate_max(T,Type,compare(Max,find_existing(Measurements,Type)))
  end.

%calculate_mean(Readings, Type) -> float
calculate_mean(Readings, Type) ->
  case myLists:contains(["Temperature", "Humidity", "Wind Speed", "PM10", "PM2.5", "PM1"],Type) of
    true -> calculate_mean(Readings,Type,0,0);
    _ -> {error, incorrectType}
  end.

calculate_mean([], _Type ,Sum,Amount) -> Sum/Amount;
calculate_mean([{_City,_Date,Measurements}|T], Type, Sum,Amount) ->
  %Measurement = find_existing(Measurements,Type),
  case find_existing(Measurements,Type) of
    false -> calculate_mean(T,Type,Sum,Amount);
    _ -> calculate_mean(T,Type,Sum + find_existing(Measurements,Type),Amount + 1)
  end.