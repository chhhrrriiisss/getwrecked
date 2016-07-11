//
//      Name: listFunctions
//      Desc: Various library management functions
//      Return: None
//

private['_action', '_target'];

_action = [_this,0, "", [""]] call filterParam;
_target = [_this,1, "", [""]] call filterParam;
_secondTarget = [_this,2, "", [""]] call filterParam;

if (_action == "") exitWith {};

// Clear the vehicle library
if (_action == 'clear') exitWith {

	_raw = profileNamespace getVariable [GW_LIBRARY_LOCATION, []];
	if (count _raw == 0) exitWith {};		

	{
		if (!(isNil "_x")) then {
			profileNameSpace setVariable[_x, nil]; 
		};

	} ForEach _raw;

	profileNameSpace setVariable[GW_LIBRARY_LOCATION, []]; 
	saveProfileNamespace;

	systemChat "List cleared.";

};

// Add the vehicle to the list
if (_action == 'add') exitWith {

	_arr = toArray(_target);

    for "_i" from 0 to 3 do {
	    _arr set [0, "x"];
	    _arr = _arr - ["x"];
	};

	_string = toString(_arr);

	_raw = GW_SHAREARRAY;

	_found = false;
	_data = [];	
	{
		if ( (_x select 0) == _string) exitWith {		
			_data = _x;	
			_found = true;
		};
	} ForEach _raw;

	if (!_found) exitWith { systemChat 'Couldnt find that vehicle.';  };	

	[(_data select 0), ((_data select 1) select 0)] spawn registerVehicle;

	systemChat format['Added to list: %1', _string];
	
	[] spawn listVehicles;
};

// Share vehicle with other players on the server
// if (_action == 'share') exitWith {

// 	_arr = toArray(_target);

//     for "_i" from 0 to 5 do {
// 	    _arr set [0, "x"];
// 	    _arr = _arr - ["x"];
// 	};

// 	_string = toString(_arr);

// 	_raw = profileNamespace getVariable [GW_LIBRARY_LOCATION, []];
// 	if (count _raw == 0) exitWith { systemChat 'List is empty.'; };

// 	_found = false;
	
// 	{
// 		if (_x == _string) exitWith {			
// 			_found = true;
// 		};
// 	} ForEach _raw;

// 	if (!_found) exitWith { systemChat 'Couldnt find in list.';  };	

// 	_data = profileNamespace getVariable [_string, nil];

// 	if (isNil "_data") exitWith {
// 		systemChat 'No data for that vehicle.';
// 	};

// 	[[name player, _string, _data], "shareVehicle", true, true] call bis_fnc_mp; 

// 	systemChat format['%1 was shared successfully.', _string];
// };

// Delete target vehicle
if (_action == 'delete') exitWith {

	_raw = [] call getVehicleLibrary;
	if (count _raw == 0) exitWith { systemChat 'List is empty.'; };

	_found = false;

	{
		if (toUpper _x == toUpper _target) exitWith {

			_found = true;
			_raw deleteAt _forEachIndex;

			[_target, nil] call setVehicleData;
			[format['GW_%1', _target], nil] call setVehicleData;

			//profileNameSpace setVariable[_target, nil]; 
			// profileNameSpace setVariable[format['GW_%1',_target], nil]; 
			profileNameSpace setVariable[GW_LIBRARY_LOCATION, _raw]; 
			saveProfileNamespace;	
			GW_LIBRARY = _raw;

		};

	} ForEach _raw;

	if (!_found) exitWith { systemChat 'Couldnt find in list.';  };	

	if (_found) then {		
		systemChat format['Deleted from list: %1', _target];
	};

};

// Rename target vehicle
if (_action == 'rename') exitWith {

	_raw = [] call getVehicleLibrary;
	if (count _raw == 0) exitWith { systemChat 'List is empty.'; };

	_found = false;

	{
		if (toUpper _x == toUpper _target) exitWith {

			_found = true;

			// Set library entry to new name
			_raw set [_forEachIndex, _secondTarget];

			// Retrieve target data and set to new target
			_curData = ([_target] call getVehicleData);
			(_curData select 0) set [1, _secondTarget];
			[_secondTarget, _curData] call setVehicleData;
			[_target, nil] call setVehicleData;

		};

	} ForEach _raw;

	if (!_found) exitWith { systemChat 'Couldnt find in list.';  };	

	if (_found) then {
		systemChat format['Renamed: %1 > %2', _target, _secondTarget];
	};

};





