//
//      Name: markIntersects
//      Desc: Tags all objects intersecting path as killed by local player
//      Return: None
//

private ['_src', '_des', '_objs', '_m'];
params ['_src', '_des', '_m'];

if (count _src == 0 || count _des == 0) exitWith {};

_objs = lineIntersectsWith [_src, _des, GW_CURRENTVEHICLE, objNull, false];

if (count _objs == 0) exitWith {};

{
	[_x, _m] call checkMark;
	false
} count _objs > 0;
