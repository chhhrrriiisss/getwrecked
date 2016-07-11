//
//      Name: sparkEffect
//      Desc: Small electric sparks
//      Return: None
//

private ['_target', '_pos', '_duration', '_size'];

_target = [_this,0, objNull, [objNull]] call filterParam;
_duration = [_this,1, 1, [0]] call filterParam;
_scale = 1;

if (isNull _target || _duration < 0) exitWith {};

_pos = (ASLtoATL visiblePositionASL _target);
_isVisible = [_pos, _duration] call effectIsVisible;
if (!_isVisible) exitWith {};

_source  = "#particlesource" createvehiclelocal _pos;
_source setParticleClass "AvionicsSparks";
_source setParticleRandom [0.2, [15 * _scale, 15 * _scale, 0], [0, 0, 0], 1, 0.5, [0, 0, 0, 0], 0, 0];
_source setDropInterval 0.01;
_source attachTo [_target];

Sleep _duration;

deleteVehicle _source;