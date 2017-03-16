%%%-------------------------------------------------------------------
%%% @author centelles
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Mar 2017 08:55
%%%-------------------------------------------------------------------
-module(new_name_server).
-author("centelles").
-export([add/2, find/1, init/0, handle/2, delete/1, all_names/0]).
-import(server3, [rpc/2]).

%% client routines
add(Name, Place) -> rpc(name_server, {add, Name, Place}).
find(Name) -> rpc(name_server, {find, Name}).
delete(Name) -> rpc(name_server, {delete, Name}).
all_names() -> rpc(name_server, allNames).

init() -> dict:new().

handle({allNames}, Dict) -> {dict:fetch_keys(Dict), Dict};
handle({add, Name, Place}, Dict) -> {ok, dict:store(Name, Place, Dict)};
handle({find, Name}, Dict) -> {dict:find(Name, Dict), Dict};
handle({delete, Name}, Dict) -> {ok, dict:erase(Name, Dict)}.