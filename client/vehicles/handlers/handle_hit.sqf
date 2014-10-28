/*

	Event Handler for hit Vehicle
*/

private ["_veh"];

_veh = _this select 0; 
_causedBy = _this select 1;

if (!local _veh) exitWith {};

_dmg = _this select 2;

[_veh] spawn checkTyres; 
[_veh, player] call checkEject;

_status = _veh getVariable ["status",[]];

if ("invulnerable" in _status) then {

    _veh setDammage 0;
};  

