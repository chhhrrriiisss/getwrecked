//
//      Name: playerInit
//      Desc: Initializes player handlers, variables etc on first load
//      Return: None
//

waitUntil{!isNil { clientCompileComplete } };
params ['_unit'];

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

// Default Zone
["workshopZone"] call setCurrentZone;

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
	_p = (_this select 0);
	_n = name _p;
	_o = nearestObjects [getmarkerpos "workshopZone_camera", [], 200];	

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
	{ _p removeAllEventHandlers _x;	} foreach ['killed', 'handleDamage', 'respawn'];

	// Delete all placed deployables
	{ deleteVehicle _x; } foreach GW_DEPLOYLIST;

	// Tell the server to delete us from the manifest
	["remove"] call setCurrentZone;

	// Remove us from any active races
	if (!isNil "GW_CURRENTRACE") then {	
		if (isNil "GW_CURRENTRACE_VEHICLE") exitWith {};
		[
			[GW_CURRENTRACE, GW_CURRENTRACE_VEHICLE],
			'removeFromRace',
			false,
			false
		] call bis_fnc_mp;	
		GW_CURRENTRACE = nil;
		GW_CURRENTRACE_VEHICLE = nil;
	};

	pubVar_logDiag = format['%1 disconnected.', _n];
	publicVariableServer "pubVar_logDiag";

}];

// Cache boundary information
// [] call cacheZoneBoundary;

// Player set up
[_unit] spawn playerSpawn;

// Used for detecting key presses
[] spawn initBinds;

// Map markers, boundaries
[] call drawMap;

// UI loop for hud icons
[] call drawDisplay;

systemChat 'Player initialization complete.';

pubVar_logDiag = format['Player %1 initialization complete.', name player];
publicVariableServer "pubVar_logDiag";

clientLoadComplete = true;

if (true) exitWith {};