//
//      Name: playSoundAll
//      Desc: Plays a sound defined in description.ext using say3D
//      Return: None
//

_t = [_this,0, ObjNull, [ObjNull]] call BIS_fnc_param;
_s = [_this,1, "", [""]] call BIS_fnc_param;
_r = [_this,2, 0, [0]] call BIS_fnc_param;

if (isNull _t || _s == "" || _r == 0) exitWith {};
if (!alive _t) exitWith {};
if (player distance _t > _r) exitWith {};

_t say3D _s;