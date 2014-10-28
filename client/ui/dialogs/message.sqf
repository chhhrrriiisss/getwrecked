//
//      Name: createMessage
//      Desc: Create a dialog message of the specified type
//      Return: Multiple (Depends on type of message, usually bool)
//

// Close all other existing dialogs
if (GW_DIALOG_ACTIVE) then {
	GW_DIALOG_ACTIVE = false;
	closeDialog 93000;
};

_dialogString = [_this,0, "CONFIRM", [""]] call BIS_fnc_param;
_msgString = [_this,1, "", [""]] call BIS_fnc_param;
GW_DIALOG_TYPE = [_this,2, "CONFIRM", [""]] call BIS_fnc_param;

// Function used globally to close the dialog with "confirm"
confirmCurrentDialog = {

	GW_DIALOG_EXIT = switch (GW_DIALOG_TYPE) do {
		case "INPUT": {		
			disableSerialization;	
			_input = ((findDisplay 93000) displayCtrl 93001);
			(ctrlText _input)
		};
		case "CONFIRM": { true };
		default { true };
	};	

	closeDialog 0;	
};

// Function used globally to close the dialog with "cancel"
cancelCurrentDialog = {	

	GW_DIALOG_EXIT = switch (GW_DIALOG_TYPE) do {
		case "INPUT": {	'' };
		case "CONFIRM": { false };
		default	{ false };
	};	

	closeDialog 0;

};

// If the buy or settings menus are open, dont blur or static
if (!GW_SETTINGS_ACTIVE && !GW_BUY_ACTIVE && !GW_NEW_ACTIVE) then {

	"dynamicBlur" ppEffectEnable true;
	"dynamicBlur" ppEffectAdjust [0.3]; 
	"dynamicBlur" ppEffectCommit 0.25; 

	_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
	_layerStatic cutRsc ["RscStatic", "PLAIN" , 0.5];

};

disableSerialization;
if(!(createDialog "GW_Dialog")) exitWith {}; //Couldn't create the menu

GW_DIALOG_ACTIVE = true;

disableSerialization;
_title = ((findDisplay 93000) displayCtrl 93002);
_input = ((findDisplay 93000) displayCtrl 93001);
_marginTop = ((findDisplay 93000) displayCtrl 93003);
_marginBottom = ((findDisplay 93000) displayCtrl 93004);

// If no menu with margins active, remove margins
if (!GW_DEATH_CAMERA_ACTIVE && !GW_PREVIEW_CAM_ACTIVE && !GW_SPAWN_ACTIVE) then {
	_marginTop ctrlShow false;
	_marginTop ctrlCommit 0;
	_marginBottom ctrlShow false;
	_marginBottom ctrlCommit 0;
};

_input ctrlSetText _msgString;
_input ctrlEnable false;
_input ctrlShow false;
_input ctrlCommit 0;

// Custom settings for each dialog type
switch (GW_DIALOG_TYPE) do {
	case "INPUT": 
	{
		_input ctrlEnable true;		
		_input ctrlShow true;
		_input ctrlSetText toUpper(_msgString);
		_input ctrlCommit 0;	
	};

	case "LIST": 
	{
		_input ctrlShow false;		
	};

	case "CONFIRM": 
	{
		_input ctrlEnable false;		
		_input ctrlShow true;
		_input ctrlSetText toUpper(_msgString);
		_input ctrlCommit 0;		
	};
};

_title ctrlSetText toUpper(_dialogString);
_title ctrlCommit 0;

waitUntil { (isNull (findDisplay 93000) || !GW_DIALOG_ACTIVE) };

GW_DIALOG_ACTIVE = false;

if (!GW_SETTINGS_ACTIVE) then {
	"dynamicBlur" ppEffectAdjust [0]; 
	"dynamicBlur" ppEffectCommit 0.1; 
};

if (!isNil "GW_DIALOG_EXIT") exitWith {
	GW_DIALOG_EXIT
};

false
