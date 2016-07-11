//
//      Name: spawnMenu
//      Desc: Allows a user to select a deploy location for their vehicle
//      Return: None
//

private ['_unit', '_pad', '_ownership', '_owner', '_type', '_displayName'];

if (GW_SPAWN_ACTIVE) exitWith { closeDialog 0;	GW_SPAWN_ACTIVE = false; };
GW_SPAWN_ACTIVE = true;


params ['_pad', '_unit'];

_isVehicleReady = [_pad, _unit] call vehicleReadyCheck;
if (!_isVehicleReady) exitWith { GW_SPAWN_ACTIVE = false; };

_allZones = GW_VALID_ZONES;

// If we've deployed somewhere previously, show that
GW_SPAWN_LOCATION = if (!isNil "GW_LASTLOCATION") then { GW_LASTLOCATION } else {  
	
	// -2 To avoid selecting workshop
	((_allZones select (random (count _allZones -2))) select 0) 

};

_displayName = '';
_type = 'battle';
_startIndex = 0;

{
    if ((_x select 0) == GW_SPAWN_LOCATION) exitWith { _startIndex = _foreachindex; _displayName = (_x select 2); _type = (_x select 1); };
} Foreach _allZones;

// Lock the HUD
GW_HUD_LOCK = true;

// Wait until hud locked
waitUntil{isNil "GW_HUD_INITIALIZED"};

disableSerialization;
if(!(createDialog "GW_Spawn")) exitWith { GW_SPAWN_ACTIVE = false; GW_HUD_LOCK = false; };

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerStatic cutRsc ["RscStatic", "PLAIN" , 1];

[_startIndex] call generateSpawnList;

_startIndex call previewLocation;

99999 cutText ["", "BLACK IN", 0.35];  

// Menu has been closed, kill everything!
waitUntil{ (isNull (findDisplay 52000) || !GW_SPAWN_ACTIVE) };

// Lock the HUD
GW_HUD_LOCK = FALSE;

GW_SPAWN_ACTIVE = false;
GW_TARGETICON_ARRAY = [];

99999 cutText ["", "BLACK IN", 0.35];  

// Stop the camera
GW_PREVIEW_CAM_ACTIVE = false;
_pad setVariable ["owner", "", true];



