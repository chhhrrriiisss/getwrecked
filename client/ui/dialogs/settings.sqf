//
//      Name: settingsMenu
//      Desc: Used for customizing keybinds, checking stats and renaming/unflipping the vehicle
//      Return: None
//

private ['_vehicle', '_unit'];

// Make sure we cant open it while we're deploying
if (GW_SETTINGS_ACTIVE || GW_TIMER_ACTIVE) exitWith {};
GW_SETTINGS_ACTIVE = true;

_vehicle = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_unit = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _vehicle || isNull _unit) exitWith {};

_isOwner = [_vehicle, _unit, true] call checkOwner;

// Check the vehicle is ok to use (compiled) and we own it
if (!alive _vehicle || !alive _unit || !_isOwner) exitWith { GW_SETTINGS_ACTIVE = false; };
if (isNil { (_vehicle getVariable "firstCompile") } ) exitWith {
	systemChat 'Something is not right here... try again in a second.';
	[_vehicle] call compileAttached;
	GW_SETTINGS_ACTIVE = false;
};

GW_SETTINGS_VEHICLE = _vehicle;
GW_SETTINGS_READY = false;

// Compile the vehicle anyway just to be sure
[_vehicle] call compileAttached;

disableSerialization;
if(!(createDialog "GW_Settings")) exitWith { GW_SETTINGS_ACTIVE = false; }; //Couldn't create the menu

"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [0.3]; 
"dynamicBlur" ppEffectCommit 0.25; 

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerStatic cutRsc ["RscStatic", "PLAIN" , 0.5];

[] spawn generateSettingsList;
[ [92000, 92004] , GW_SETTINGS_VEHICLE] spawn generateStatsList;

[] spawn generateTauntsList;

_statsTitle = (findDisplay 92000) displayCtrl 92005;
_name = [(_vehicle getVariable ["name", "UNTITLED"]), 27, "..."] call cropString;
_name = if (count toArray _name == 0) then { "UNTITLED" } else { _name };
_statsTitle ctrlSetText _name;
_statsTitle ctrlCommit 0;

systemChat 'Note: Key binds are saved only when the vehicle is saved.';

// Wait a second before activating taunt preview
[] spawn {	
	Sleep 1;
	GW_SETTINGS_READY = true;
};

// Menu has been closed, kill everything!
waitUntil { isNull (findDisplay 92000) };

// Stop the preview camera
GW_PREVIEW_CAM_ACTIVE = false;
GW_SETTINGS_VEHICLE = nil;
GW_SETTINGS_ACTIVE = false;
GW_SETTINGS_READY = false;

"dynamicBlur" ppEffectAdjust [0]; 
"dynamicBlur" ppEffectCommit 0.1; 


