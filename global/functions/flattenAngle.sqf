//
//      Name: flattenAngle
//      Desc: Returns an angle between -180 and 180
//      Return: Number
//

private ['_angle'];

_angle = [_this,0, 0, [0]] call BIS_fnc_param;

if (_angle < -180) then { _angle = _angle + 360; };
if (_angle > 180) then { _angle = _angle - 360; };

_angle