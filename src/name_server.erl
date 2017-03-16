%%%-------------------------------------------------------------------
%%% @author centelles
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Mar 2017 08:24
%%%-------------------------------------------------------------------
-module(name_server).
-author("centelles").

-import(server1, [rpc/2]).
%% API
-export([init/0, add/2, find/1, handle/2]).

%% client routines
add(Name, Place) -> rpc(name_server, {add, Name, Place}).
find(Name) -> rpc(name_server, {find, Name}).

%% callback routines
init() -> dict:new().
handle({add, Name, Place}, Dict) -> {ok, dict:store(Name, Place, Dict)};
handle({find, Name}, Dict) -> {dict:find(Name, Dict), Dict}.

