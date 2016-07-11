//
//      Name: settingsMenu
//      Desc: Used for customizing keybinds, checking stats and renaming/unflipping the vehicle
//      Return: None
//

private ['_vehicle', '_unit'];

// Make sure we cant open it while we're deploying
if (GW_SETTINGS_ACTIVE || GW_TIMER_ACTIVE || GW_LOBBY_ACTIVE) exitWith {};
GW_SETTINGS_ACTIVE = true;

_vehicle = [_this,0, objNull, [objNull]] call filterParam;
_unit = [_this,1, objNull, [objNull]] call filterParam;

if (isNull _vehicle || isNull _unit) exitWith {};
if (!alive _vehicle || !alive _unit) exitWith {};

_isOwner = [_vehicle, _unit, true] call checkOwner;

closeSettingsMenu = {	

	// Lock inputs until we're done
	[92000, true] call toggleDisplayLock;	

	disableSerialization;
	_button = (findDisplay 92000) displayCtrl 92008;
	_button ctrlSetText "SAVING...";
	_button ctrlCommit 0;
	_success = [] call saveBinds; 

	[92000, false] call toggleDisplayLock;	
	if (!_success) exitWith { 		
		systemchat 'Error saving settings.'; 
	};

	saveProfileNamespace;
	closeDialog 0;
};

// Check the vehicle is ok to use (compiled) and we own it
if (!alive _vehicle || !alive _unit || !_isOwner) exitWith { GW_SETTINGS_ACTIVE = false; };
if (isNil { (_vehicle getVariable "firstCompile") } ) exitWith {
	systemChat 'Something is not right here... try again in a second.';
	[_vehicle] call compileAttached;
	GW_SETTINGS_ACTIVE = false;
};

// Check the vehicle is saved first before we start applying keybinds
_isSaved = _vehicle getVariable ['isSaved', false];
if (!_isSaved) exitWith {
	systemChat 'Please save your vehicle first before editing keybinds.';
	GW_SETTINGS_ACTIVE = false;
};

GW_SETTINGS_VEHICLE = _vehicle;
GW_SETTINGS_READY = false;

// Compile the vehicle anyway just to be sure
[_vehicle] call compileAttached;

disableSerialization;
if(!(createDialog "GW_Settings")) exitWith { GW_SETTINGS_ACTIVE = false; }; //Couldn't create the menu

_button = (findDisplay 92000) displayCtrl 92008;
_button ctrlSetText "SAVE & CLOSE";
_button ctrlCommit 0;

"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [0.3]; 
"dynamicBlur" ppEffectCommit 0.25; 

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerStatic cutRsc ["RscStatic", "PLAIN" , 0.5];


[92000, true] call toggleDisplayLock;

[] call generateSettingsList;

[ [92000, 92004] , GW_SETTINGS_VEHICLE, time - 5] call generateStatsList;

[] call generateTauntsList;

[92000, false] call toggleDisplayLock;

_statsTitle = (findDisplay 92000) displayCtrl 92005;
_name = [(_vehicle getVariable ["name", "UNTITLED"]), 32, "..."] call cropString;
_name = if (count toArray _name == 0) then { "UNTITLED" } else { _name };
_statsTitle ctrlSetText _name;
_statsTitle ctrlCommit 0;

// Wait a second before activating taunt preview
[] spawn {	
	Sleep 1;
	GW_SETTINGS_READY = true;
};



// Menu has been closed, kill everything!
waitUntil { (isNull (findDisplay 92000) || (!alive GW_SETTINGS_VEHICLE)) };

// Stop the preview camera
GW_PREVIEW_CAM_ACTIVE = false;
GW_SETTINGS_ACTIVE = false;
GW_SETTINGS_READY = false;

"dynamicBlur" ppEffectAdjust [0]; 
"dynamicBlur" ppEffectCommit 0.1; 





