//
//      Name: generateSettingsList
//      Desc: Create a list of bindable keys for all attached modules
//      Return: None
//

private ['_list', '_weaponsList', '_tacticalList'];

disableSerialization;
_list = ((findDisplay 92000) displayCtrl 92001);


// Select the previous row after list refresh
// [_list, _index] spawn {

// 	Sleep 0.05;
// 	disableSerialization;
// 	//(_this select 0) lnbSetCurSelRow (_this select 1);

// };

ctrlShow[92001, true]; 

lnbClear _list;

reservedIndexes = [];

_weaponsList = GW_SETTINGS_VEHICLE getVariable ["weapons", []];
_tacticalList = GW_SETTINGS_VEHICLE getVariable ["tactical", []];
_bindsList = GW_SETTINGS_VEHICLE getVariable ["GW_Binds", []];

// If the vehicle binds haven't already been defined, set them
if (count _bindsList == 0) then {
	_bindsList = GW_BINDS_ORDER;
	GW_SETTINGS_VEHICLE setVariable ["GW_Binds", GW_BINDS_ORDER];
};

_list lnbAddRow["OFFENSIVE", "", ""];
call addReservedIndex; // This is a category header so it shouldn't be bindable

// Create a list of weapon items
[_weaponsList] call parseList;

if (count _weaponsList <= 0) then {
	_list lnbAddRow["", "None Found", ""];
	_list lnbSetPicture[[((((lnbSize 92001) select 0)) -1), 0], clearIcon];
	call addReservedIndex;
};

_list lnbAddRow["TACTICAL", "", ""];
call addReservedIndex;

// Create a list of tactical items
[_tacticalList] call parseList;

if (count _tacticalList <= 0) then {
	_list lnbAddRow["", "None Available", ""];
	_list lnbSetPicture[[((((lnbSize 92001) select 0)) -1), 0], clearIcon];
	call addReservedIndex;
};

_list lnbAddRow["GENERAL", "", ""];
call addReservedIndex;

// Loop through vehicle binds
{
	_tag = (_x select 0);
	_key = (_x select 1);

	_string = _tag call {
		if (_this == "HORN") exitWith { [hornIcon, "Play Taunt"] };
		if (_this == "UNFL") exitWith { [rotateCCWIcon, "Push Vehicle"] };
		if (_this == "EPLD" && ( ((['EPL', GW_SETTINGS_VEHICLE] call hasType) > 0) || count (GW_SETTINGS_VEHICLE getVariable ['GW_detonateTargets', []]) > 0)   ) exitWith { [warningIcon, "Detonate Explosives"] };		
		if (_this == "TELP" && ( ((['TPD', GW_SETTINGS_VEHICLE] call hasType) > 0) || count (GW_SETTINGS_VEHICLE getVariable ['GW_teleportTargets', []]) > 0)   ) exitWith { [tpdIcon, "Activate Teleport"] };
		if (_this == "LOCK" && {

			// Check we have at least one lock on on this vehicle
			_exists = false;
			{	if (([_x, GW_SETTINGS_VEHICLE] call hasType) > 0) exitWith { _exists = true; };	false } count GW_LOCKONWEAPONS > 0;
			_exists
		}) exitWith { [lockingIcon, "Toggle Auto-Lock"] };
		if (_this == "OILS" && ((['OIL', GW_SETTINGS_VEHICLE] call hasType) > 0) ) exitWith { [oilslickIcon, "Stop Oil Slick"] };
		if (_this == "DCLK" && ((['CLK', GW_SETTINGS_VEHICLE] call hasType) > 0) ) exitWith { [cloakIcon, "Deactivate Cloak"] };
		if (_this == "PARC" && ((['PAR', GW_SETTINGS_VEHICLE] call hasType) > 0) ) exitWith { [ejectIcon, "Cut Parachute"] };
		
		[warningIcon, ""]
	};

	_icon = _string select 0;
	_string = _string select 1;
	
	// Dont bother adding an entry for a weapon we don't have
	if (true) then {

		if (count toArray _string == 0) exitWith {};
	
		_list lnbAddRow["", _string, ""];
		_row = ((((lnbSize 92001) select 0)) -1);

		if (!isNil "_key") then { [_row, _key] call formatBind; };

		if (!isNil "_icon") then {
			_list lnbSetPicture[[_row, 0], _icon];
		};

		_list lnbSetData[[_row, 1], _tag];

		// Plug the vehicle to the mission namespace so we can use it when saving the binds
		_idString = format['%1', [_row,0]];
		missionNamespace setVariable [_idString, GW_SETTINGS_VEHICLE];
	};

	false

} count _bindsList;

_list lnbAddRow["GLOBAL", "", ""];
call addReservedIndex;

_globalBindsList = [] call listGlobalBinds;

{

	_tag = _x select 0;
	_key = _x select 1;

	_data = _tag call {
		if (_this == "SETTINGS") exitWith { [settingsIcon, "Settings"] };
		if (_this == "GRAB") exitWith { [moveIcon, "Grab / Drop"] };
		if (_this == "ATTACH") exitWith { [attachIcon, "Attach / Detach"] };
		if (_this == "ROTATECW") exitWith { [rotateCWIcon, "Rotate CW"] };
		if (_this == "ROTATECCW") exitWith { [rotateCCWIcon, "Rotate CCW"] };
		if (_this == "HOLD") exitWith { [cameraRotateIcon, "Hold Rotate"] };
		if (_this == "INFO") exitWith { [infoIcon, "Item Info"] };
		[]
	};

	if (true) then {

		if (count _data == 0) exitWith {};

		_icon = _data select 0;
		_string = _data select 1;

		if (count toArray _string == 0) exitWith {};
	
		_list lnbAddRow["", _string, ""];
		_row = ((((lnbSize 92001) select 0)) -1);
		
		if (!isNil "_key") then { [_row, _key] call formatBind; };

		if (!isNil "_icon") then {
			_list lnbSetPicture[[_row, 0], _icon];
		};

		_list lnbSetData[[_row, 1], _tag];

		// Plug the vehicle to the mission namespace so we can use it when saving the binds
		_idString = format['%1', [_row,0]];
		missionNamespace setVariable [_idString, player];
	};

} count _globalBindsList;

// Always add a blank row to pad bottom
_list lnbAddRow["", "", " "];		
call addReservedIndex;

_list ctrlSetTooltip "Double click, then press key to set bind.";
