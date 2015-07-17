//
//      Name: playerSpawn
//      Desc: Handles texture, weapon assignments and death camera for a newly spawned player
//      Return: None
//

_unit = [_this,0, objNull, [objNull]] call filterParam;
if (isNull _unit) exitWith {};
if (!local _unit) exitWith {};

waitUntil { !isNull _unit && (alive _unit) }; 

45000 cutText ["", "BLACK IN", 1.5]; 

removeAllActions _unit;
removeAllWeapons _unit;
removeVest _unit;
removeBackpack _unit;
removeGoggles _unit;
removeAllPrimaryWeaponItems _unit;
removeallassigneditems _unit;

_unit addItem "ItemMap";
_unit assignItem "ItemMap";

// Reset just in case
GW_WAITFIRE = false;
GW_WAITUSE = false;
GW_WAITLIST = [];
GW_WAITEDIT = false;   
GW_WAITALERT = false;
GW_WAITSAVE = false;
GW_WAITLOAD = false;
GW_WAITCOMPILE = false;
GW_EDITING = false;
GW_LIFT_ACTIVE = false;
GW_SPAWN_ACTIVE = false;
GW_DIALOG_ACTIVE = false;

// Get rid of previous locked targets 
GW_LOCKED_TARGETS = [];

// Force hud refresh
GW_HUD_ACTIVE = false;

_tx = _unit getVariable ["texture", ""];

if (_tx == "") then {
	_tx = "tyraid";
};

// Auto remove racing helmets for people without the DLC
_hasDLC = if ( (288520 in (getDLCs 1)) || (304400 in (getDLCs 1)) ) then { true } else { false };

// For people with the dlc, add helmets
if (_hasDLC) then {

	switch (_tx) do {
		
		case "tyraid": { _unit addheadgear "H_RacingHelmet_1_white_F"; };
		case "crisp": { _unit addheadgear "H_RacingHelmet_1_red_F"; };
		case "gastrol": { _unit addheadgear "H_RacingHelmet_1_black_F"; };
		case "haywire": { _unit addheadgear "H_RacingHelmet_1_black_F"; };
		case "cognition": { _unit addheadgear "H_RacingHelmet_1_white_F"; };
		case "terminal": { _unit addheadgear "H_RacingHelmet_1_red_F"; };
		case "tank": { _unit addheadgear "H_RacingHelmet_1_black_F"; };
		case "veneer": { _unit addheadgear "H_RacingHelmet_1_white_F"; };
		default { _unit addheadgear "H_RacingHelmet_1_black_F"; };
	};

} else {
	_unit addHeadgear "H_PilotHelmetHeli_B";
};
	
if(!isNil "_tx") then {
	_unit setVariable ["GW_Sponsor", _tx];
	[[_unit,_tx],"setPlayerTexture",true,false] call bis_fnc_mp;
};

playerPos = (ASLtoATL visiblePositionASL _unit);

// Reset pp
"dynamicBlur" ppEffectEnable false; 
"colorCorrections" ppEffectEnable false; 

_firstSpawn = _unit getVariable ["firstSpawn", false];

