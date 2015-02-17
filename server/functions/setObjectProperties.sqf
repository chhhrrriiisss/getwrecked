//
//      Name: setObjectProperties
//      Desc: Set handlers and object variables for items
//      Return: None
//

_o = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _o) exitWith {};
if (!alive _o) exitWith {};

[_o] spawn setObjectData;
