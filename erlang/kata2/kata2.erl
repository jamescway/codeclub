-module(kata2).
-export([chop/0, chop/2, chop/2, chop/4]).
% http://stackoverflow.com/questions/1035655/list-is-conceived-as-integer-by-length-function


chop() -> chop(6,[2,4,6,8,10]).
chop(Result) -> io:format("Location index... ~w~n", [Result-1]).

chop(_Val, []) ->
  -1.

chop(Val, List) ->
  chop(Val, 1, length(List), List).

check_shit(Val, [L|L_val], [R|R_val]) ->
  X = if [Val] == L_val -> L;
         [Val] == R_val -> R;
         true -> 0
  end.

chop(Val, L, R, List) when (L-R)==1 ->
  Result = check_shit(Val, [L, lists:nth(L,List)], [R, lists:nth(R,List)]),
  chop(Result).


chop(Val, L, R, List) ->
  io:format("Chopping stuff"),
  Mid = round((L+R)/2),
  MidVal = lists:nth(Mid, List),

  if Val =< MidVal ->
    chop(Val, L, Mid, List);
  true ->
    chop(Val, Mid, R, List)
  end.


  %pseudo code
  % 4, [1,2,3,4,5]
  % Call 4, L=1, R=5
  %   Mid=3, Mid_val=3
  %     is 4 less than than 3?  no.. Mid to R

  % Call 4, Mid=3, R=5
  %   Mid=































