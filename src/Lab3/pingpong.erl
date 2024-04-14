%%%-------------------------------------------------------------------
%%% @author Ernest
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. kwi 2024 11:42
%%%-------------------------------------------------------------------
-module(pingpong).
-author("Ernest").

%% API
-export([start/0, play/1]).

handlePing(ReceivedAmount) ->
  receive
    0 ->
      stop(),
      handlePing(ReceivedAmount + 1);
    stop -> ok;
    N ->
      io:format("Ping Recieved ~w times ~n", [ReceivedAmount + 1]),
      timer:sleep(1000),
      pong ! N-1,
      handlePing(ReceivedAmount + 1)
  after 20000 -> ok
  end.

handlePong(ReceivedAmount) ->
  receive
    0 ->
      stop(),
      handlePong(ReceivedAmount + 1);
    stop -> ok;
    N ->
      io:format("Pong Recieved ~w times ~n", [ReceivedAmount + 1]),
      timer:sleep(1000),
      ping ! N-1,
      handlePong(ReceivedAmount + 1)
  after 20000 -> ok
  end.

stop() ->
  ping ! stop,
  pong ! stop.

start() ->
  register(ping, spawn(fun () -> handlePing(0) end)),
  register(pong, spawn(fun () -> handlePong(0) end)).

play(N) ->
  ping ! N.


