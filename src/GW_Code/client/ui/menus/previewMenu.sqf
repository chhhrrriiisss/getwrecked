//
//      Name: previewMenu
//      Desc: Creates an orbiting camera around a vehicle and shows stats
//      Return: None
//

private['_raw', '_pos', '_closest', '_distance'];

_pos = (ASLtoATL getPosASL player);
_closest = [saveAreas, _pos] call findClosest; 
_distance = (_closest distance player);

if (_distance > 15) exitWith {	systemChat 'You need to be closer to use that.'; };	
_loadAreaPosition = (ASLtoATL getPosASL _closest);

_owner = ( [_closest, 8] call checkNearbyOwnership);

if (!_owner) exitWith {
    systemchat "Someone else is using this terminal.";
};

GW_LIBRARY = [] call getVehicleLibrary;

// Lock the HUD
GW_HUD_LOCK = true;

// Wait until hud locked
waitUntil{isNil "GW_HUD_INITIALIZED"};

disableSerialization;
if(!(createDialog "GW_Menu")) exitWith { GW_HUD_LOCK = false; }; 




// Misc vars
currentPreview = 0;
GW_PREVIEW_VEHICLE = nil;
GW_PREVIEW_SELECTED = nil;
currentName = '';
vehicleWasSelected = false;
firstLOAD = true;
loadError = false;

_title = ((findDisplay 42000) displayCtrl 42001);
_title ctrlSetText '';
_title ctrlCommit 0;

// Do we have a previously loaded vehicle stored?
_startIndex = 0;
if (!isNil "GW_LASTLOAD") then { _startIndex = GW_LIBRARY find GW_LASTLOAD; };
if (_startIndex == -1) then { _startIndex = 0; };

// Regenerate the filter list
[_startIndex] call generateFilterList;

// Determine start position for camera and execute
_startPos = [tempAreas, ["Car"], 15] call findEmpty;
_startPos = if (_startPos isEqualType []) then { _startPos } else { (ASLtoATL getPosASL _startPos) };
_startPos set [2,1.1];

[_startPos, 7, 0.0005, 1, 1.1] spawn previewCamera;
[_startIndex, _startPos] spawn previewVehicle;

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerStatic cutRsc ["RscStatic", "PLAIN" , 1];

// Menu has been closed, kill everything!
waitUntil{isNull (findDisplay 42000)};

// Unlock the HUD
GW_HUD_LOCK = false;

45000 cutText ["", "BLACK IN", 0.35];  

// Stop the camera
GW_PREVIEW_CAM_ACTIVE = false;

// If we're spawning something
if (!isNil "GW_PREVIEW_SELECTED" && !isNil "GW_PREVIEW_VEHICLE") then {	
	_closest = [saveAreas, (ASLtoATL visiblePositionASL player)] call findClosest; 
	[_closest] call clearPad;		

	if (!simulationEnabled GW_PREVIEW_VEHICLE) then {

		[		
			[
				GW_PREVIEW_VEHICLE,
				true
			],
			"setObjectSimulation",
			false,
			false 
		] call bis_fnc_mp;

	};

	GW_PREVIEW_VEHICLE allowDamage false;
	GW_PREVIEW_VEHICLE setPos _loadAreaPosition;

	// If vehicle is accidently thrown, reset position after 2 seconds
	[GW_PREVIEW_VEHICLE, _loadAreaPosition] spawn {
			Sleep 2;

			if ((_this select 0) distance (_this select 1) > 2) then {
				(_this select 1) set [2, 1];
				(_this select 0) setPos (_this select 1);
			};

			if (vectorUp (_this select 0) distance [0,0,1] > 0.3) then {
				(_this select 0) setVectorUp [0,0,1];
			};
			
			(_this select 0) allowDamage true;
	};
};

// Otherwise, clear up
if (isNil "GW_PREVIEW_SELECTED" && !isNil "GW_PREVIEW_VEHICLE") then {
	[GW_PREVIEW_VEHICLE, false] call clearPad;
};

_closest setVariable ['GW_Owner', '', true];

