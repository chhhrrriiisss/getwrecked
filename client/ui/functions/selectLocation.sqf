//
//      Name: selectLocation
//      Desc: Choose the current location as the deploy location and go!
//      Return: None
//

if (!isNil "GW_SPAWN_LOCATION") then {

	closeDialog 0;
	GW_SPAWN_ACTIVE = false;

	// If we're not the driver then make it happen
	_driver = driver GW_SPAWN_VEHICLE;
	if (player != _driver) then {	
		player moveInDriver GW_SPAWN_VEHICLE;
	};

	// Create a countdown timer with an abort option
	_result = ['ABORT', 5, true] call createTimer;

	if (!_result) then {		

		_driver = driver GW_SPAWN_VEHICLE;
		if (player == _driver) then {	
			player action ["eject", GW_SPAWN_VEHICLE];
		};

		['ABORTED!', 2, warningIcon, colorRed, "warning"] spawn createAlert;   

	} else {
		
		// Send the package!
		[GW_SPAWN_VEHICLE, player, GW_SPAWN_LOCATION] call deployVehicle;		

	};
	
};