//
//      Name: createTimeout
//      Desc: Prevents a tag being used by adding it to the waitlist
//      Return: Bool (Success)
//

private ["_type", "_reloadTime"];

_type = _this select 0;
_reloadTime = _this select 1;

if (_reloadTime == 0) exitWith { false };

_expires = time + _reloadTime;
GW_WAITLIST pushback [_type, _expires];

true