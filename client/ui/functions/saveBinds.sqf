//
//      Name: saveBinds
//      Desc: Save all binds in the settings list to their respective objects
//      Return: None
//

private ['_list', '_listLength', '_binds'];

disableSerialization;
_list = ((findDisplay 92000) displayCtrl 92001);
_listLength = if (isNil { ((lnbSize 92001) select 0) }) then { 0 } else { ((lnbSize 92001) select 0) };
_binds = [];

_index = if (isNIl {_this select 0}) then { 0 } else { (_this select 0) };

for "_i" from 0 to _listLength step 1 do {

	if (_i in reservedIndexes) then {} else {

		_obj = missionNamespace getVariable [format['%1', [_i,0]], nil];
		_tag = _list lnbData [_i, 1];
		_key = _list lnbData [_i, 2];
		_mouse = _list lnbData [_i, 3];

		if (!isNil "_obj") then {

			// If its a bag of explosives, apply the bind to every bag
			if (typeof _obj == "Land_Sacks_heap_F") then {

				{
					if ((_x select 0) == "EPL") then {
						(_x select 1) setVariable ["GW_KeyBind", [_key, "0"], true];
					};
					false
				} count (GW_SETTINGS_VEHICLE getVariable ["tactical", []]) > 0;

			} else {

				// If it's a vehicle bind
				if (_obj == GW_SETTINGS_VEHICLE) then {

					_bindsList = GW_SETTINGS_VEHICLE getVariable ["GW_Binds", []];

					{
						if ((_x select 0) == _tag) then {
							_x set [1, _key];
						};

					} Foreach _bindsList;

					GW_SETTINGS_VEHICLE setVariable ["GW_Binds", _bindsList];

				} else {
				
					_mouse = if (isNil "_mouse") then { "1" } else { _mouse };
					_key = if (isNil "_key") then { "-1" } else { _key };
					_obj setVariable ["GW_KeyBind", [_key, _mouse], true];

				};

			};

		};

	};

};

[_list, _index] spawn {

	Sleep 0.05;
	disableSerialization;
	(_this select 0) lnbSetCurSelRow (_this select 1);

};