#!/usr/bin/env escript
% http://stackoverflow.com/questions/1035655/list-is-conceived-as-integer-by-length-function

main(_) ->

X = 1.
foo() -> 10;

if X > 0 ->
	foo(),
	fffff
	true ->
	  fuxor
end.



% main(_) ->
% 	io:format("~nRunning Kata2~n~n"),
% 	chop().


% 	chop() -> chop(3,[1,2,3,4,5]).
% 	chop(Val, List) ->
% 		if List == [] ->
% 			-1;
% 			true -> chop(Val, 1, length(List), List)
% 		end.

% 	check_shit(Val, [H|T]) ->
% 		matches(Val, H),
% 		check_shit(Val, [T]).

% 	matches(Target, Val) when Target == Val -> io:format("Location Index... ~w~n", [Val]).


% 	chop(Val, L, R, List) ->
% 		Mid = round(length(List)/2),
% 		MidVal = lists:nth(Mid, List),

% 		[H|T] = List,
% 		if length(List) == 2 ->
% 			check_shit(Val, [H, T]);
% 			true -> io:format("Location Index... ~w~n", [-1])
% 		end,

% 		if Val < MidVal ->
% 			chop(Val, L, Mid, List);
% 		true ->
% 			chop(Val, Mid, R, List)
% 		end.


	% 4, [1,2,3,4,5]
	% Call 4, L=1, R=5
	% 	Mid=3, Mid_val=3
	% 		is 4 less than than 3?  no.. Mid to R

	% Call 4, Mid=3, R=5
	% 	Mid=































