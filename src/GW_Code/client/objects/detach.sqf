//
//      Name: detachObj
//      Desc: Safely remove an item from a vehicle
//      Return: Bool (Success)
//

private ["_obj", "_unit","_id"];

_obj = [_this,0, objNull, [objNull]] call filterParam;
_unit = [_this,1, objNull, [objNull]] call filterParam;

if (isNull _obj || isNull _unit) exitWith { false };
if (!alive _obj) exitWith { deleteVehicle _obj;	false };

_veh = attachedTo _obj;
if (isNull _veh) exitWith { false };

// Check we actually own this
_isOwner = [_obj, _unit] call checkOwner;
if (!_isOwner) exitWith { false };

// Disable simulation on vehicle and object
[		
	[
		_obj,
		false
	],
	"setObjectSimulation",
	false,
	false 
] call bis_fnc_mp;

_timeout = time + 3;
waitUntil{
	Sleep 0.1;	
	( (time > _timeout) || !(simulationEnabled _obj) )
};

detach _obj;

[		
	[
		_obj,
		'hit1',
		60
	],
	"playSoundAll",
	true,
	false
] call bis_fnc_mp;

removeAllActions _obj;

//[localize "str_gw_object_detached", 1, successIcon, nil, "slideDown", ""] spawn createAlert;
[_obj, _unit] spawn moveObj;

// Re-compile vehicle information
[_veh] call compileAttached;

// Snap the vehicle back to the closest save point
[_veh] call snapToPad;

// Mark as unsaved
_veh setVariable ['isSaved', false];

true

