//
//      Name: markIntersects
//      Desc: Tags all objects intersecting path as killed by local player
//      Return: None
//

private ['_src', '_des', '_objs'];

_src = [_this,0, [], [[]]] call BIS_fnc_param;
_des = [_this,1, [], [[]]] call BIS_fnc_param;

if (count _src == 0 || count _des == 0) exitWith {};

_objs = lineIntersectsWith [_src, _des, (vehicle player), (player), false];

if (count _objs == 0) exitWith {};

{
	[_x] spawn checkMark;
} ForEach _objs;
