//
//      Name: smokeBomb
//      Desc: Creates a cloud of smoke that disrupts locking and puts out fires
//      Return: None
//

private ["_obj", "_oPos"];

_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _obj) exitWith { false };

_oPos = (ASLtoATL getPosASL _obj);
_veh = (vehicle player);

_status = _veh getVariable ["status",[]];
_statusList = [];

// Reset locked targets
GW_LOCKEDTARGETS = [];

// Gather what current debuff's we have
if ("locking" in _status) then { _statusList set [count _statusList, 'locking']; };
if ("locked" in _status) then { _statusList set [count _statusList, 'locked']; };
if ("fire" in _status) then { _statusList set [count _statusList, 'fire']; };

// Remove all those listed
if (count _statusList > 0) then {
	
	[       
		[
			_veh,
			str _statusList
		],
		"removeVehicleStatus",
		_veh,
		false 
	] call BIS_fnc_MP;   

} else {
	["SMOKE ACTIVATED!", 1, smokeIcon, nil, "default"] spawn createAlert;
};

playSound3D ["a3\sounds_f\sfx\explosion3.wss", _obj, false, _oPos, 2, 1, 100];

[
	[
		_obj,
		8
	],
	"smokeEffect"
] call BIS_fnc_MP;

Sleep 0.01;

[       
	[
		_veh,
		"['nolock', 'nofire']",
		7
	],
	"addVehicleStatus",
	_veh,
	false 
] call BIS_fnc_MP;  


true