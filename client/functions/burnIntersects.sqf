//
//      Name: burnIntersects
//      Desc: Sets on fire any vehicles between two ASL points
//      Return: None
//

private ['_source', '_destination', '_ignore', '_chance', '_minDuration'];

_source = _this select 0;
_destination = _this select 1;
_ignore = [_this,2, objNull, [objNull]] call BIS_fnc_param;	
_chance = [_this,3, 15, [0]] call BIS_fnc_param; // Chance of setting something alight default 15%
_minDuration = [_this,4, 3, [0]] call BIS_fnc_param; // Duration

_objects = lineIntersectsWith [_source, _destination, _ignore, objNull, false];

if (count _objects == 0) exitWith {};

{	
	[_x, _chance, _minDuration] spawn setVehicleOnFire;
	false
} count _objects > 0;

