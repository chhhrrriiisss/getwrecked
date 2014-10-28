//
//		Name: allPlayers
//		Desc: Returns a list of all active players (dead and alive)
//		Return: Array
//

private ['_all'];

_all = [];

{
	if (isPlayer _x) then { _all pushBack _x };
} ForEach playableUnits;

{
	if (isPlayer _x) then { _all pushBack _x };
} ForEach allDeadMen;

_all