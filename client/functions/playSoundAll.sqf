//
//      Name: playSoundAll
//      Desc: Plays a sound defined in description.ext using say3D
//      Return: None
//
	
_t = _this select 0;
_s = _this select 1;
_r = _this select 2;

if (isNull _t || _s == "" || _r == 0) exitWith {};
if (!alive _t) exitWith {};
if (player distance _t > _r) exitWith {};

_t say3D _s;