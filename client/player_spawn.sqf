//
//      Name: playerSpawn
//      Desc: Handles texture, weapon assignments and death camera for a newly spawned player
//      Return: None
//

_unit = [_this,0, objNull, [objNull]] call BIS_fnc_param;
if (isNull _unit) exitWith {};
if (!local _unit) exitWith {};

waitUntil { !isNull _unit && (alive _unit) }; 

45000 cutText ["", "BLACK IN", 1.5]; 

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

// Force hud refresh
GW_HUD_ACTIVE = false;

_tx = _unit getVariable ["texture", ""];

if (_tx == "") then {
	_tx = "slytech";
};

switch (_tx) do {
	
	case "slytech": { _unit addheadgear "H_RacingHelmet_1_white_F"; };
	case "crisp": { _unit addheadgear "H_RacingHelmet_1_red_F"; };
	case "gastrol": { _unit addheadgear "H_RacingHelmet_1_black_F"; };
	case "haywire": { _unit addheadgear "H_RacingHelmet_1_black_F"; };
	case "cognition": { _unit addheadgear "H_RacingHelmet_1_white_F"; };
	case "terminal": { _unit addheadgear "H_RacingHelmet_1_red_F"; };
	case "tank": { _unit addheadgear "H_RacingHelmet_1_black_F"; };
	case "veneer": { _unit addheadgear "H_RacingHelmet_1_white_F"; };
	default { _unit addheadgear "H_RacingHelmet_1_black_F"; };
};
	
if(!isNil "_tx") then {
	_unit setVariable ["GW_Sponsor", _tx];
	[[_unit,_tx],"setPlayerTexture",true,false] call BIS_fnc_MP;
};

playerPos = (ASLtoATL getPosASL _unit);

// Reset pp
"dynamicBlur" ppEffectEnable false; 
"colorCorrections" ppEffectEnable false; 

_firstSpawn = _unit getVariable ["firstSpawn", false];

// Not our first time here, use the death camera to watch our last target for a bit
if (!_firstSpawn) then {

	_killedBy = profileNamespace getVariable ['killedBy', nil];

	if (!isNil "_killedBy") then {

		[       
            [],
            "logStatKill",
            _killedBy,
            false 
        ] call BIS_fnc_MP;

		// If killed by exists, trigger camera on killer		
		[_unit, _killedBy] spawn deathCamera;

	} else {
		// Not sure if killed by, trigger camera on default location		
		[_unit, _unit] spawn deathCamera;
	};

	_pos = [spawnAreas, ["Car", "Man"]] call findEmpty;
	_unit setPosATL (ASLtoATL getPosATL _pos);	
	_unit setDir (getDir _pos);

} else {
	// First spawn, just show us the workshop yo!
	_unit setVariable ["firstSpawn", false];
	titlecut["","BLACK IN",3];
};

// Wait for the death camera to be active before setting the current zone
_timeout = time + 3;
waitUntil { (time > _timeout) || GW_DEATH_CAMERA_ACTIVE };
['workshopZone'] call setCurrentZone;

// Reset killed by as we need to start fresh
profileNamespace setVariable ['killedBy', nil];
saveProfileNamespace;

while {alive player} do {

	_currentPos = (ASLtoATL (getPosASL player));
	_vehicle = (vehicle player);
	_inVehicle = !(player == _vehicle);
	_isDriver = (player == (driver _vehicle));

	// Restore the HUD if we're somewhere that needs it
	if (GW_DEATH_CAMERA_ACTIVE || GW_PREVIEW_CAM_ACTIVE || GW_TIMER_ACTIVE) then {} else {
		if (!GW_HUD_ACTIVE) then {	
			[] spawn drawHud;
		};
	};
	
	// Adds actions to nearby objects & vehicles
	if (!_inVehicle && !GW_EDITING) then {		
		[_currentPos] spawn checkNearbyActions;
	};
	
	// In Zone Check
	if (!isNil "GW_CURRENTZONE" && !(serverCommandAvailable "#kick")) then {

		_inZone = [_currentPos, GW_CURRENTZONE_DATA ] call checkInZone;


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

	// In vehicle status check
	if (_inVehicle && _isDriver && GW_CURRENTZONE != "workshopZone") then {
		[_vehicle] spawn statusMonitor;	
	};

	// Auto close inventories
	disableSerialization;
	_invOpen = findDisplay 602;
    if (!isNull _invOpen) then  { closeDialog 602;  };

    // Force 3rd Person
    if (cameraOn == (vehicle player) && cameraView == "Internal") then {
    	(vehicle player) switchCamera "External";
    };

	Sleep 0.5;

};

if (true) exitWith {};