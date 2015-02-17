//
//      Name: setQuantityUsingKey
//      Desc: Sets an item quantity for a buy menu row via 0-9
//		Note: Something wierd sometimes happens with the 1 key
//      Return: None
//

private ['_list', '_index', '_key'];

disableSerialization;
_list = ((findDisplay 97000) displayCtrl 97001);
_index = lnbcurselrow _list;
_key = [_this,0, -1, [0]] call BIS_fnc_param;

if (_key == -1) exitWith {};
if (_key == 11) then {

	// Key is zero, clear the row
	lnbSetText [97001, [_index, 0], "-"];
	lnbSetData [97001, [_index, 0], ""];

} else {
	_value = _key - 1;
	lnbSetText [97001, [_index, 0], format['%1x', _value]];
	lnbSetData [97001, [_index, 0], format['%1', _value]];
};

// Recalculate
_null = [] call calculateTotal;

[_list, _index] spawn {
	Sleep 0.1;
	disableSerialization;
	(_this select 0) lnbSetCurSelRow (_this select 1);
};