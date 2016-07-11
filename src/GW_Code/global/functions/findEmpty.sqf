//
//      Name: findEmpty
//      Desc: Finds a location containing the selected filters nearby from a given array of objects
//      Return: Object (The location) or [0,0,0] if none found
//

private ["_arr", "_pos", "_dist", "_closest"];

_arr = [_this,0, [], [[]]] call filterParam;
_search = [_this,1, ["Car"], [[]]] call filterParam;
_range = [_this,2, 15, [0]] call filterParam;

if (count _arr == 0) exitWith {};

_empty = [0,0,0];
_emptyArr = [];

{
	_type = typename _x;		
	_pos = switch (typename _x) do { 
		case "OBJECT": { getPosATL _x }; 
		case "MARKER": { getMarkerPos _x };
		case "ARRAY": { _x }; 
		case "LOCATION": { _x }; 
		default { _x };
	};

	_nearby = _pos nearEntities [_search, _range];

	// Yup there's nothing here
	if (count _nearby <= 0) then {
		_emptyArr pushback _x;
	};	

} ForEach _arr;

if (count _emptyArr == 0) exitWith { _empty };

// Return a random one from the list of empty ones
(_emptyArr call BIS_fnc_selectRandom)
