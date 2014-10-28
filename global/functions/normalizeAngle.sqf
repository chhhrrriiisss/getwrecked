//
//      Name: normalizeAngle
//      Desc: Ensures specified number is within 360 degrees
//      Return: Number (Corrected)
//

private ['_a'];

_a = _this select 0;

if (_a > 360) then {_a = _a - 360; };
if (_a < 0) then { _a = 360 + _a; };
	
_a