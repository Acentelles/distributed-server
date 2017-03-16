%%%-------------------------------------------------------------------
%%% @author centelles
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Mar 2017 08:15
%%%-------------------------------------------------------------------
-module(server2).
-author("centelles").

%% API
-export([rpc/2, start/2]).

start(Name, Mod) -> register(Name, spawn(fun() -> loop(Name, Mod, Mod:init()) end)).

rpc(Name, Request) ->
  Name ! {self(), Request},
  receive
    {Name, crash} -> exit(rpc);
    {Name, Response} -> Response
  end.

loop(Name, Mod, OldState) ->
  receive
    {From, Request} ->
      try Mod:handle(Request, OldState) of
        {Response, NewState} ->
          From ! {Name, Response},
          loop(Name, Mod, NewState)
      catch
        _:Why ->
          log_the_error(Name, Request, Why),
          From ! {Name, crash},
          loop(Name, Mod, OldState)
      end
  end.

log_the_error(Name, Request, Why) ->
  io:format("Server ~p request ~p ~n caused exception ~p~n",
    [Name, Request, Why]).