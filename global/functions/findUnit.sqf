//
//      Name: findUnit
//      Desc: Finds a player (unit) object from a string
//      Return: Object (the unit)
//

private ['_target', '_result'];

_target = [_this,0, "", [""]] call BIS_fnc_param;

if (_target == "") exitWith { objNull };

_result = objNull;

{
	_unit = _x;
	if ((name _unit) == _target) exitWith {	_result = _unit; };
	false
} count (call allPlayers) > 0;

_result