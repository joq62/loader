%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(boot_loader).   
    
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
%-include("log.hrl").
-include("configs.hrl").
%%---------------------------------------------------------------------
%% Records for test
%%


%% --------------------------------------------------------------------
%-compile(export_all).

-export([
	 start/1,
	 do_clone/1
	]).


%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start([controller])->
    io:format("controller ~p~n",[{?FUNCTION_NAME,?MODULE,?LINE}]),
    ok=do_clone(),
    LoaderEbin=filename:join("loader","ebin"),
    true=code:add_patha(LoaderEbin),
    ok=application:set_env([{loader,[{type,controller}]}]),
    ok=application:start(loader),
  %  {ok,HostVm}=lib_vm:create(),
  % 
  %  true=rpc:call(HostVm,code,add_patha,[HostEbin],5000),
   % ok=rpc:call(HostVm,application,set_env,[[{loader,[{type,controller}]}]],500),
   % ok=rpc:call(HostVm,application,start,[loader],25000),
    ok;
start([worker])->
    io:format("worker ~p~n",[{?FUNCTION_NAME,?MODULE,?LINE}]),
    ok=do_clone(),
    LoaderEbin=filename:join("loader","ebin"),
    true=code:add_patha(LoaderEbin),
    ok=application:set_env([{loader,[{type,controller}]}]),
    ok=application:start(loader),
    ok.

do_clone()->
    do_clone(node()).
do_clone(Node)->
    git_clone_host_files(Node),
    git_clone_appl_files(Node),
    git_clone_loader(Node),
    ok.

git_clone_loader(Node)->
    rpc:call(Node,os,cmd,["rm -rf "++?LoaderDir],5000),
    rpc:call(Node,os,cmd,["git clone "++?LoaderGitPath++" "++?LoaderDir],5000),
    HostEbin=filename:join(?LoaderDir,"ebin"),
    true=rpc:call(Node,code,add_patha,[HostEbin],5000),
    ok.

git_clone_host_files(Node)->
    rpc:call(Node,os,cmd,["rm -rf "++?HostFilesDir],5000),
    rpc:call(Node,os,cmd,["git clone "++?HostSpecsGitPath++" "++?HostFilesDir],5000),
    true=rpc:call(Node,code,add_patha,[?HostFilesDir],5000),
    ok.

git_clone_appl_files(Node)->
    rpc:call(Node,os,cmd,["rm -rf "++?ApplSpecsDir],5000),
    rpc:call(Node,os,cmd,["git clone "++?ApplSpecsGitPath++" "++?ApplSpecsDir],5000),
    true=rpc:call(Node,code,add_patha,[?ApplSpecsDir],5000),
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
%latest_path(AppName)->
%    Result = case file:list_dir(?RootDir) of
%		 {error,Reason}->
%		     {error,Reason};
%		 {ok,Files}->
%		     Dirs=[File||File<-Files,
%				 filelib:is_dir(File)],
%		     case lists:reverse(lists:sort(Files)) of
%			 []->
%			     {error,[eexist,Dirs]};
%			 [Latest|_] ->
%			     {ok,filename:join(AppName,Latest)}
%		     end
%	     end,
 %   Result.
