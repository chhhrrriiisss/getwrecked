//
//      Name: markNearby
//      Desc: Tags all objects near area as killed by local player
//      Return: None
//

private ['_pos', '_radius', '_nearby', '_m'];

_pos = [_this,0, [], [[]]] call BIS_fnc_param;
_rad = [_this,1, 5, [0]] call BIS_fnc_param;
_m =  [_this,2, "", [""]] call BIS_fnc_param;

if (count _pos == 0) exitWith {};

_nearby = _pos nearEntities [["car"], _rad];

if (count _nearby == 0) exitWith {};

{
	if (_x != (vehicle player)) then { [_x,_m] spawn checkMark; };
	false
} count _nearby > 0;