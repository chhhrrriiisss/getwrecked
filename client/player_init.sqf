//
//      Name: playerInit
//      Desc: Initializes player handlers, variables etc on first load
//      Return: None
//

waitUntil{!isNil { clientCompileComplete } };

_unit = _this select 0;
if (!local _unit) exitWith {};
if (!isNil { _unit getVariable 'localInit'} ) exitWith {};
_unit setVariable['localInit', true];

removeAllWeapons _unit;
removeVest _unit;
removeBackpack _unit;
removeGoggles _unit;

removeAllPrimaryWeaponItems _unit;
removeallassigneditems _unit;

_unit addItem "ItemMap";
_unit assignItem "ItemMap";

GW_WARNING_CHANNEL = radioChannelCreate [[1, 0, 0, 1], "Warning Chat", "Warning", [player]]; 
GW_SUCCESS_CHANNEL = radioChannelCreate [[0.99,0.85,0.23,1], "Success Chat", "Success", [player]]; 

// Default Zone
['workshopZone'] call setCurrentZone;

_unit setVariable ["firstSpawn", true];

_unit addeventhandler ["respawn", { _this spawn playerRespawn; }];  
_unit addeventhandler ["killed",{ _this spawn playerKilled;  }];
_unit addeventhandler ["handleDamage",{ 

	_damage = _this select 2;

	// Ignore damage in workshop
	if (GW_INVULNERABLE || GW_CURRENTZONE == 'workshopZone') then {	_damage = false; } else { _damage = _damage; };

	_damage

}];

if (!isNil "GW_DC_EH") then {
	removeMissionEventHandler ["HandleDisconnect",GW_DC_EH]; 
	GW_DC_EH = nil;
};

GW_DC_EH = addMissionEventHandler ["HandleDisconnect",{

	// Remove ownership from any vehicles in workshop
	_n = name (_this select 0);
	_o = nearestObjects [getmarkerpos "workshopZone_camera", [], 200];

	pubVar_logDiag = format['%1 disconnected.', _n];
	publicVariableServer "pubVar_logDiag";

	// Loop through and find vehicles that player used to own
	{

		_owner = _x getVariable ['GW_Owner', ''];	

		if (_owner == _n) then {

			_x setVariable ['GW_Owner', '', true];
			_isHidden = _x getVariable ['GW_HIDDEN', false];

			// Also un-hide those vehicles (if hidden)
			if (_isHidden) then {
				pubVar_setHidden = [_x, false];
  				publicVariable "pubVar_setHidden";	
			};


		};
		false
	} count _o > 0;

	// Remove old event handlers
	(_this select 0) removeEventHandler['killed', 0];
	(_this select 0) removeEventHandler['handleDamage', 0];
	(_this select 0) removeEventHandler['respawn', 0];

	// Kill the unit
	(_this select 0) setDammage 1;

}];

// Player set up
[_unit] spawn playerSpawn;

// Useful for detecting mouse presses
[] call mouseHandler;

// Used for detecting key presses
[] call initBinds;

// Map markers, boundaries
[] call drawMap;

// UI loop for hud icons
[] call drawDisplay;

systemChat 'Player initialization complete.';

pubVar_logDiag = format['Player %1 initialization complete.', name player];
publicVariableServer "pubVar_logDiag";

clientLoadComplete = true;

if (true) exitWith {};