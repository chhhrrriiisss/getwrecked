//
//      Name: renameVehicle
//      Desc: Rename dialog for changing a vehicle name
//      Return: None
//

private ['_cur', '_result'];

_cur = GW_SETTINGS_VEHICLE getVariable ["name", ''];
_result = ['RENAME VEHICLE', _cur, 'INPUT', [generateName, randomizeIcon]] call createMessage;

if (_result isEqualType "") then {
	if (count toArray _result > 0 && _result != _cur) then {

		// Set previous name data to 0 + deregister from library		
		['rename', _cur, _result] call listFunctions;

		GW_SETTINGS_VEHICLE setVariable ["name", _result, true];
		closeDialog 0;
		['VEHICLE RENAMED!', 2, successIcon, nil, "slideDown"] spawn createAlert; 
	};
};