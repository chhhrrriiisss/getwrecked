//
//      Name: generateSettingsList
//      Desc: Create a list of bindable keys for all attached modules
//      Return: None
//

private ['_list', '_weaponsList', '_tacticalList'];

disableSerialization;
_list = ((findDisplay 92000) displayCtrl 92001);

ctrlShow[92001, true]; 

lnbClear _list;

reservedIndexes = [];

_weaponsList = GW_SETTINGS_VEHICLE getVariable ["weapons", []];
_tacticalList = GW_SETTINGS_VEHICLE getVariable ["tactical", []];

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

// Always add a blank row to pad bottom
_list lnbAddRow["", "", " "];		
call addReservedIndex;