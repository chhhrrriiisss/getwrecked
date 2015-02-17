//
//      Name: statusMonitor
//      Desc: Main loop for vehicle damage and status effects
//      Return: None
//

if (!isNil "GW_STATUS_MONITOR_EH") then {
	[GW_STATUS_MONITOR_EH, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
	GW_STATUS_MONITOR_EH = nil;
};

GW_STATUS_MONITOR_EH = ["GW_STATUS_MONITOR", "onEachFrame", {
	
	GW_CURRENTVEHICLE = (vehicle player);
	_vehicle = GW_CURRENTVEHICLE;
	_inVehicle = if (_vehicle != player) then { true } else { false };

	// Auto close inventories
	disableSerialization;
	_invOpen = findDisplay 602;
    if (!isNull _invOpen) then  { closeDialog 602;  };
    	
    // Force 3rd Person
    if (cameraOn == (vehicle player) && cameraView == "Internal") then {
    	(vehicle player) switchCamera "External";
    };

    if (isNil "GW_STATUS_MONITOR_LAST_UPDATE") then {
    	GW_STATUS_MONITOR_LAST_UPDATE = time;
    };

    GW_INVULNERABLE = false;
    if (GW_CURRENTZONE == "workshopZone" || (_inVehicle && GW_CURRENTZONE != "workshopZone")) then { GW_INVULNERABLE = true; };

	['Invulnerable', format['%1', GW_INVULNERABLE]] call logDebug;

	if (!_inVehicle || (time - GW_STATUS_MONITOR_LAST_UPDATE < 0.3)) exitWith {};

	if (!simulationEnabled _vehicle) then {
		_vehicle enableSimulation true;
	};
	
	// Apply vehicle damage to driver
    _vehDamage = getDammage _vehicle;
    _playerDamage = getDammage player;
    if (_playerDamage != _vehDamage) then {
    	player setDammage _vehDamage;
    };

    // Update vehicle damage
    _vehicle call updateVehicleDamage;

	GW_STATUS_MONITOR_LAST_UPDATE = time;

	['Status Update', format['%1', time]] call logDebug;

	_status = _vehicle getVariable ["status", []];
	_special = _vehicle getVariable ["special", []];

	// // Every 5 seconds, record position, ignoring while in parachute
	_remainder = round (time) % 5;
	_hasMoved = false;

	if (_remainder == 0 && (typeOf _vehicle != "Steerable_Parachute_F")) then {
		
		_prevPos = _vehicle getVariable ['prevPos', nil];
		_currentPos = ASLtoATL getPosASL _vehicle;

		// If there's position data stored and we're not at the workshop
		if (!isNil "_prevPos") then {

			['PrevPos', format['%1', _prevPos]] call logDebug;

			_distanceTravelled = _prevPos distance _currentPos;   
			if (_distanceTravelled > 3) then {       
			    ['mileage', _vehicle, _distanceTravelled] spawn logStat;  
			    _hasMoved = true; 
			};
		};
	
		// Log time alive
		if (isNil "GW_LASTPOSCHECK") then {        
			GW_LASTPOSCHECK = time;
		};   

		_timeAlive = (time - GW_LASTPOSCHECK);
		if (_timeAlive > 0) then {			
			['timeAlive', _vehicle, _timeAlive] spawn logStat;   
		};    

		GW_LASTPOSCHECK = time;   

		_vehicle setVariable ['prevPos', _currentPos];
		player setVariable ['prevPos', _currentPos];
		player setVariable ['prevVeh', _vehicle, true];

	};

	// Every 2 minutes, give sponsorship money, if we've moved
	if (isNil "GW_LASTPAYCHECK") then {  GW_LASTPAYCHECK = time; };
	if (time - GW_LASTPAYCHECK > 120 && _hasMoved) then {

		GW_LASTPAYCHECK = time;
		_wantedValue = _vehicle getVariable ["GW_WantedValue", 0]; 
		_totalValue = 100 + (_wantedValue);
		_totalValue call changeBalance;
		_totalValueString = [_totalValue] call numberToCurrency;
		systemchat format['You earned $%1. Next payment in two minutes.', _totalValueString];
		['moneyEarned', _vehicle, _totalValue] spawn logStat;   
		_wantedValue = _wantedValue + 50;
		_vehicle setVariable ["GW_WantedValue", _wantedValue];
		_vehicle say3D "money";
	};

	// If we're not disabled to any extent (or we've not been to a pad for 3 seconds)
	if ( !("emp" in _status) && !("disabled" in _status) && !("noservice" in _status) ) then {

		_nearbyService = _vehicle getVariable ["GW_NEARBY_SERVICE", nil];

		if (!isNil "_nearbyService") then {   
			[_vehicle, _nearbyService] call servicePoint;
		};

	};

	[_vehicle] spawn checkTyres;
	
	// Give a little bit of fuel if it looks like we're out
	if (fuel _vehicle < 0.01 && !("emp" in _status)) then {
		_vehicle setFuel 0.01;
	};

	// No status, reinflate tyres 
	if (count _status <= 0) exitWith {
		_vehicle sethit ["wheel_1_1_steering", 0];
		_vehicle sethit ["wheel_1_2_steering", 0];
		_vehicle sethit ["wheel_2_1_steering", 0];
		_vehicle sethit ["wheel_2_2_steering", 0];
	};	

	switch (true) do {     

		case ("disabled" in _status): {

			_vehicle sethit ["wheel_1_1_steering", 1];
			_vehicle sethit ["wheel_1_2_steering", 1];
			_vehicle sethit ["wheel_2_1_steering", 1];
			_vehicle sethit ["wheel_2_2_steering", 1];

			[_vehicle, 0] spawn slowDown;                 

		};

		case ("tyresPopped" in _status && !("invTyres" in _status) ): {

			_vehicle sethit ["wheel_1_1_steering", 1];
			_vehicle sethit ["wheel_1_2_steering", 1];
			_vehicle sethit ["wheel_2_1_steering", 1];
			_vehicle sethit ["wheel_2_2_steering", 1];

			[_vehicle, 0.97] spawn slowDown;                 

		};

		case ("invTyres" in _status): {

			_vehicle sethit ["wheel_1_1_steering", 0];
			_vehicle sethit ["wheel_1_2_steering", 0];
			_vehicle sethit ["wheel_2_1_steering", 0];
			_vehicle sethit ["wheel_2_2_steering", 0];        

		};

		case ("invulnerable" in _status): {

			// _invState = getDammage _vehicle;        
			// _vehicle setDammage _invState;
		};

		case ("inferno" in _status && !("nanoarmor" in _status)): {   

			// Put out fire if we drive in water
			if (surfaceIsWater (getPosASL _vehicle)) then {

				[_vehicle, ['fire', 'inferno']] call removeVehicleStatus;

			} else {                                         

			    _dmg = getDammage _vehicle;
			    _rnd = (random 7) + 14;
			    _rnd = (_rnd / 10000) * FIRE_DMG_SCALE;
			    _newDmg = _dmg + _rnd;
			    _vehicle setDammage _newDmg;
			};

			
		};

		case ("fire" in _status): {   

			// Put out fire if we drive in water
			if (surfaceIsWater (getPosASL _vehicle)) then {

				[_vehicle, ['fire', 'inferno']] call removeVehicleStatus;

			} else {                                         

			    _dmg = getDammage _vehicle;
			    _rnd = (random 5) + 10;
			    _rnd = (_rnd / 10000) * FIRE_DMG_SCALE;
			    _rnd = if ("nanoarmor" in _status) then { (_rnd * 0.1) } else { _rnd };
			    _newDmg = _dmg + _rnd;
			    _vehicle setDammage _newDmg;
			};

		};

		case ("emp" in _status): { 
			
			if ("nuke" in _status) then {} else {
				[_vehicle, 0.3] spawn slowDown;   
			};

		}; 

	};

}] call BIS_fnc_addStackedEventHandler;
