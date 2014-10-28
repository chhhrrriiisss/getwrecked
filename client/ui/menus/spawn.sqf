//
//      Name: spawnMenu
//      Desc: Allows a user to select a deploy location for their vehicle
//      Return: None
//

if (GW_SPAWN_ACTIVE) exitWith {};
GW_SPAWN_ACTIVE = true;

_pad = _this select 0;
_unit = _this select 1;

// Do we actually have something to deploy?
_nearby = (ASLtoATL (getPosASL _pad)) nearEntities [["Car"], 8];
if (count _nearby <= 0) exitWith {	systemChat 'You have no vehicle to deploy.'; GW_SPAWN_ACTIVE = false; };

// Check the vehicle on the pad exists, is ready and simulated
GW_SPAWN_VEHICLE = nil;
{
	_isVehicle = _x getVariable ["isVehicle", false];
	_simulated = simulationEnabled _x;
	_isOwner = [_x, _unit, true] call checkOwner;	
	
	if (_isVehicle && _isOwner && _simulated) exitWith {
		GW_SPAWN_VEHICLE = _x;
	};
	false
} count _nearby > 0;

if (isNil "GW_SPAWN_VEHICLE") exitWith { systemChat 'No valid vehicle found.'; GW_SPAWN_ACTIVE = false; };

// Check the vehicle has been saved at least once prior
_isSaved = GW_SPAWN_VEHICLE getVariable ["isSaved", false];
_continue = if (!_isSaved) then { (['UNSAVED VEHICLE', 'CONTINUE?', 'CONFIRM'] call createMessage) } else { true };
if (!_continue) exitWith {};

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


