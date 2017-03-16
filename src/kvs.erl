%%%-------------------------------------------------------------------
%%% @author centelles
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Mar 2017 21:02
%%%-------------------------------------------------------------------
-module(kvs).
-author("centelles").

%% API
-export([start/0, store/2, lookup/1]).
-spec kvs:start() -> true.
start() -> register(kvs, spawn(fun() -> loop() end)).

store(Key, Value) -> rpc({store, Key, Value}).

lookup(Key) -> rpc({lookup, Key}).

rpc(Q) ->
  kvs ! {self(), Q},
  receive
    {kvs, Reply} ->
      Reply
  end.

loop() ->
  receive
    {From, {store, Key, Value}} ->
      put(Key, {ok, Value}),
      From ! {kvs, true},
      loop();
    {From, {lookup, Key}} ->
      From ! {kvs, get(Key)},
      loop()
  end.
