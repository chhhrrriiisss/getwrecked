//
//      Name: markNearby
//      Desc: Tags all objects near area as killed by local player
//      Return: None
//

private ['_pos', '_radius', '_nearby'];

_pos = [_this,0, [], [[]]] call BIS_fnc_param;
_rad = [_this,1, 5, [0]] call BIS_fnc_param;

if (count _pos == 0) exitWith {};

_nearby = _pos nearEntities [["car"], _rad];

if (count _nearby == 0) exitWith {};

{
	[_x] spawn checkMark;
	false
} count _nearby > 0;