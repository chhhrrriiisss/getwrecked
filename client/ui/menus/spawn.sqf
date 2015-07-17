//
//      Name: spawnMenu
//      Desc: Allows a user to select a deploy location for their vehicle
//      Return: None
//

private ['_unit', '_pad', '_ownership', '_owner', '_type', '_displayName'];

if (GW_SPAWN_ACTIVE) exitWith { closeDialog 0;	GW_SPAWN_ACTIVE = false; };
GW_SPAWN_ACTIVE = true;

params ['_pad', '_unit'];
 
_onExit = {
    systemChat (_this select 0);
    GW_SPAWN_ACTIVE = false;
};


// Do we actually have something to deploy?
_nearby = (ASLtoATL visiblePositionASL _pad) nearEntities [["Car", "Tank"], 8];
if (({

    if (_x != (vehicle player)) exitWith { 1 };
    false

} count _nearby) isEqualTo 0 || isNil "GW_LASTLOAD") exitWith { ['You have no vehicle to deploy.'] spawn _onExit; };

// Check ownership
_owner = ( [_pad, 8] call checkNearbyOwnership);

if (!_owner) exitWith {
    ["You don't own this vehicle."] spawn _onExit;
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
        ['No valid vehicle found. Try load or save again.'] spawn _onExit;
    } else {
        ["You don't own this vehicle."] spawn _onExit;
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
    ["Vehicle needs to be placed on the ground to be deployed."] spawn _onExit;
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
    ["Badly spawned vehicle, you should probably start again."] spawn _onExit;
};

// Check the vehicle has been saved at least once prior
_isSaved = GW_SPAWN_VEHICLE getVariable ["isSaved", false];
_continue = if (!_isSaved) then { (['UNSAVED VEHICLE', 'CONTINUE?', 'CONFIRM'] call createMessage) } else { true };

GW_SPAWN_ACTIVE = if (typename _continue == "BOOL") then {
    if (!_continue) exitWith { false };
    true
} else { false };

if (!GW_SPAWN_ACTIVE) exitWith {};

// Ensure the vehicle is compiled & has handlers
[GW_SPAWN_VEHICLE] call compileAttached;

_firstCompile = GW_SPAWN_VEHICLE getVariable ["firstCompile", false];
_hasActions = GW_SPAWN_VEHICLE getVariable ["hasActions", false];

// Abort if either of the above fail
if (!_firstCompile || !_hasActions) exitWith {	
     ["Vehicle is not ready to deploy."] spawn _onExit;
};

_allZones = GW_VALID_ZONES;

// If we've deployed somewhere previously, show that
GW_SPAWN_LOCATION = if (!isNil "GW_LASTLOCATION") then { GW_LASTLOCATION } else {  ((_allZones select (random (count _allZones -1))) select 0) };
_displayName = '';
_type = 'battle';
_startIndex = 0;


{
    if ((_x select 0) == GW_SPAWN_LOCATION) exitWith { _startIndex = _foreachindex; _displayName = (_x select 2); _type = (_x select 1); };
} Foreach _allZones;

disableSerialization;
if(!(createDialog "GW_Spawn")) exitWith { GW_SPAWN_ACTIVE = false; };

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerStatic cutRsc ["RscStatic", "PLAIN" , 1];

[_startIndex] call generateSpawnList;

[GW_SPAWN_LOCATION, _displayName,_type] spawn previewLocation;

99999 cutText ["", "BLACK IN", 0.35];  

// Menu has been closed, kill everything!
waitUntil{ (isNull (findDisplay 52000) || !GW_SPAWN_ACTIVE) };

GW_SPAWN_ACTIVE = false;
GW_TARGETICON_ARRAY = [];

99999 cutText ["", "BLACK IN", 0.35];  

// Stop the camera
GW_PREVIEW_CAM_ACTIVE = false;
_pad setVariable ["owner", "", true];


