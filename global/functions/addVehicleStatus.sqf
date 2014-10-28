//
//      Name: addVehicleStatus
//      Desc: Adds a status buff to the target vehicle for a duration, then removes it
//      Return: None
//

private["_vehicle", "_status", "_duration"]; 

_vehicle = [_this,0, objNull, [objNull]] call BIS_fnc_param;	
_status = [_this,1, [], [[]]] call BIS_fnc_param;	
_duration = [_this,2, 0, [0]] call BIS_fnc_param;	

if (isNull _vehicle || count _status == 0) exitWith {};
if (!alive _vehicle || !local _vehicle) exitWith {};

[_vehicle, _status, _duration] spawn {
	
	private ['_v', '_sL', '_aS'];

	_v = (_this select 0);
	_sL = _v getVariable ["status",[]];
	_aS = [];

	// Add the status, avoiding double-ups
	{
		_sL = (_sL - [_x]) + [_x];
		_aS = (_aS - [_x]) + [_x];
		false
	} count (_this select 1) > 0;

	_v setVariable ["status", _sL, true];

	// Some states last indefinitely (cloaking for example)
	if ((_this select 2) >= 9999) exitWith {};
	Sleep (_this select 2);
	
	// If the status still exists remove it
	_sL = _v getVariable ["status", []];
	if (count _sL == 0) exitWith {};
	_sL = _sL - _aS;
	_v setVariable ["status",_sL, true];

};