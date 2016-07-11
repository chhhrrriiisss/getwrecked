//
//      Name: dirTo
//      Desc: Gets heading between object a > b
//      Return: Direction
//

private ['_p1', '_p2', '_dx', '_dy', '_h', '_o1', '_o2'];
params ['_o1', '_o2'];

_p1 = if (_o1 isEqualType objNull) then { (ASLtoATL getPosASL _o1) } else { _o1 };
_p2 =  if (_o2 isEqualType objNull) then { (ASLtoATL getPosASL _o2) } else { _o2 };

if ( !(_p1 isEqualType []) || !(_p2 isEqualType []) ) exitWith { 0 };

_dx = (_p2 select 0) - (_p1 select 0); 
_dy = (_p2 select 1) - (_p1 select 1);

_h = _dx atan2 _dy; 

if (_h < 0) exitWith { (_h + 360) }; 

_h