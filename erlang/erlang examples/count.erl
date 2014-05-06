-module(count).
-export([ten/1]).

ten(10) -> 10;
ten(N) ->
	io:write(N),
	ten(N + 1).