%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(appfile).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%%---------------------------------------------------------------------
%% Records for test
%%

%% --------------------------------------------------------------------
%-compile(export_all).
-export([
	 read/2
	]).
	 

%% ====================================================================
%% External functions
%% ====================================================================
read(AppFile,Type)->
    Result=case file:consult(AppFile) of
	       {ok,AllInfo}->
		   read_app_file(AllInfo,Type);
	       {error,Reason}->
		   {error,[Reason,AppFile,Type,?MODULE,?FUNCTION_NAME,?LINE]}
	   end,
    Result.

read_app_file(AllInfo,all)->
    {ok,AllInfo};
read_app_file([{application,App,_}],application)->
    {ok,App};
read_app_file([{application,_,Info}],git_path) ->
    {git_path,GitPath}=lists:keyfind(git_path,1,Info),
    {ok,GitPath};
read_app_file([{application,_,Info}],Key) ->
   Result=case lists:keyfind(Key,1,Info) of
	      {Key,Value}->
		  {ok,Value};
	      false->
		  {error,[eexists,Key,?FUNCTION_NAME,?MODULE,?LINE]}
	  end,
    Result;
read_app_file(Error,_) ->
    {error,[unmatched_signal,Error,?FUNCTION_NAME,?MODULE,?LINE]}.




%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
