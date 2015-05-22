//
//      Name: statusMonitor
//      Desc: Main loop for vehicle damage and status effects
//      Return: None
//

if (isNil "GW_STATUS_MONITOR_LAST_UPDATE") then { GW_STATUS_MONITOR_LAST_UPDATE = time; };

// Invulnerability toggle
GW_INVULNERABLE = false;
if (GW_CURRENTZONE == "workshopZone" || (GW_INVEHICLE && GW_CURRENTZONE != "workshopZone")) then { GW_INVULNERABLE = true; };
if (!GW_INVEHICLE || (time - GW_STATUS_MONITOR_LAST_UPDATE < 0.3)) exitWith {};
GW_STATUS_MONITOR_LAST_UPDATE = time;

// Toggle simulation back if we lose it for any reason
if (!simulationEnabled GW_CURRENTVEHICLE) then { GW_CURRENTVEHICLE enableSimulation true; };

// Apply vehicle damage to driver
_vehDamage = getDammage GW_CURRENTVEHICLE;
if ((GetDammage player) != (_vehDamage)) then { player setDammage _vehDamage; };

// Update vehicle damage
GW_CURRENTVEHICLE call updateVehicleDamage;

// // Every 5 seconds, record position, ignoring while in parachute
_remainder = round (time) % 5;
_hasMoved = false;

if (_remainder == 0 && (typeOf GW_CURRENTVEHICLE != "Steerable_Parachute_F")) then {
	
	_prevPos = GW_CURRENTVEHICLE getVariable ['GW_prevPos', nil];
	_currentPos = ASLtoATL getPosASL GW_CURRENTVEHICLE;

	// If there's position data stored and we're not at the workshop
	if (!isNil "_prevPos") then {

		_distanceTravelled = _prevPos distance _currentPos;   
		if (_distanceTravelled > 3) then {       
		    ['mileage', GW_CURRENTVEHICLE, _distanceTravelled] call logStat;  
		    _hasMoved = true; 
		};
	};

	// Log time alive
	if (isNil "GW_LASTPOSCHECK") then { GW_LASTPOSCHECK = time;	};  
	_timeAlive = (time - GW_LASTPOSCHECK);
	if (_timeAlive > 0) then {	['timeAlive', GW_CURRENTVEHICLE, _timeAlive] call logStat;  };
	GW_LASTPOSCHECK = time;   

	GW_CURRENTVEHICLE setVariable ['GW_prevPos', _currentPos];
	player setVariable ['GW_prevPos', _currentPos];

};

// Every 2 minutes, give sponsorship money, if we've moved
if (isNil "GW_LASTPAYCHECK") then {  GW_LASTPAYCHECK = time; };
if (time - GW_LASTPAYCHECK > 120 && _hasMoved) then {

	GW_LASTPAYCHECK = time;
	_wantedValue = GW_CURRENTVEHICLE getVariable ["GW_WantedValue", 0]; 
	_totalValue = GW_IN_ZONE_VALUE + (_wantedValue);
	_totalValue call changeBalance;
	_totalValueString = [_totalValue] call numberToCurrency;
	systemchat format['You earned $%1. Next payment in two minutes.', _totalValueString];
	['moneyEarned', GW_CURRENTVEHICLE, _totalValue] call logStat;   
	_wantedValue = _wantedValue + 50;
	GW_CURRENTVEHICLE setVariable ["GW_WantedValue", _wantedValue];
	GW_CURRENTVEHICLE say3D "money";
};

// If we're not disabled to any extent (or we've not been to a pad for 3 seconds)
if ({ if (_x in GW_VEHICLE_STATUS) exitWith {1}; false } count ["emp", "disabled", "noservice"] isEqualTo 0) then { 

	_nearbyService = GW_CURRENTVEHICLE getVariable ["GW_NEARBY_SERVICE", nil];
	[GW_CURRENTVEHICLE] spawn checkTyres;

	if (!isNil "_nearbyService") then {   
		[GW_CURRENTVEHICLE, _nearbyService] call servicePoint;
	};
};	

[GW_CURRENTVEHICLE] spawn checkTyres;

// Give a little bit of fuel if it looks like we're out
if (fuel GW_CURRENTVEHICLE < 0.01 && !("emp" in GW_VEHICLE_STATUS)) then {
	GW_CURRENTVEHICLE setFuel 0.01;
};

// No status, reinflate tyres 
if (count GW_VEHICLE_STATUS <= 0) exitWith {
	GW_CURRENTVEHICLE sethit ["wheel_1_1_steering", 0];
	GW_CURRENTVEHICLE sethit ["wheel_1_2_steering", 0];
	GW_CURRENTVEHICLE sethit ["wheel_2_1_steering", 0];
	GW_CURRENTVEHICLE sethit ["wheel_2_2_steering", 0];
};	
