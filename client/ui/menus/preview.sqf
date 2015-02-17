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

// Get list of all vehicles
GW_LIBRARY = profileNamespace getVariable ['GW_LIBRARY', []];

disableSerialization;
if(!(createDialog "GW_Menu")) exitWith {}; 

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
_startPos = if (typename _startPos == "ARRAY") then { _startPos } else { (ASLtoATL getPosASL _startPos) };
_startPos set [2,1.1];

[_startPos, 7, 0.0005, 1, 1.1] spawn cameraPreview;
[_startIndex, _startPos] spawn previewVehicle;

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerStatic cutRsc ["RscStatic", "PLAIN" , 1];


// Menu has been closed, kill everything!
waitUntil{isNull (findDisplay 42000)};

45000 cutText ["", "BLACK IN", 0.35];  

// Stop the camera
GW_PREVIEW_CAM_ACTIVE = false;

// If we're spawning something
if (!isNil "GW_PREVIEW_SELECTED" && !isNil "GW_PREVIEW_VEHICLE") then {	
	[_closest] call clearPad;
	GW_PREVIEW_VEHICLE setPos _loadAreaPosition;

	if (!simulationEnabled GW_PREVIEW_VEHICLE) then {

		[		
			[
				GW_PREVIEW_VEHICLE,
				true
			],
			"setObjectSimulation",
			false,
			false 
		] call BIS_fnc_MP;

	};
};

// Otherwise, clear up
if (isNil "GW_PREVIEW_SELECTED" && !isNil "GW_PREVIEW_VEHICLE") then {
	[GW_PREVIEW_VEHICLE, false] call clearPad;
};

_closest setVariable ['owner', '', true];

