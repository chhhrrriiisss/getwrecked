// Get all the conditions we need
GW_CURRENTVEHICLE = (vehicle player);		
GW_VEHICLE_STATUS = GW_CURRENTVEHICLE getVariable ["status", []];
GW_VEHICLE_SPECIAL = GW_CURRENTVEHICLE getVariable ["special", []];

GW_HASLOCKONS = GW_CURRENTVEHICLE getVariable ["lockOns", false];
GW_HASMELEE = GW_CURRENTVEHICLE call hasMelee;
GW_NEWSPAWN = GW_CURRENTVEHICLE getVariable ["newSpawn", false];

GW_CURRENTPOS = (ASLtoATL visiblePositionASL GW_CURRENTVEHICLE);
GW_CURRENTDIR = getDir GW_CURRENTVEHICLE;	
GW_CURRENTVEL = (velocity GW_CURRENTVEHICLE);

GW_CURRENTVEHICLE setVariable ['GW_prevPos', GW_CURRENTPOS];
player setVariable ['GW_prevPos', GW_CURRENTPOS];

// Update vehicle damage
GW_CURRENTVEHICLE call updateVehicleDamage;

// Toggle simulation back if we lose it for any reason
if (!simulationEnabled GW_CURRENTVEHICLE) then { GW_CURRENTVEHICLE enableSimulation true; };

// If we're using melee weapons, do a collision check
_meleeEnabled = GW_CURRENTVEHICLE getVariable ['GW_MELEE', false];
IF (_meleeEnabled) then {
	GW_CURRENTVEHICLE call collisionCheck;
};
['Melee enabled:', _meleeEnabled] call logDebug;

// Every 5 seconds, track mileage + alive state
_remainder = round (time) % 5;
if (_remainder == 0) then {
	
	// Log time alive
	if (alive GW_CURRENTVEHICLE) then {
		['timeAlive', GW_CURRENTVEHICLE, 5] call logStat;
	};
	
	// Track mileage
	_currentPos = GW_CURRENTPOS;
	_prevPos = GW_CURRENTVEHICLE getVariable ['GW_prevPos', _currentPos];	

	_distanceTravelled = _prevPos distance _currentPos;   
	if (_distanceTravelled > 3) then {       
	    ['mileage', GW_CURRENTVEHICLE, _distanceTravelled] call logStat;  
	};

};

if (!isNil "GW_CURRENTZONE") then {
   
    // Add actions to nearby objects
	if (GW_CURRENTZONE == "workshopZone" && !GW_INVEHICLE && !GW_EDITING) then {		
		[(ASLtoATL visiblePositionASL player)] spawn checkNearbyActions;
	};

	// Invulnerability toggle
	GW_INVULNERABLE = false;
	if (GW_CURRENTZONE == "workshopZone" || (GW_INVEHICLE && GW_CURRENTZONE != "workshopZone")) then { GW_INVULNERABLE = true; };

	// Set view distance depending on where we are
	if (GW_CURRENTZONE == "workshopZone" && (!GW_PREVIEW_CAM_ACTIVE && !GW_DEATH_CAMERA_ACTIVE)) then {
		if (viewDistance != GW_WORKSHOP_VISUAL_RANGE) then { setViewDistance GW_WORKSHOP_VISUAL_RANGE; };
	} else {
		if (viewDistance != GW_EFFECTS_RANGE) then { setViewDistance GW_EFFECTS_RANGE; };
	};

	// Ignore out of bounds checks for zoneImmune vehicles
	_zoneImmune = GW_CURRENTVEHICLE getVariable ['GW_ZoneImmune', false];
	if (count GW_CURRENTZONE_DATA > 0 && !_zoneImmune) then {

		_inZone = [GW_CURRENTPOS, GW_CURRENTZONE_DATA ] call checkInZone;

		if (_inZone) then {
			player setVariable ["outofbounds", false];	
		} else {
			_outOfBounds = player getVariable ["outofbounds", false];	
			if ( !_outOfBounds && !GW_DEATH_CAMERA_ACTIVE) then {
				// Activate the incentivizer
				[player] spawn returnToZone;
			};
		};

	} else {
		player setVariable ["outofbounds", false];	
	};	

	// If we're not disabled to any extent (or we've not been to a pad for 3 seconds)
	if ({ if (_x in GW_VEHICLE_STATUS) exitWith {1}; false } count ["emp", "disabled", "noservice"] isEqualTo 0) then { 

		_nearbyService = GW_CURRENTVEHICLE getVariable ["GW_NEARBY_SERVICE", nil];
		[GW_CURRENTVEHICLE] spawn checkTyres;

		if (!isNil "_nearbyService") then {   
			[GW_CURRENTVEHICLE, _nearbyService] call servicePoint;
		};
	};	

	// Give a little bit of fuel if it looks like we're out
	if (fuel GW_CURRENTVEHICLE < 0.01 && !("emp" in GW_VEHICLE_STATUS)) then {
		GW_CURRENTVEHICLE setFuel 0.01;
	};


};

// Debugging
if (!GW_DEBUG) exitWith {};
if (isNil "GW_DEBUG_ARRAY") then {	GW_DEBUG_ARRAY = []; };
if (GW_DEBUG_ARRAY isEqualTo []) exitWith {};

GW_DEBUG_MONITOR_LAST_UPDATE = time;
_totalString = format["[   DEBUG MODE   ] \n\n Time: %1\n Zone: %2\n Player: %3\n FPS: %4\n FPSMIN: %5\n", time, GW_CURRENTZONE, name player, [diag_fps, 0] call roundTo, [diag_fpsMIN, 0] call roundTo];
{	_totalString = format['%1 \n %2: %3', _totalString, (_x select 0), (_x select 1)];	false	} count GW_DEBUG_ARRAY > 0;

hintSilent _totalString;
