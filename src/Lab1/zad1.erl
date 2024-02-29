%%%-------------------------------------------------------------------
%%% @author Ernest
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Feb 2024 17:59
%%%-------------------------------------------------------------------
-module(zad1).
-author("Ernest").

%% API
-export([power/2]).

power(_,0) -> 1;
power(Base, Exponent) when Exponent > 0 -> Base * power(Base,Exponent-1);
power(Base,Exponent) when Exponent < 0 -> Base * power(Base,Exponent+1).
