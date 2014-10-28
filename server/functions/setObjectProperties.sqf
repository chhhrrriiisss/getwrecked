_o = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _o) exitWith {};
if (!alive _o) exitWith {};

[_o] spawn setObjectData;
[_o] spawn setObjectHandlers;