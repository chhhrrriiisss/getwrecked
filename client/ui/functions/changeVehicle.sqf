//
//      Name: changeVehicle
//      Desc: Selects a vehicle and triggers the preview menu to update
//      Return: None
//

private ["_argument", "_newPreview", "_type"];

disableSerialization;

if (GW_WAITLOAD) exitWith {};

params ['_argument'];

_newPreview = _argument;
_type = typename _argument;

if ((_type != "STRING") && (_type != "SCALAR")) exitWith {};

if (_type == "STRING") then {

	switch (_argument) do {
		case "null": { _newPreview = currentPreview; };
		case "next": { _newPreview = currentPreview + 1; };
		case "prev": { _newPreview = currentPreview - 1; };
		default { _newPreview = _argument };
	};

} else {
	_newPreview = _argument;
};

// Ensure the selected vehicle is in range of the array
_newPreview = [_newPreview, 0, (count GW_LIBRARY - 1), true] call limitToRange;

_list = ((findDisplay 42000) displayCtrl 42003);	

_list lbSetCurSel _newPreview;

// [_newPreview] spawn previewVehicle;