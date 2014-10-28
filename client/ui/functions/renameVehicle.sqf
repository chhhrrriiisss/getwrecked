//
//      Name: renameVehicle
//      Desc: Rename dialog for changing a vehicle name
//      Return: None
//

private ['_cur', '_result'];

_cur = GW_SETTINGS_VEHICLE getVariable ["name", ''];
_result = ['RENAME VEHICLE', _cur, 'INPUT'] call createMessage;

if (typename _result == "STRING") then {
	if (count toArray _result > 0 && _result != _cur) then {
		GW_SETTINGS_VEHICLE setVariable ["name", _result, true];
		closeDialog 0;
		['VEHICLE RENAMED!', 2, successIcon, nil, "slideDown"] spawn createAlert; 
	};
};