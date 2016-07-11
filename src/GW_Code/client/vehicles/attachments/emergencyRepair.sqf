//
//      Name: emergencyRepair
//      Desc: Instantly repairs the vehicle to 100% health
//      Return: None
//

private ["_vehicle", "_obj"];

_obj = [_this,0, objNull, [objNull]] call filterParam;
_vehicle = [_this,1, objNull, [objNull]] call filterParam;

if (isNull _obj || isNull _vehicle) exitWith { false };

_status = _vehicle getVariable ["status", []];
_tyresRepaired = false;

// Repair tyres if they were caltropped
if ("tyresPopped" in _status) then {

	_tyresRepaired = true;

	[_vehicle, ['tyresPopped']] call removeVehicleStatus;
	[_vehicle, ['invTyres'], 5] call addVehicleStatus;
	
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

_newDamage = [(getDammage _vehicle) - 0.5, 0, 1] call limitToRange;
_vehicle setDammage _newDamage;

[
	[
		_obj,
		0.5
	],
	"muzzleEffect"
] call bis_fnc_mp;

["REPAIRED!", 1, emergencyRepairIcon, nil, "slideDown"] spawn createAlert;

_cV = velocity _vehicle;
_cV set [2, (_cV select 2) + 4];
_vehicle setVelocity _cV;


true