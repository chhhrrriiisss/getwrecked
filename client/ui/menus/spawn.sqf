//
//      Name: spawnMenu
//      Desc: Allows a user to select a deploy location for their vehicle
//      Return: None
//

if (GW_SPAWN_ACTIVE) exitWith { closeDialog 0;	GW_SPAWN_ACTIVE = false; };
GW_SPAWN_ACTIVE = true;

_pad = _this select 0;
_unit = _this select 1;

// Do we actually have something to deploy?
_nearby = (ASLtoATL (getPosASL _pad)) nearEntities [["Car"], 8];
if (count _nearby <= 0 && isNil "GW_LASTLOAD") exitWith {	systemChat 'You have no vehicle to deploy.'; GW_SPAWN_ACTIVE = false; };

// Check the vehicle on the pad exists, is ready and simulated
GW_SPAWN_VEHICLE = nil;
{
	_isVehicle = _x getVariable ["isVehicle", false];
	_isOwner = [_x, _unit, true] call checkOwner;	
	
	if (_isVehicle && _isOwner) exitWith {
		GW_SPAWN_VEHICLE = _x;
	};
	false
} count _nearby > 0;

if (isNil "GW_SPAWN_VEHICLE") exitWith { systemChat 'Error using this vehicle, maybe try save and load it again.'; GW_SPAWN_ACTIVE = false; };

if (!simulationEnabled GW_SPAWN_VEHICLE) then {

    [       
        [
            GW_SPAWN_VEHICLE,
            true
        ],
        "setObjectSimulation",
        false,
        false 
    ] call BIS_fnc_MP;  

};

// Wait for simulation to be enabled
_timeout = time + 3;
waitUntil{ 
	Sleep 0.1;
    if ( (time > _timeout) || simulationEnabled GW_SPAWN_VEHICLE ) exitWith { true };
    false
};

if (time > _timeout) exitWith {
    systemChat 'Vehicle needs to be placed on the ground to be deployed.';
    GW_SPAWN_ACTIVE = false;
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
    systemChat 'Please hop in this vehicle at least once before saving.';
    GW_SPAWN_ACTIVE = false;
};

// Check the vehicle has been saved at least once prior
_isSaved = GW_SPAWN_VEHICLE getVariable ["isSaved", false];
_continue = if (!_isSaved) then { (['UNSAVED VEHICLE', 'CONTINUE?', 'CONFIRM'] call createMessage) } else { true };
if (!_continue) exitWith { GW_SPAWN_ACTIVE = false; };

// Ensure the vehicle is compiled & has handlers
[GW_SPAWN_VEHICLE] call compileAttached;
[GW_SPAWN_VEHICLE] call setupLocalVehicleHandlers;

_firstCompile = GW_SPAWN_VEHICLE getVariable ["firstCompile", false];
_hasActions = GW_SPAWN_VEHICLE getVariable ["hasActions", false];

// Abort if either of the above fail
if (!_firstCompile || !_hasActions) exitWith {	systemChat 'Vehicle is not ready to deploy.'; GW_SPAWN_ACTIVE = false };

// If we've deployed somewhere previously, show that
GW_SPAWN_LOCATION = if (!isNil "GW_LASTLOCATION") then { GW_LASTLOCATION } else {  GW_VALID_ZONES select (random (count GW_VALID_ZONES -1)) };
_startIndex = (GW_VALID_ZONES find GW_SPAWN_LOCATION);

disableSerialization;
if(!(createDialog "GW_Spawn")) exitWith { GW_SPAWN_ACTIVE = false; };

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerStatic cutRsc ["RscStatic", "PLAIN" , 1];

[GW_SPAWN_LOCATION] spawn previewLocation;
[_startIndex] call generateSpawnList;

99999 cutText ["", "BLACK IN", 0.35];  

// Menu has been closed, kill everything!
waitUntil{ (isNull (findDisplay 52000) || !GW_SPAWN_ACTIVE) };

GW_SPAWN_ACTIVE = false;
GW_TARGETICON_ARRAY = [];

99999 cutText ["", "BLACK IN", 0.35];  

// Stop the camera
GW_PREVIEW_CAM_ACTIVE = false;
_pad setVariable ["owner", "", true];


