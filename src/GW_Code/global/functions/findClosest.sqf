//
//      Name: findClosest
//      Desc: Finds closest object from array
//      Return: Object (The closest one)
//

private ["_arr", "_pos", "_dist", "_closest"];

_arr = [_this,0, [], [[]]] call filterParam;
_pos = [_this,1, [], [[]]] call filterParam;
_dist = 999999;

if (count _arr == 0 || count _pos == 0) exitWith { player };

// Select the first item in the array as a default
_closest = (_arr select 0);

{
	_d = _x distance _pos;

	if (_d < _dist) then {
		_closest = _x;
		_dist = _d;
	};
	false
} count _arr > 0;

_closest