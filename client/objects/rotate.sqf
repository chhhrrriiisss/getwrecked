//
//      Name: rotateObj
//      Desc: Rotates an object by the specified amount (yaw)
//      Return: None
//

private ["_obj", "_rotateAmount","_targetDirection"];

_obj = _this select 0;
_rotateAmount = _this select 1;
_toggle = _this select 2;

_targetDirection = [(getDir _obj) + _rotateAmount] call normalizeAngle;
_pitchBank = _obj call BIS_fnc_getPitchBank;

// Disabled until tilt system active
[_obj, [(_pitchBank select 0),(_pitchBank select 1), _targetDirection]] call setPitchBankYaw;
// [_obj, [0,0, _targetDirection]] call setPitchBankYaw;

true