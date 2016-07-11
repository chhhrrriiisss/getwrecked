/*

	Event Handler for hit Vehicle
*/

params ['_vehicle', '_projectile'];

// [_vehicle, _projectile] call sendVehicleHit;

if (!local _vehicle) exitWith {};

[_vehicle, ['noservice'], 10] call addVehicleStatus;
[_vehicle] spawn checkTyres; 

false
