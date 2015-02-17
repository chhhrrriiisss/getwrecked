//
//      Name: detachObj
//      Desc: Safely remove an item from a vehicle
//      Return: Bool (Success)
//

private ["_obj", "_unit","_id"];

_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_unit = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _obj || isNull _unit) exitWith { false };
if (!alive _obj) exitWith { deleteVehicle _obj;	false };

_veh = attachedTo _obj;
if (isNull _veh) exitWith { false };

// Check we actually own this
_isOwner = [_obj, _unit] call checkOwner;
if (!_isOwner) exitWith { false };

_wasSimulated = (simulationEnabled _veh);

// Disable simulation on vehicle and object
[		
	[
		[_obj, _veh],
		false
	],
	"setObjectSimulation",
	false,
	false 
] call BIS_fnc_MP;

_timeout = time + 3;
waitUntil{
	Sleep 0.1;	
	( (time > _timeout) || !(simulationEnabled _veh) )
};

detach _obj;

if (_wasSimulated) then {

	// Re enable simulation on vehicle
	[		
		[
			_veh,
			true
		],
		"setObjectSimulation",
		false,
		false 
	] call BIS_fnc_MP;
};

removeAllActions _obj;

["OBJECT DETACHED!", 1, successIcon, nil, "slideDown"] spawn createAlert;
[_obj, _unit] spawn moveObj;

// Re-compile vehicle information
[_veh] call compileAttached;


true

