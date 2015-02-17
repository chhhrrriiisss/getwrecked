/*

	Event Handler for hit Vehicle
*/

private ["_veh"];

_vehicle = _this select 0; 
_projectile = _this select 1;

// [_vehicle, _projectile] call sendVehicleHit;

if (!local _vehicle) exitWith {};

[_vehicle, ['noservice'], 5] call addVehicleStatus;
[_vehicle] spawn checkTyres; 

false
