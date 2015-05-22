//
//      Name: listFunctions
//      Desc: Various library management functions
//      Return: None
//

private['_action', '_target'];

_action = [_this,0, "", [""]] call filterParam;
_target = [_this,1, "", [""]] call filterParam;

if (_action == "") exitWith {};

// Clear the vehicle library
if (_action == 'clear') exitWith {

	_raw = profileNamespace getVariable ['GW_LIBRARY', []];
	if (count _raw == 0) exitWith {};		

	{
		if (!(isNil "_x")) then {
			profileNameSpace setVariable[_x, nil]; 
		};

	} ForEach _raw;

	profileNameSpace setVariable['GW_LIBRARY', []]; 
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

// 	_raw = profileNamespace getVariable ['GW_LIBRARY', []];
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

// 	[[name player, _string, _data], "shareVehicle", true, true] call gw_fnc_mp; 

// 	systemChat format['%1 was shared successfully.', _string];
// };

// Delete target vehicle
if (_action == 'delete') exitWith {

	_raw = profileNamespace getVariable ['GW_LIBRARY', []];
	if (count _raw == 0) exitWith { systemChat 'List is empty.'; };

	_found = false;

	{
		if (_x == _target) exitWith {
			_found = true;
		};
	} ForEach _raw;

	if (!_found) exitWith { systemChat 'Couldnt find in list.';  };	

	if (_found) then {

		_newData = _raw - [_target];

		profileNameSpace setVariable[_target, nil]; 
		profileNameSpace setVariable['GW_LIBRARY', _newData]; 
		saveProfileNamespace;	

		systemChat format['Deleted from list: %1', _target];

	};

};




