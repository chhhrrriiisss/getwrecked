//
//      Name: removeVehicleStatus
//      Desc: Handles removal of the target status a vehicle
//      Return: None
//	

params ["_vehicle", "_status"];

if (isNull _vehicle) exitWith {};
if (!alive _vehicle) exitWith {};

// If we're not dealing with the local vehicle, go find it
if (!local _vehicle) exitWith {

	[       
		_this,
		"removeVehicleStatus",
		_vehicle,
		false 
	] call bis_fnc_mp; 
};

if (_status isEqualType "") then { _status = (call compile _status); };

[_vehicle, _status] spawn {	
	
	private ['_v', '_sL'];
	params ['_v'];
	
	_sL = _v getVariable ["status",[]];	
	if (count _sL == 0) exitWith {};
		
	{
		_sL = _sL - [_x];	
		false
	} count (_this select 1) > 0;

	_v setVariable ["status", _sL, true];	

};
