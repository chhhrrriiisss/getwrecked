//
//      Name: previewVehicle
//      Desc: Creates a camera and updates the menu interface for vehicles stored in the library
//      Return: None
//

// Check we're not currently loading something
if (GW_WAITLOAD) exitWith {};

// Grab our dialog items
disableSerialization;
_menu = (findDisplay 42000);
_title = ((findDisplay 42000) displayCtrl 42001);	

// If there's a previously loaded vehicle
if (!isNil "GW_PREVIEW_VEHICLE") then {
	[GW_PREVIEW_VEHICLE] call clearPad;
};

// If library is blank
if (isNil "GW_LIBRARY" || { (count GW_LIBRARY == 0) } ) exitWith {	
	_title ctrlSetText 'NO VEHICLES FOUND';
	_title ctrlCommit 0;
	45000 cutText ["", "BLACK IN", 0.35];  
};

// Target the vehicle from the list
_num = [_this select 0, 0, ((count GW_LIBRARY) - 1), true] call limitToRange;
_selected = GW_LIBRARY select _num;	
currentPreview = _num;

// If we havent been given a position, generate one
_newLocation = nil;
_newPreviewCameraPosition = nil;

if (isNil "_position") then {		
	_newLocation = [tempAreas, ["Car"], 15] call findEmpty;
	_newPreviewCameraPosition = if (_newLocation isEqualType []) then { _newLocation } else { (ASLtoATL getPosASL _newLocation) };
	_newPreviewCameraPosition set [2, 1.1];	
} else {
	_newPreviewCameraPosition = _position;
};

// Get data for selected
_raw = [_selected] call getVehicleData;
if (count _raw == 0) exitWith {};

_data = _raw select 0;

_name = '';

if (count _data > 0) then {
	_name = _data select 1;
	currentName = _name;
} else {
	loadError = true;
};

// Send load request for vehicle
_prevVehicle = if (!isNil "GW_PREVIEW_VEHICLE") then { GW_PREVIEW_VEHICLE } else { nil };

if (!loadError) then {
	[_newPreviewCameraPosition, _name] spawn requestVehicle;
};

GW_PREVIEW_VEHICLE = nil;

_name = toUpper ( _name );
_nameArray = toArray (_name);
_name = [_name, 28, ''] call cropString; 

// Fade out
_title ctrlShow true;	
_title ctrlSetText 'LOADING';	
_title ctrlCommit 0;

[] spawn {
	
	disableSerialization;
	_title = ((findDisplay 42000) displayCtrl 42001);	
	_text = 'LOADING';
	_title ctrlSetText _text;
	_title ctrlCommit 0;
	_timeout = time + 15;

	waitUntil {

		_text = _text call {
			if (_this == 'LOADING') exitWith { 'LOADING.' };
			if (_this == 'LOADING.') exitWith { 'LOADING..' };
			if (_this == 'LOADING..') exitWith { 'LOADING...' };
			'LOADING'
		};

		_title ctrlSetText _text;
		_title ctrlCommit 0;

		Sleep 0.25;

		(!isNil "GW_PREVIEW_VEHICLE" || loadError || (time > _timeout) )

	};

};

45000 cutText ["", "BLACK OUT", 0.2];  

_timeout = time + 15;
waitUntil { 
	if (!isNil "GW_PREVIEW_VEHICLE" || loadError || (time > _timeout) ) exitWith { true };
	false 
};		

if (loadError || time > _timeout) then {
	_title ctrlShow true;	
	_title ctrlSetText 'ERROR LOADING';
	_title ctrlCommit 0;

} else {

	// Fade in once new vehicle detected
	45000 cutText ["", "BLACK IN", 0.35];  
	[ [42000, 42004] , GW_PREVIEW_VEHICLE] call generateStatsList;

	_title ctrlShow true;	
	_title ctrlSetText _name;
	_title ctrlCommit 0;

};

// Clear the last vehicle
if (!isNil "_prevVehicle") then {
	[_prevVehicle, false] call clearPad;
};

// Reset error detection
loadError = false;