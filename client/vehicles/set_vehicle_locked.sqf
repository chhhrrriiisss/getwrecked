//
//      Name: setVehicleLocked
//      Desc: Locks access to a vehicle by disabling driver and inventory access
//      Return: None
//

private ['_vehicle', '_tx', '_class', '_file', '_path'];

_vehicle = [_this,0, ObjNull, [ObjNull]] call filterParam;
_lock = [_this,1, true, [false]] call filterParam;

if(isNull _vehicle) exitWith { diag_log 'Cant lock or unlock null vehicle'; };

// If it's not our vehicle, send this function to the owner
if (!local _vehicle) exitWith { 

	[       
	    [
	        _vehicle,
	        _lock
	    ],
	    "setVehicleLocked",
	    _vehicle,
	    false 
	] call bis_fnc_mp;  

};

// Always lock the cargo & turret
_vehicle lockCargo true;
_vehicle lockTurret [[0,0], true];

// Disable simulation, lock driver
if (_lock) exitWith {

	if (!lockedDriver _vehicle) then {
		_vehicle lockDriver true;
	};

};

// Enable simulation, unlock driver
if (!_lock) exitWith {

	if (lockedDriver _vehicle) then {
		_vehicle lockDriver false;
	};

};


