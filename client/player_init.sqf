/*

	Player Init

*/

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

GW_PLAYERNAME = (name player);

// Default Zone
['workshopZone'] call setCurrentZone;

_unit setVariable ["firstSpawn", true];

_unit addeventhandler ["respawn", {

	_this spawn playerRespawn;
	//_this execVM 'client\player_respawn.sqf';

}];  

_unit addeventhandler ["killed",{
	
	_this spawn playerKilled;
	//_this execVM 'client\player_killed.sqf';

}];

_unit addeventhandler ["handleDamage",{ 

	_damage = _this select 2;

	if (GW_INVULNERABLE || GW_CURRENTZONE == 'workshopZone') then {
		_damage = false;
	} else {
		_damage = _damage;
	};

	_damage

}];

[_unit] spawn playerSpawn;
//[_unit] execVM 'client\player_spawn.sqf';

[] call drawDisplay;

systemChat 'Player initialization complete.';

if (true) exitWith {};