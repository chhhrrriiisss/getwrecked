//
//      Name: findAllInZone
//      Desc: Finds all units in requested zone, optionally just find vehicles
//      Return: Array 
//

private ['_zone', '_arr', '_zoneCenter', '_vehiclesOnly'];

_zone = [_this,0, "", [""]] call BIS_fnc_param;	
_vehiclesOnly =  [_this,1, false, [false]] call BIS_fnc_param;	

if (_zone == "") exitWith {};

_arr = [];

// Get the camera marker for the specified zone
_zoneCenter = getMarkerPos format['%1_camera', _zone];

if (count allUnits <= 0) exitWith { [] };

{
	// If the unit is alive and within range of the marker
	if (alive _x && { (_x distance _zoneCenter) < 2200 }) then {

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