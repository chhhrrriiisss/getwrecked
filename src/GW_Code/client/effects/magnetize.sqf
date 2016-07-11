//
//      Name: magnetizeEffect
//      Desc: Pulls vehicle towards a magnet
//      Return: None
//

_status = (_this select 0) getVariable ['status', []];
if ('magnetized' in _status) exitWith {};

[(_this select 0), ['magnetized'], 5] call addVehicleStatus;

_timeout = time + 5;

waitUntil {
	Sleep 0.5;
	_heading = [(ASLtoATL visiblePositionASL (_this select 0)),(ASLtoATL visiblePositionASL (_this select 1))] call BIS_fnc_vectorFromXToY;	
	_velocity = [_heading, 20] call BIS_fnc_vectorMultiply; 
	(_this select 0) setVelocity (_velocity vectorAdd (velocity (_this select 0)));
	(time > _timeout)
};