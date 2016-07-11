_name = [_this,0, "", [""]] call filterParam;
_target = [_this,1, [], ["", []]] call filterParam;

if (_name isEqualTo "") exitWith {};

_library = [] call getVehicleLibrary;
if (count _library == 0) exitWith {};

_ref = nil;
{
	if (_x in _library) exitWith { _ref = _x; }
} count [
	_name,
	toLower(_name),
	toUpper(_name)
];

if (isNil "_ref") exitWith {};

_raw = profileNameSpace getVariable [_ref, []];
if (count _raw == 0) exitWith {};

_targets = if !(typename _target isEqualTo "ARRAY") then { [_target] } else { _target };

{
	_u = [_x] call findUnit;

	[
		[_raw, name player],
		'copyVehicle',
		_u,
		false
	] call bis_fnc_mp;	

	false
} count _targets > 0;
