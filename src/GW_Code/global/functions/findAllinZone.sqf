//
//      Name: findAllInZone
//      Desc: Finds all units in requested zone, optionally just find vehicles
//      Return: Array 
//

private ['_zone', '_arr', '_zoneCenter', '_vehiclesOnly'];

_zone = [_this, 0, "", [""]] call filterParam;
_filterToApply = [_this, 1, { true }, [{}]] call filterParam;
_useManifest = [_this, 2, true, [false]] call filterParam;

if (_zone isEqualTo "") exitWith { [] };

if (_useManifest) exitWith {

	_unitsInZone = [];

	{
		if ((_x select 1) == _zone) then { _unitsInZone pushback (_x select 0);	};
		false
	} count GW_ZONE_MANIFEST > 0;

	_unitsInZone

};

if (count allUnits isEqualTo 0) exitWith { [] };

_arr = [];
_isGlobal = if (_zone == "globalZone") then { true } else { false };

{
	// If the unit is alive
	if (alive _x) then {

		// If we're checking global, look for zone immunity
		_zoneImmune = (vehicle _x) getVariable ['GW_ZoneImmune', false];
		if (_isGlobal && !_zoneImmune) exitWith {};

		// Otherwise check the position
		_inZone = if (_isGlobal) then { true } else { ([(ASLtoATL getPosASL _x), _zone] call checkInZone) };
		if (!_inZone) exitWith {};

		// Check the vehicle matches the filter
		_condition = _x call _filterToApply;
		if (!_condition) exitWith {};

		_arr pushback _x;
	
	}; 

	false	
	
} count allUnits > 0;

_arr