//
//      Name: findAllInZone
//      Desc: Finds all units in requested zone, optionally just find vehicles
//      Return: Array 
//

private ['_zone', '_arr', '_zoneCenter', '_vehiclesOnly'];

_zone = _this select 0;
_vehiclesOnly = if (isNil {_this select 1}) then { false } else { (_this select 1) };

if (_zone == "") exitWith { [] };

_arr = [];

// Get the camera marker for the specified zone
if (count allUnits <= 0) exitWith { [] };

{
	// If the unit is alive and within the zone
	if (alive _x && { ([(getPos _x), _zone] call checkInZone) }) then {

		// If the target is in a vehicle, add the vehicle
		_target = if ( (vehicle _x) == _x) then { _x } else { (vehicle _x) };

		// If we're only looking for vehicles, do nothing
		if (_vehiclesOnly && (vehicle _x) == _x) then {} else {
			_arr pushback _target;
		};

	}; 

	false	
	
} count allUnits > 0;

_arr