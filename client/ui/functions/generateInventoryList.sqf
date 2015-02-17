//
//      Name: generateInventoryList
//      Desc: Creates a list of available items for a supply box UI
//      Return: None
//

private ['_list', '_contents'];

disableSerialization;
_list = ((findDisplay 98000) displayCtrl 98001);
_forceIndex = if (isNil { _this select 1}) then { 0 } else { (_this select 1) };

ctrlShow[98001, true]; 

lnbClear _list;

_contents = (_this select 0) getVariable ["GW_Inventory", []];

// If there's nothing in it, dont bother going any further
if (count _contents == 0) exitWith {
	_list lnbAddRow["No items found."];
};

{
	
	_quantity = _x select 0;
	_class = _x select 1;

	// Validate it as a useable item 
	_data = [_class, GW_LOOT_LIST] call getData;

	if (isNil "_data") then {} else {

		_name = _data select 1;
		_icon = _data select 9;

		_list lnbAddRow[format['%1x', _quantity],"", _name, ""];
		lnbSetData [98001, [((((lnbSize 98001) select 0)) -1), 0], _class];

		// Do we have an icon we can use?
		if (!isNil "_icon") then {
			_list lnbSetPicture[[((((lnbSize 98001) select 0)) -1), 1], _icon];
		};

	};
	false
} count _contents > 0;

_list lnbSetCurSelRow _forceIndex;