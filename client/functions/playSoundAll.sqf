//
//      Name: playSoundAll
//      Desc: Plays a sound defined in description.ext using say3D
//      Return: None
//

params ['_t', '_s', '_r'];

if (isNull _t || _s == "" || _r == 0) exitWith {};
if (!alive _t) exitWith {};
if (player distance _t > _r) exitWith {};

_t say3D _s;