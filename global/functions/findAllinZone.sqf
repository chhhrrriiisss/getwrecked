//
//      Name: findAllInZone
//      Desc: Finds all units in requested zone, optionally just find vehicles
//      Return: Array 
//

private ['_zone', '_arr', '_zoneCenter', '_vehiclesOnly'];

_zone = [_this, 0, "", [""]] call filterParam;
_vehiclesOnly = [_this, 1, false, [false]] call filterParam;

if (_zone isEqualTo "") exitWith { [] };
if (count allUnits isEqualTo 0) exitWith { [] };

_arr = [];

{
	// If the unit is alive and within the zone AND a player
	if (alive _x && ([(ASLtoATL getPosASL _x), _zone] call checkInZone)) then {

		_inVehicle = if ((vehicle _x) == _x) then { false } else { _x = vehicle _x; true };

		// If we're only looking for vehicles, do nothing
		if (_vehiclesOnly && !_inVehicle) then {} else {
			_arr pushback _x;
		};

	}; 

	false	
	
} count allUnits > 0;

_arr