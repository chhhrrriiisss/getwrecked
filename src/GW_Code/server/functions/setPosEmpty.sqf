//
//      Name: setPosEmpty
//      Desc: Finds a location containing the selected filters nearby from a given array of objects
//      Return: Object (The location) or [0,0,0] if none found
//

// Delay requests by 0.5 second to minimize traffic
if (isNil "GW_LAST_REQUEST") then { GW_LAST_REQUEST = time - 0.5; };
_dif = (time - GW_LAST_REQUEST);
if (_dif < 0.5) exitWith {
	[_this, _dif] spawn {
		Sleep (_this select 1);
		(_this select 0) call setPosEmpty;
	};
};
GW_LAST_REQUEST = time;

private ["_arr", "_pos", "_dist", "_closest"];

_parameters = [_this,0, "", [""]] call filterParam;
if (count toArray _parameters == 0) exitWith { false };

_target = [_this,1, objNull, [objNull]] call filterParam;
if (isNull _target) exitWith { false };

_parameters = call compile _parameters;
_arr = [_parameters,0, [], [[]]] call filterParam;
if (count _arr == 0) exitWith { false };

_randomSelection = [_this,2, true, [false]] call filterParam;

_search = [_parameters,1, ["Car"], [[]]] call filterParam;
_range = [_parameters,2, 15, [0]] call filterParam;

_empty = [0,0,0];
_emptyArr = [];

{
	_type = typename _x;		
	_pos = switch (typename _x) do { 
		case "OBJECT": { getPosATL _x }; 
		case "MARKER": { getMarkerPos _x };
		case "ARRAY": { _x }; 
		default { _x };
	};

	_nearby = _pos nearEntities [_search, _range];

	// Yup there's nothing here
	if (count _nearby <= 0) then {
		_emptyArr pushback _x;
	};	

} ForEach _arr;

if (count _emptyArr == 0) exitWith { false };

// Return a random one from the list of empty ones
_selectedLocation = if (_randomSelection) then { (_emptyArr call BIS_fnc_selectRandom) } else { (_emptyArr select 0) };

if (typename _selectedLocation == "OBJECT") exitWith {
	_target setDir (getDir _selectedLocation);
	_target setPos (getPos _selectedLocation);
	true
};

if (typename _selectedLocation == "ARRAY") exitWith {
	_target setPos _selectedLocation;
	true
};

if (typename _selectedLocation == "MARKER") exitWith {
	_target setPos (getMarkerPos _selectedLocation);
	true
};


