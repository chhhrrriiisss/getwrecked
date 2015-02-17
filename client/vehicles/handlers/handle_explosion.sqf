/*

    Handler for Vehicle Explosion Damage

*/

private ["_veh"];

_veh = _this select 0;

[_veh] spawn checkTyres; 

_status = _veh getVariable ["status", []];

if ('cloak' in _status) then {

	[       
		[
			_veh,
			"['cloak']"
		],
		"removeVehicleStatus",
		_veh,
		false 
	] call BIS_fnc_MP;  

};	