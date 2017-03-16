%%%-------------------------------------------------------------------
%%% @author centelles
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Mar 2017 08:37
%%%-------------------------------------------------------------------
-module(server3).
-author("centelles").

%% API
-export([rpc/2, start/2, swap_code/2]).

start(Name, Mod) ->
  register(Name,
    spawn(fun() -> loop(Name, Mod, Mod:init()) end)).

swap_code(Name, Mod) -> rpc(Name, {swap_code, Mod}).

rpc(Name, Request) ->
  Name ! {self(), Request},
  receive
    {Name, Response} -> Response
  end.

loop(Name, Mod, OldState) ->
  receive
    {From, {swap_code, NewCallBackMod}} ->
      From ! {Name, ack},
      loop(Name, NewCallBackMod, OldState);
    {From, Request} ->
      {Response, NewState} = Mod:handle(Request, OldState),
      From ! {Name, Response},
      loop(Name, Mod, NewState)
  end.