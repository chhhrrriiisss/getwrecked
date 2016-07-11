//
//      Name: playerSpawn
//      Desc: Handles texture, weapon assignments and death camera for a newly spawned player
//      Return: None
//

_unit = [_this,0, objNull, [objNull]] call filterParam;
if (isNull _unit) exitWith {};
if (!local _unit) exitWith {};

waitUntil { 
	Sleep 0.1; 
	(!isNil "serverSetupComplete" &&  { !isNull _unit } && { (alive _unit) }) 
}; 


45000 cutText ["", "BLACK IN", 1.5]; 

// if (GW_BOUNDARIES_ENABLED) then { 
// 	[] spawn { ["workshopZone"] call buildZoneBoundary;  };
// };

waitUntil {
	hasInterface
};

// Hide unwanted hud elements
showHUD [true,false,false,false,false,false,false,true,false];

removeAllActions _unit;
removeAllWeapons _unit;
removeVest _unit;
removeBackpack _unit;
removeGoggles _unit;
removeAllPrimaryWeaponItems _unit;
removeallassigneditems _unit;

_unit enableFatigue false;

_unit addItem "ItemMap";
_unit assignItem "ItemMap";

// Reset just in case
GW_POWERUP_ACTIVE = false;
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
GW_HUD_LOCK = false;
GW_HUD_ACTIVE = true;
GW_INVEHICLE = false;
GW_ISDRIVER = false;

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

	if (GW_DEV_BUILD) then { _tx = 'test'; };
	[[_unit,_tx],"setPlayerTexture",true,false] call bis_fnc_mp;
};

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

	_unit spawn {

		_p = getPos _this;
		_timeout = time + 5;
		waitUntil {
			_d = (getPos _this) distance _p;
			((time > _timeout) || (_d > 1))
		};

		// Set player to default respawn if all pads full or setPosEmpty fails to find a spot
		_fail = if ( (getpos _this) distance _p <= 3) then { true } else { false };
		if (_fail) then {
			player setPos (getMarkerPos "respawn_civilian");
		};

	};

	[
		["[spawnAreas,['Car', 'Man'], 8]",_unit],
		'setPosEmpty',
		false,
		false
	] call bis_fnc_mp;		

} else {	

	// Show the screen
	_unit setVariable ["firstSpawn", false];	
	titlecut["","BLACK IN",2];	

	// Make us face the closest vehicle terminal
	_closest = [vehicleTerminals, (ASLtoATL visiblePositionASL player)] call findClosest; 

	_dirTo = ([player, _closest] call dirTo);
	player setDir _dirTo;

	// Show welcome note
	['welcome'] spawn createHint;
	
};

// Wait for the death camera to be active before setting the current zone
_timeout = time + 3;
waitUntil { (time > _timeout) || GW_DEATH_CAMERA_ACTIVE };

// Set current zone
["workshopZone"] call setCurrentZone;


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

_unit setVariable ['name', name player, true];


// Trigger Lazy Update settings
// GW_minUpdateFrequency = 1.5;
// GW_maxUpdateFrequency = 1;
// GW_updateDistance = 1.5;
// GW_updateAimpoint = 0.1;
// GW_cooldown = false;
// GW_lastUpdate = time - GW_minUpdateFrequency;

// GW_lastPosition = [0,0,0];
// GW_lastAimpoint = [0,0,0];

// if (!isNil "GW_MM_EH") then { (findDisplay 46) displayRemoveEventHandler ["MouseMoving", GW_MM_EH]; };	
// GW_MM_EH = (findDisplay 46) displayAddEventHandler ["MouseMoving", "[_this, 'mouse'] call triggerLazyUpdate; false;"];

// // Looped items that only require a periodic, non consistent refresh
// [nil, 'manual'] call triggerLazyUpdate;

// inGameUISetEventHandler['PrevAction', '[_this, "scroll"] call triggerLazyUpdate; false'];
// inGameUISetEventHandler['NextAction', '[_this, "scroll"] call triggerLazyUpdate; false'];

inGameUISetEventHandler ["Action", "
	if (isNil '_this select 3') exitWith { false };
	if (_this select 3 == 'DisAssemble') then {
		true
	}
"];


// Destroy any existing player loops

if (!isNIl "GW_PLAYER_LOOP") then {
	terminate GW_PLAYER_LOOP;
	GW_PLAYER_LOOP = nil;
};

GW_PLAYER_LOOP = [] spawn {
	
	_refreshRate = 0.5;

	// Player loop
	for "_i" from 0 to 1 step 0 do {

		_startTime = time;
		[] call playerLoop;
		_endTime = format['%1', ([(time - _startTime), 2] call roundTo)];
		['Loop Update', _endTime] call logDebug;

		_startTime = time;
		_refreshRate call drawHud;
		_endTime = format['%1', ([(time - _startTime), 2] call roundTo)];
		['HUD Update', _endTime] call logDebug;

		// hint _endTime;

		if (!alive player) exitWith {};

		Sleep _refreshRate;
	};

};

if (true) exitWith {};

// Prevent weapon disassembly
// inGameUISetEventHandler ["Action", "
	
// 	if (isNil '_this') exitWith { false };	
// 	if ((_this select 3) in ['DisAssemble', 'Take', 'Put', 'Inventory', 'Get In Gunner']) then {
// 		true
// 	};
// "];
