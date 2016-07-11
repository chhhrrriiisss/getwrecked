//
//      Name: vehicleReadyCheck
//      Desc: Check vehicle is owned by us, ready to deploy and compiled correctly
//      Return: Bool (ready or not)
//

params ['_pad', '_unit'];

_onExit = {
    systemChat (_this select 0);
    GW_SPAWN_ACTIVE = false;
    GW_RACE_GENERATOR_ACTIVE = false;
    false
};

// Do we actually have something to deploy?
_nearby = (ASLtoATL visiblePositionASL _pad) nearEntities [["Car", "Tank"], 8];
if (({
    if (_x != (vehicle player)) exitWith { 1 };
    false
} count _nearby) isEqualTo 0 || isNil "GW_LASTLOAD") exitWith { ['You have no vehicle to use.'] call _onExit; };

// Check ownership
_owner = ( [_pad, 8] call checkNearbyOwnership);

if (!_owner) exitWith {
    ["You don't own this vehicle."] call _onExit;
};

// Check the vehicle on the pad exists, is ready and simulated
GW_SPAWN_VEHICLE = nil;
_ownership = false;
{
	_isVehicle = _x getVariable ["isVehicle", false];
	_isOwner = [_x, _unit, true] call checkOwner;	
	
    _ownership = _isOwner;
	if (_isVehicle && _isOwner) exitWith {
		GW_SPAWN_VEHICLE = _x;
	};
	false
} count _nearby > 0;

if (isNil "GW_SPAWN_VEHICLE") exitWith { 
    if (_ownership) then {
        ['No valid vehicle found. Try load or save again.'] call _onExit;
    } else {
        ["You don't own this vehicle."] call _onExit;
    };
};

if (!simulationEnabled GW_SPAWN_VEHICLE) then {

    [       
        [
            GW_SPAWN_VEHICLE,
            true
        ],
        "setObjectSimulation",
        false,
        false 
    ] call bis_fnc_mp;  

};

// Wait for simulation to be enabled
_timeout = time + 3;
waitUntil{ 
	Sleep 0.1;
    if ( (time > _timeout) || simulationEnabled GW_SPAWN_VEHICLE ) exitWith { true };
    false
};

if (time > _timeout) exitWith {
    ["Vehicle needs to be placed on the ground to be deployed."] call _onExit;
};

// Check it's a valid vehicle and if not wait for it to be compiled
_allowUpgrade = GW_SPAWN_VEHICLE getVariable ['isVehicle', false];

if (!_allowUpgrade) then {
    [_closest] call compileAttached;    
};

_timeout = time + 3;
waitUntil{ 
	Sleep 0.1;
    _valid = GW_SPAWN_VEHICLE getVariable ['isVehicle', false];
    if ( (time > _timeout) || _valid ) exitWith { true };
    false
};

if (time > _timeout) exitWith {
    ["Badly spawned vehicle, you should probably start again."] call _onExit;
};

// Check the vehicle has been saved at least once prior
_isSaved = GW_SPAWN_VEHICLE getVariable ["isSaved", false];
_continue = if (!_isSaved) then { (['UNSAVED VEHICLE', 'CONTINUE?', 'CONFIRM'] call createMessage) } else { true };

GW_SPAWN_ACTIVE = if (_continue isEqualType true) then {
    if (!_continue) exitWith { false };
    true
} else { false };

if (!GW_SPAWN_ACTIVE) exitWith {   
     ["Aborted by user."] call _onExit;
};

// Ensure the vehicle is compiled & has handlers
[GW_SPAWN_VEHICLE] call compileAttached;

_firstCompile = GW_SPAWN_VEHICLE getVariable ["firstCompile", false];
_hasActions = GW_SPAWN_VEHICLE getVariable ["hasActions", false];

// Abort if either of the above fail
if (!_firstCompile || !_hasActions) exitWith {	
     ["Vehicle is not ready to deploy."] call _onExit;
};

true