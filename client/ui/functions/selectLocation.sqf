//
//      Name: selectLocation
//      Desc: Choose the current location as the deploy location and go!
//      Return: None
//

if (!isNil "GW_SPAWN_LOCATION") then {

	closeDialog 0;
	GW_SPAWN_ACTIVE = false;

	// If we're not the driver then make it happen
	GW_SPAWN_VEHICLE lockDriver false;
	_driver = driver GW_SPAWN_VEHICLE;
	if (player != _driver) then {	
		player moveInDriver GW_SPAWN_VEHICLE;
	};

	// Create a countdown timer with an abort option
	_result = ['ABORT', 5, true] call createTimer;
	_success = false;

	if (_result) then {	
		// Send the package!
		_success = [GW_SPAWN_VEHICLE, player, GW_SPAWN_LOCATION] call deployVehicle;	
	} else {
		_success = false;
	};

	if (!_success) exitWith {

		_driver = driver GW_SPAWN_VEHICLE;
		if (player == _driver) then {	
			player action ["eject", GW_SPAWN_VEHICLE];
		};

		player spawn {
			_timeout = time + 3;
			waitUntil {
				Sleep 0.25;
				((_this == (vehicle _this)) || (time > _timeout))
			};

			_objs = lineIntersectsWith [ATLtoASL (_this modelToWorldVisual [0,0,1.6]), ATLtoASL (_this modelToWorldVisual [0,5,1.6]), _this, objNull];
			if (count _objs == 0) exitWith {};
			_this setPos (_this modelToWorldVisual [0,5,0]);
		};

		['ABORTED!', 2, warningIcon, colorRed, "warning"] spawn createAlert;   
		GW_SPAWN_VEHICLE lockDriver true;
		GW_SPAWN_VEHICLE setVariable ['GW_Owner', (name player), true];

	};

	if (_success) then {

		{
			_x enableSimulation true;
			false
		} count ([GW_CURRENTZONE] call findAllInZone) > 0;

		// Make sure we record a successful deploy
		['deploy', GW_SPAWN_VEHICLE, 1] call logStat; 
	};	
	
};