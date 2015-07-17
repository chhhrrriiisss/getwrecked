//
//      Name: flattenAngle
//      Desc: Returns an angle between -180 and 180
//      Return: Number
//

params ['_angle'];

if (_angle < -180) then { _angle = _angle + 360; };
if (_angle > 180) then { _angle = _angle - 360; };

_angle