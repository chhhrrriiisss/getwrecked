//
//      Name: flattenAngle
//      Desc: Returns an angle between -180 and 180
//      Return: Number
//

if ((_this select 0) < -180) exitWith { ((_this select 0) + 360) };
if ((_this select 0) > 180) exitWith { ((_this select 0) - 360) };

(_this select 0)