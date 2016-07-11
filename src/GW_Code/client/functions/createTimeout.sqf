//
//      Name: createTimeout
//      Desc: Prevents a tag being used by adding it to the waitlist
//      Return: Bool (Success)
//

params ["_type", "_reloadTime"];

if (_reloadTime == 0) exitWith { false };

_expires = time + _reloadTime;
GW_WAITLIST pushback [_type, _expires];

true