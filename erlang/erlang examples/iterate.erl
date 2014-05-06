Numbers = [1,2,3,4].
Print = fun(X) -> io:format("~p~n", [X]) end.
lists:foreach(Print, Numbers)