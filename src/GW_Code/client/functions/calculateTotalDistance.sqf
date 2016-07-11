//
//      Name: calculateTotalDistance
//      Desc: Calculate total distance between all points or objects in an array
//			  (optional) Return as formatted string or number
//      Return: Distance
//

params ['_array', '_returnAsString'];
private ['_array', '_returnAsString'];

if (isNil "_returnAsString") then { _returnAsString = true; };

_d = 0;
{
	if (_foreachIndex == ((count _array) - 1)) exitWith {};

	_p1 = if (_x isEqualType objNull) then { (ASLtoATL visiblePositionASL _x) } else { _x };
	_next = (_array select (_foreachIndex + 1));
	_p2 = if (_next isEqualType objNull) then { (ASLtoATL visiblePositionASL _next) } else { _next };
	_d = _d + (_p1 distance _p2);
	
} foreach _array;	


if (!_returnAsString) exitWith { _d };

_d = if (_d > 1000) then { format['%1km', [_d / 1000, 1] call roundTo ] } else { format['%1m', [_d, 1] call roundTo ]};

_d