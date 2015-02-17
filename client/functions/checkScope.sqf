//
//      Name: checkScope
//      Desc: Determines if target is where the source is looking (within tolerance)
//      Return: Bool
//

private ['_source', '_target', '_tolerance'];

_source = _this select 0;
_target = _this select 1;
_tolerance = _this select 2;

// Get angles from source to target
_sourceDir = if (typename _source == "SCALAR") then { _source } else { getDir _source; };
_targetDir = [(vehicle player), _target] call dirTo;

// Difference between the source direction and target's direction
_dif = abs ( [_sourceDir - _targetDir] call flattenAngle );

if (_dif < _tolerance) exitWith { true };

false

