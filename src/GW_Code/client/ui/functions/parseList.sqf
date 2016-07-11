//
//      Name: parseList
//      Desc: Generates the actual list of items and adds them to the settings list box
//      Return: None
//

private ['_a', '_bind', '_tag', '_state'];

_a = [_this,0, [], [[]]] call filterParam;

if (count _a == 0) exitWith {};

_register = [];
{
	_tag = (_x select 0);
	_obj = (_x select 1);	

	// For bags of explosives and teleport devices, ignore additional entries
	if (true) then {

		// Is it actually legit? 
		_data = [_tag, GW_LOOT_LIST] call getData;
		if (isNil "_data") exitWith {};
		
		// Used for preventing repeats of certain objects
		_register pushBack _tag;

		_totalAdded = { _x == _tag } count _register;
		_totalExists = [_tag, GW_SETTINGS_VEHICLE] call hasType;

		// Only add an entry for the last item of that type
		if (_totalAdded < _totalExists && (_tag == 'EPL' || _tag == 'TPD' || _tag == 'NPA')) exitWith {};

		// Determine the amount on the vehicle 
		_amount = if (_tag in _register && (_tag == 'EPL' || _tag == 'TPD' || _tag == 'NPA')) then {
			if (_totalExists <= 1) exitWIth { '' };
			(format ['(x%1) ', {_x == _tag} count _register])
		} else { '' };
	
		_name = format['%2 %1 ', _amount, _data select 1];
		_icon = _data select 9;

		_list lnbAddRow["", _name, "", ""];			
		_row = (((lnbSize 92001) select 0)) -1;

		// Is there an icon for this item?
		if (!isNil "_icon") then { _list lnbSetPicture[[_row, 0], _icon]; };

		// Is there an existing bind for this item?
		_bind = _obj getVariable ["GW_KeyBind", ["-1", "1"]];

		if (_tag in GW_WEAPONSARRAY) then { 

			_icon = mouseActiveIcon;

			_state = "1";
			if (_bind isEqualType []) then { 
				if ((_bind select 1) == "0") then { _icon = mouseInactiveIcon; _state = "0"; }; 			
			};

			_list lnbSetData[ [_row, 3], _state];
			_list lnbSetPicture[[_row, 3], _icon];
		};

		_key = if (_bind isEqualType []) then { (_bind select 0) } else { _bind };
		[_row, _key] call formatBind; 		
		

		// Plug the obj to the mission namespace so we can use it when saving the binds
		_idString = format['%1', [_row,0]];
		missionNamespace setVariable [_idString, _obj];

		_list lnbSetData[ [_row, 1], _tag];

	};
	
	false
} count _a > 0;	