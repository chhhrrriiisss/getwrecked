//
//      Name: emergencyRepair
//      Desc: Instantly repairs the vehicle to 100% health
//      Return: None
//

private ["_vehicle", "_obj"];

_vehicle = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_obj = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _obj || isNull _vehicle) exitWith { false };

_status = _vehicle getVariable ["status", []];
_tyresRepaired = false;

// Repair tyres if they were caltropped
if ("tyresPopped" in _status) then {

	_tyresRepaired = true;

	[_vehicle, ['_tyresPopped']] call removeVehicleStatus;

	_vehicle sethit ["wheel_1_1_steering", 0];
	_vehicle sethit ["wheel_1_2_steering", 0];
	_vehicle sethit ["wheel_2_1_steering", 0];
	_vehicle sethit ["wheel_2_2_steering", 0];

};

_dmg = getDammage _vehicle;

if (_dmg <= 0) exitWith {		
	["ALREADY REPAIRED! ", 1, clearIcon, colorRed, "warning"] spawn createAlert;
	if (_tyresRepaired) then { true } else { false };
};

_vehicle setDammage 0;

[
	[
		_obj,
		0.5
	],
	"muzzleEffect"
] call BIS_fnc_MP;

["REPAIRED!", 1, emergencyRepairIcon, nil, "slideDown"] spawn createAlert;

true