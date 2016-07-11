//
//      Name: setupVehicle
//      Desc: Initializes a vehicle ready for playing
//      Return: None
//

private ['_data', '_vehicle', '_name', '_respawn', '_recreate', '_defaultAmmo', '_defaultFuel'];

_vehicle = [_this,0, objNull, [objNull]] call filterParam;
_name = [_this,1, "Untitled", [""]] call filterParam;

if (isNull _vehicle) exitWith { diag_log 'Couldnt initialize vehicle.'; };

_isAI = _vehicle getVariable ['isAI', false];

// Prevent two vehicles being spawned on top of the same location	
_abort = if (isNil "GW_LAST_TARGET") then { GW_LAST_TARGET = [_vehicle, diag_tickTime]; false } else {

	if ( (GW_LAST_TARGET select 0) distance (ASLtoATL visiblePositionASL _vehicle) < 12 && (diag_tickTime - (GW_LAST_TARGET select 1)) < 2) exitWith {     
		[(GW_LAST_TARGET select 0), false] call clearPad;
		true 
	};

	false
};

if (_abort) exitWith {};
GW_LAST_TARGET = [_vehicle, diag_tickTime];

// Prevent access temporarily
if (!_isAI) then {
    _vehicle lock true;
    _vehicle lockCargo true;
    _vehicle lockTurret [[0], true];
};

if (count toArray _name == 0 || _name == " ") then {  _name == 'Untitled'; };

// Custom
_vehicle setVariable["name", _name, true]; 

// Static
_vehicle setVariable["isVehicle", true, true]; 
_vehicle setVariable["killedBy", nil, true]; 
_vehicle setVariable["GW_Owner", '', true]; 
_vehicle setVariable["status", [], true]; 

// Add handlers server side
[_vehicle] call setVehicleHandlers;

// Add handlers on local client
[       
    [
        _vehicle
    ],
    "setVehicleHandlers",
    _vehicle,
    false 
] call bis_fnc_mp;

clearWeaponCargoGlobal _vehicle;
clearMagazineCargoGlobal _vehicle;
clearItemCargoGlobal _vehicle;

true