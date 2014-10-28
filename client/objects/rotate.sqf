//
//      Name: rotateObj
//      Desc: Rotates an object by the specified amount (yaw)
//      Return: None
//

private ["_obj", "_rotateAmount","_targetDirection"];

_obj = _this select 0;
_rotateAmount = _this select 1;

_targetDirection = (getDir _obj) + _rotateAmount; 
_pitchBank = _obj call BIS_fnc_getPitchBank;

[_obj, [(_pitchBank select 0),(_pitchBank select 1), _targetDirection]] call setPitchBankYaw;

true