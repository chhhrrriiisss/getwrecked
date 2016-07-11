//
//      Name: findUnit
//      Desc: Finds a player (unit) object from a string
//      Return: Object (the unit)
//

private ['_target', '_result', '_unit', '_arr', '_exit', '_result'];

_target = [_this,0, "", [""]] call filterParam;
_isAI = [_this,1, false, [false]] call filterParam;

if (_target == "") exitWith { objNull };

_result = objNull;
_exit = false;

_arr = if (!_isAI) then {
	allPlayers
} else {
	allUnits
};

{
	_unit = _x;
	if (alive _unit) then {	if ((name _unit) == _target) exitWith {	_result = _unit; _exit = true; }; };
	if (_exit) exitWith {};
	false
} count _arr > 0;

_result