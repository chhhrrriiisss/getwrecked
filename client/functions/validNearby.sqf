//
//      Name: validNearby
//      Desc: Checks in specified radius for valid GW vehicles
//      Return: Bool (Found)
//

_source =  [_this,0, objNull, [objNull]] call BIS_fnc_param;
_range = [_this,1, 15, [0]] call BIS_fnc_param;
_found = false;

if (isNull _source) exitWith { _found };

_pos = (ASLtoATL (getPosASL _source));
_nearby = _pos nearEntities [["Car"], _range];

if (count _nearby == 0) exitWith { _found };

{
	_isVehicle = _x getVariable ["isVehicle", false];
	if (_isVehicle) exitWith {	_found = true; };
	false
} count _nearby > 0;

_found