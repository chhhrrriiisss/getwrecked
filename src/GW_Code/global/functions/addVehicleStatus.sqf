//
//      Name: addVehicleStatus
//      Desc: Adds a status buff to the target vehicle for a duration, then removes it
//      Return: None
//

params ['_vehicle', '_status', '_duration'];

if (isNull _vehicle) exitWith {};
if (!alive _vehicle) exitWith {};

// If we're not dealing with the local vehicle, go find it
if (!local _vehicle) exitWith {
	[       
		_this,
		"addVehicleStatus",
		_vehicle,
		false 
	] call bis_fnc_mp; 
};

if (_status isEqualType "") then { _status = (call compile _status); };

[_vehicle, _status, _duration] spawn {
	
	private ['_v', '_sL', '_aS'];
	params ['_v'];
	
	_sL = _v getVariable ["status",[]];
	_aS = [];

	// Add the status, avoiding double-ups
	{
		if !(_x in _sL) then {	[_x, (_this select 2), _v] call triggerVehicleStatus;	};

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