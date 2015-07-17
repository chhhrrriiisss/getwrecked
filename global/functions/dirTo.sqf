//
//      Name: dirTo
//      Desc: Gets heading between object a > b
//      Return: Direction
//

private ['_p1', '_p2', '_dx', '_dy', '_h', '_o1', '_o2'];
params ['_o1', '_o2'];

_p1 = if (typename _o1 == "OBJECT") then { (ASLtoATL getPosASL _o1); } else { _o1 };
_p2 =  if (typename _o2 == "OBJECT") then { (ASLtoATL getPosASL _o2); } else { _o2 };

if (typename _p1 != "ARRAY" || typename _p2 != "ARRAY") exitWith { 0 };

_dx = (_p2 select 0) - (_p1 select 0); 
_dy = (_p2 select 1) - (_p1 select 1);

_h = _dx atan2 _dy; 
if (_h < 0) then {_h = _h + 360}; 

_h