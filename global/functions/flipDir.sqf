//
//      Name: flipDir
//      Desc: Flips an angle 180
//      Return: Number
//

private ["_d"];

_d = [_this,0, 0, [0]] call filterParam;
_d = if (_d < 180) then { _d + 180 } else { _d - 180 };
_d