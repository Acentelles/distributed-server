%%%-------------------------------------------------------------------
%%% @author centelles
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Mar 2017 08:15
%%%-------------------------------------------------------------------
-module(server1).
-author("centelles").

%% API
-export([rpc/2, start/2]).

start(Name, Mod) -> register(Name, spawn(fun() -> loop(Name, Mod, Mod:init()) end)).

rpc(Name, Request) ->
  Name ! {self(), Request},
  receive
    {Name, Response} -> Response
  end.

loop(Name, Mod, State) ->
  receive
    {From, Request} ->
      {Response, State1} = Mod:handle(Request, State),
      From ! {Name, Response},
      loop(Name, Mod, State1)
  end.
