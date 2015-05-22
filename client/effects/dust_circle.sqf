//
//      Name: dustCircle
//      Desc: Small dust effect in a radius
//      Return: None
//

 _target = [_this,0, objNull, [objNull]] call filterParam;
_duration = [_this,1, 1, [0]] call filterParam;

if (isNull _target || _duration < 0) exitWith {};

_pos = (ASLtoATL visiblePositionASL _target);
_isVisible = [_pos, _duration] call effectIsVisible;
if (!_isVisible) exitWith {};

_source = "#particlesource" createVehicleLocal _pos;
_source setParticleClass "CircleDustSmall";
_source setDropInterval 0.02;
_source attachTo [_target];

Sleep _duration;
deleteVehicle _source;