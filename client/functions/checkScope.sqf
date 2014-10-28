//
//      Name: checkScope
//      Desc: Determines if target is whether the source is looking (within tolerance)
//      Return: Bool
//

private ['_source', '_target', '_tolerance'];

_source = [_this,0, 0, [0, objNull]] call BIS_fnc_param;
_target = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
_tolerance = [_this, 2, 10, [0]] call BIS_fnc_param;

// Get angles for both source and target
_sourceDir = if (typename _source == "OBJECT") then { getDir _source } else { _source };
_targetDir = [(vehicle player), _target] call BIS_fnc_dirTo;

// Difference between the source direction and target's direction
_dif = abs ( [_sourceDir - _targetDir] call flattenAngle );

if (_dif < _tolerance) exitWith { true };

false