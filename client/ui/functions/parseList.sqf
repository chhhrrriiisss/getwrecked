//
//      Name: parseList
//      Desc: Generates the actual list of items and adds them to the settings list box
//      Return: None
//

private ['_a'];

_a = [_this,0, [], [[]]] call BIS_fnc_param;

if (count _a == 0) exitWith {};

_register = [];
{
	_tag = (_x select 0);
	_obj = (_x select 1);
	_type = if (typeOf (_x select 1) == "groundWeaponHolder") then { (_x select 1) getVariable "type" } else { typeOf (_x select 1) };

	_data = [_type, GW_LOOT_LIST] call getData;

	// For bags of explosives, ignore additional entries
	if (isNil "_data" || (_tag in _register && _tag == 'EPL') ) then {} else {

		_name = _data select 1;	
		_icon = _data select 9;

		_list lnbAddRow["", _name, "", ""];			
		_row = (((lnbSize 92001) select 0)) -1;

		// Is there an icon for this item?
		if (!isNil "_icon") then { _list lnbSetPicture[[_row, 0], _icon]; };

		// Is there an existing bind for this item?
		_bind = _obj getVariable ["bind", nil];
		if (!isNil "_bind") then { [_row, _bind] call formatBind; };

		// Plug the obj to the mission namespace so we can use it when saving the binds
		_idString = format['%1', [_row,0]];
		missionNamespace setVariable [_idString, _obj];

		_list lnbSetData[ [_row, 1], _tag];

		// Used for preventing repeats of certain objects
		_register = _register + [_tag];

	};
	false
} count _a > 0;	