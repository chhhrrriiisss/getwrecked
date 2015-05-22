//
//      Name: removeVehicleStatus
//      Desc: Handles removal of the target status a vehicle
//      Return: None
//	

private["_vehicle", "_status"];
 
_vehicle = _this select 0;
_status = _this select 1;

if (isNull _vehicle) exitWith {};
if (!alive _vehicle) exitWith {};

// If we're not dealing with the local vehicle, go find it
if (!local _vehicle) exitWith {

	[       
		_this,
		"removeVehicleStatus",
		_vehicle,
		false 
	] call gw_fnc_mp; 
};

if (typename _status == "STRING") then { _status = (call compile _status); };

[_vehicle, _status] spawn {	
	
	private ['_v', '_sL'];
	
	_v = _this select 0;
	_sL = _v getVariable ["status",[]];	
	if (count _sL == 0) exitWith {};
		
	{
		_sL = _sL - [_x];	
		false
	} count (_this select 1) > 0;

	_v setVariable ["status", _sL, true];	

};