// Not our first time here, use the death camera to watch our last target for a bit
if (!_firstSpawn) then {

	_killedByNuke = profileNamespace getVariable ['killedByNuke', []];
	_killedByNuke = if (count _killedByNuke > 0) then { true } else { false };
	_killedBy = profileNamespace getVariable ['killedBy', nil];
	_defaultTarget = getMarkerPos format['%1_%2', GW_CURRENTZONE, 'camera'];
	_prevPos = _unit getVariable ['GW_prevPos', [0,0,0]];
	_prevPos = if (_prevPos distance [0,0,0] > 1) then { _prevPos } else { _defaultTarget };
	_prevPos = [(_prevPos select 0), (_prevPos select 1), ([(_prevPos select 2), 0, 100] call limitToRange) ];

	// Killed by something - lets create a camera on them
	if (!isNil "_killedBy" && !_killedByNuke) then {

		_killer = [_killedBy select 0, true] call findUnit;
		_killersVehicle = vehicle _killer;

		// Killer was someone not in a vehicle? Eh?
		if (_killer == _killersVehicle) exitWith {
			[_defaultTarget, "default"] spawn deathCamera;
		};

		// If it was a suicide, or the killers vehicle is also dead, use prevPos
		if ((_killer == _unit) || (!alive _killersVehicle)) exitWith {
			[_prevPos, "overview"] spawn deathCamera;
		};

		// Killer vehicle is alive and ticking
		[_killersVehicle, "focus"] spawn deathCamera;

	} else {

		if (_killedByNuke) exitWith {
			[(profileNamespace getVariable ['killedByNuke', _defaultTarget]), "nukefocus"] spawn deathCamera;
		};
		
		// Use last location, or currentZone_camera
		[_prevPos, "overview"] spawn deathCamera;

	};

	profileNamespace setVariable ['killedBy', nil];
	_unit setVariable ["killedBy", nil];
	_unit setVariable ["GW_prevPos", nil];

	_failSpawn = false;
	_location = [spawnAreas, ["Car", "Man"]] call findEmpty;

	// If we've failed to find an empty one, just use the first in the list
	_pos = if (typename _location == "ARRAY") then { _failSpawn = true; (ASLtoATL getPosASL (spawnAreas select 0)) } else { _unit setDir (getDir _location); (ASLtoATL getPosASL _location) };
	_unit setPosATL _pos;	
	

	if (!isNil "GW_LASTLOAD" && !_failSpawn) then {
		_closest = [saveAreas, _pos] call findClosest; 
		[(ASLtoATL getPosASL _closest), GW_LASTLOAD] spawn requestVehicle;
	};

} else {	

	// Show the screen
	_unit setVariable ["firstSpawn", false];	
	titlecut["","BLACK IN",2];	
	
};

// Wait for the death camera to be active before setting the current zone
_timeout = time + 3;
waitUntil { (time > _timeout) || GW_DEATH_CAMERA_ACTIVE };
['workshopZone'] call setCurrentZone;

// Clear/Unsimulate unnecessary items near workshop
{
	_i = _x getVariable ['GW_IGNORE_SIM', false];
	if ( (isPlayer _x || _x isKindOf "car") && !_i) then { _x enableSimulation true; } else { _x enableSimulation false; };
	false
} count (nearestObjects [ (getMarkerPos "workshopZone_camera"), [], 200]) > 0;


// Reset killed by as we need to start fresh
profileNamespace setVariable ['killedBy', nil];

// Force save the profileNameSpace
['', '', '', true] call logStat;

waitUntil {Sleep 0.1; !isNil "serverSetupComplete"};

_unit spawn setPlayerActions;

_unit setVariable ['name player', name player, true];

waitUntil {
	
	_currentPos = (ASLtoATL visiblePositionASL player);
	_vehicle = (vehicle player);
	_inVehicle = !(player == _vehicle);
	_isDriver = (player == (driver _vehicle));

	if (visibleMap) then {
		GW_HUD_ACTIVE = false;
	};

	// Restore the HUD if we're somewhere that needs it
	if (GW_DEATH_CAMERA_ACTIVE || GW_PREVIEW_CAM_ACTIVE || GW_TIMER_ACTIVE || GW_GUIDED_ACTIVE || GW_SETTINGS_ACTIVE || GW_LOADING_ACTIVE || visibleMap) then {} else {
		if (!GW_HUD_ACTIVE) then {	
			[] spawn drawHud;
		};
	};
	
	// Adds actions to nearby objects & vehicles
	if (!isNil "GW_CURRENTZONE") then {

		if (GW_CURRENTZONE == "workshopZone" && !_inVehicle && !GW_EDITING) then {		
			[_currentPos] spawn checkNearbyActions;
		};

		// Set view distance depending on where we are
		if (GW_CURRENTZONE == "workshopZone" && (!GW_PREVIEW_CAM_ACTIVE && !GW_DEATH_CAMERA_ACTIVE)) then {
			if (viewDistance != 400) then { setViewDistance 400; };
		} else {
			if (viewDistance != GW_EFFECTS_RANGE) then { setViewDistance GW_EFFECTS_RANGE; };
		};

		if ( count GW_CURRENTZONE_DATA > 0) then {

			_inZone = [_currentPos, GW_CURRENTZONE_DATA ] call checkInZone;

			if (_inZone) then {
				_unit setVariable ["outofbounds", false];	
			} else {
				_outOfBounds = _unit getVariable ["outofbounds", false];	
				if ( !_outOfBounds && !GW_DEATH_CAMERA_ACTIVE) then {
					// Activate the incentivizer
					[_unit] spawn returnToZone;
				};
			};

		} else {
			_unit setVariable ["outofbounds", false];	
		};	

	};

	Sleep 0.5;

	(!alive _unit)

};

if (true) exitWith {};