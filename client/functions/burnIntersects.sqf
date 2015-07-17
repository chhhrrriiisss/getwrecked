//
//      Name: burnIntersects
//      Desc: Sets on fire any vehicles between two ASL points
//      Return: None
//

private ['_ignore', '_chance', '_minDuration'];

params ['_source', '_destination'];

_ignore = [_this,2, objNull, [objNull]] call filterParam;	
_chance = [_this,3, 15, [0]] call filterParam; // Chance of setting something alight default 15%
_minDuration = [_this,4, 3, [0]] call filterParam; // Duration

_objects = lineIntersectsWith [_source, _destination, _ignore, objNull, false];

if (count _objects == 0) exitWith {};

{	
	[_x, _chance, _minDuration] spawn setVehicleOnFire;
	false
} count _objects > 0;

