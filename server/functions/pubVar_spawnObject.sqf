//
//      Name: pubVar_fnc_spawnObject
//      Desc: Spawn an object at the desired location
//      Return: None
//

private["_type", "_pos"];

if (isNil { (_this select 0) } || isNil { (_this select 1) }) exitWith {};

_type = _this select 0;
_pos = _this select 1;
_exact = if (isNil { (_this select 2) }) then { false } else { (_this select 2) };

_frame = if (_exact) then { "CAN_COLLIDE" } else { "NONE" };

_newObj = [_pos, 0, _type, 0, "NONE", true] call createObject;

