//
//      Name: rotateObj
//      Desc: Rotates an object by the specified amount (yaw)
//      Return: None
//

private ["_obj", "_rotateAmount","_targetDirection"];
params ['_obj', '_rotateAmount', '_toggle'];

_targetDirection = if (isNull attachedTo _obj) then { [(getDir _obj) + _rotateAmount] call normalizeAngle; } else { 
	_dirAttached = getDir (attachedTo _obj);
	_objDir =_obj getVariable ['GW_relDirection', (getDir _obj)];
	_obj setVariable ['GW_relDirection', _objDir + _rotateAmount];
	([(_objDir - _dirAttached) + _rotateAmount] call normalizeAngle)
};

_pitchBank = _obj call BIS_fnc_getPitchBank;

// Disabled until tilt system active

[_obj, [(_pitchBank select 0),(_pitchBank select 1), _targetDirection]] call setPitchBankYaw;
// [_obj, [0,0, _targetDirection]] call setPitchBankYaw;

true