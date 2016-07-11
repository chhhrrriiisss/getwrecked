//
//      Name: checkScope
//      Desc: Determines if target is where the source is looking (within tolerance)
//      Return: Bool
//

private ['_source', '_target', '_tolerance'];

_source = (_this select 0);
_target = (_this select 1);
_tolerance = [_this,2, 90, [0]] call filterParam;

// Get angles from source to target
_sourceDir = if (_source isEqualType 0) then { _source } else { (getDir _source); };
_sourceObj = if (_source isEqualType objNull) then { _source } else { (vehicle player) };
_targetDir = if (_target isEqualType 0) then { _target } else { ([_sourceObj, _target] call dirTo) };

// Difference between the source direction and target's direction
_dif = abs ( [_sourceDir - _targetDir] call flattenAngle );

if (_dif < _tolerance) exitWith { true };

false

