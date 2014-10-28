//
//      Name: createTimeout
//      Desc: Prevents a tag being used by adding it to the waitlist
//      Return: Bool (Success)
//

private ["_type", "_reloadTime"];

_type = [_this,0, "", [""]] call BIS_fnc_param;
_reloadTime = [_this,1, 1, [0]] call BIS_fnc_param;

if (_reloadTime == 0) exitWith { false };

_expires = _currentTime + _reloadTime;
GW_WAITLIST pushback [_type, _expires];

true