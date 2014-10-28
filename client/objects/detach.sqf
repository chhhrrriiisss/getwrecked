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

detach _obj;
Sleep 0.1;

removeAllActions _obj;
["OBJECT DETACHED!", 1, successIcon, nil, "slideDown"] spawn createAlert;
[_obj, _unit] spawn moveObj;

// Re-compile vehicle information
[_veh] call compileAttached;

true

