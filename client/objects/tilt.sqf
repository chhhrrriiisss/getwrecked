/*

		Tilt object forward, backward or to the side

*/

private ["_obj", "_pitchAmount","_bankAmount", "_pitchBank", "_pitch", "_bank", "_newPitch", "_newBank"];

_obj = [_this,0, objNull, [objNull]] call filterParam;
_pitchAmount = [(_this select 1),0, 0, [0]] call filterParam;
_bankAmount = [(_this select 1),1, 0, [0]] call filterParam;

if (isNull _obj || (_pitchAmount == 0 && _bankAmount == 0)) exitWith {};

if ((typeOf _obj) in GW_TILT_EXCLUSIONS) exitWith {
	systemChat 'This object cant be tilted.';
};

_pitchBank = _obj call BIS_fnc_getPitchBank;

if ( ((_pitchBank select 0) >= 50) && (_pitchAmount > 0)) exitWith {};
if ( ((_pitchBank select 0) <= -50) && (_pitchAmount < 0)) exitWith {};

_newPitch = [(_pitchBank select 0) + _pitchAmount] call normalizeAngle;
_newBank = [(_pitchBank select 1) + _bankAmount] call normalizeAngle;

[_obj, [_newPitch,_newBank, (getDir _obj)]] call setPitchBankYaw;

true