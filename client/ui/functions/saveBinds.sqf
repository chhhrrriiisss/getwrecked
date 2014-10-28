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

for "_i" from 0 to _listLength step 1 do {

	if (_i in reservedIndexes) then {} else {

		_obj = missionNamespace getVariable [format['%1', [_i,0]], nil];
		_tag = _list lnbData [_i, 1];
		_key = _list lnbData [_i, 2];

		if (!isNil "_obj") then {

			// If its a bag of explosives, apply the bind to every bag
			if (typeof _obj == "Land_Sacks_heap_F") then {

				{
					if ((_x select 0) == "EPL") then {
						(_x select 1) setVariable ["bind", _key];
					};
					false
				} count (GW_SETTINGS_VEHICLE getVariable ["tactical", []]) > 0;

			} else {
				_obj setVariable ["bind", _key];
			};

		};

	};

};