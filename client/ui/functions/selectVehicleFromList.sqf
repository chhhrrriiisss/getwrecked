//
//      Name: selectVehicleFromList
//      Desc: Attempt to purchase a locked vehicle from the new/create menu
//      Return: None
//

private ['_control', '_index', '_class', '_state', '_result'];
	
disableSerialization;
_control = (findDisplay 96000 displayCtrl 96001);
_index = lnbCurSelRow _control;
_class = _control lnbData [_index, 2];
_state = _control lnbData  [_index, 0];

_result = true;

if (_state == "locked") then {

	_cost = _class call getCost;
	_costString = [_cost] call numberToCurrency;
	_d = [_class, GW_VEHICLE_LIST] call getData;
	_name = if (isNil "_d") then { "" } else { (_d select 1) };

	// Spit out a dialog just to confirm
	_result = ['UNLOCK VEHICLE?', format[' $%1 [%2]', _costString, _name], 'CONFIRM'] call createMessage;

	if (_result) then {
		
		_success = -_cost call changeBalance;

		if (_success) then {
			// Yuus, new wheels!
			_class call unlockItem;
			[format['UNLOCKED %1!', toUpper(_name)], 2, successIcon, nil, "slideDown"] spawn createAlert; 
		} else {
			// Nope, not enough cash
			closeDialog 0;
			['INSUFFICIENT FUNDS!', 2, warningIcon, colorRed, "slideDown"] spawn createAlert; 
			_result = false;
		};
	};

};

if (!_result) exitWith {};

// Find the closest vehicle pad, and request the server spawn a fresh one
_closest = [saveAreas, (getPosATL player)] call findClosest; 
_array = [_class,'Untitled','', (getPosATL _closest), 0, []];
[_closest, _array] spawn requestVehicle;

closeDialog 0;