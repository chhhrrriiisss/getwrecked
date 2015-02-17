//
//      Name: normalizeAngle
//      Desc: Ensures specified number is within 360 degrees
//      Return: Number (Corrected)
//

private ['_a'];

_a = _this select 0;

if (_a > 360) exitWith { (_a - 360) };
if (_a < 0) exitWith { (360 + _a) };
	
_a