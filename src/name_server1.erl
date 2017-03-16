%%%-------------------------------------------------------------------
%%% @author centelles
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Mar 2017 08:45
%%%-------------------------------------------------------------------
-module(name_server1).
-author("centelles").

-import(server3, [rpc/2]).

-export([add/2, find/1, init/0, handle/2]).
%% client routines
add(Name, Place) -> rpc(name_server, {add, Name, Place}).
find(Name) -> rpc(name_server, {find, Name}).


init() -> dict:new().
handle({add, Name, Place}, Dict) -> {ok, dict:store(Name, Place, Dict)};
handle({find, Name}, Dict) -> {dict:find(Name, Dict), Dict}.
