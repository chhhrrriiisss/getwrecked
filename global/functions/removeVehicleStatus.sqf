//
//      Name: removeVehicleStatus
//      Desc: Handles removal of the target status a vehicle
//      Return: None
//	

private["_vehicle", "_status"];
 
_vehicle = [_this,0, objNull, [objNull]] call BIS_fnc_param;	
_status = [_this,1, [], [[]]] call BIS_fnc_param;	

if (isNull _vehicle || count _status == 0) exitWith {};
if (!alive _vehicle || !local _vehicle) exitWith {};

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
