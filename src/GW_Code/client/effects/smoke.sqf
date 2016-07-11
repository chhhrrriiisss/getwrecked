//
//      Name: smokeEffect
//      Desc: Large white clouds of smoke in a trail
//   

_target = [_this,0, objNull, [objNull]] call filterParam;
_duration = [_this,1, 1, [0]] call filterParam;
_color = [_this,2, [1, 1, 1, 1], [[]]] call filterParam;
_scale = [_this,3, 1, [0]] call filterParam;
_offset = [_this,4, 0, [0]] call filterParam;

if (isNull _target || _duration < 0) exitWith {};

_pos = (ASLtoATL visiblePositionASL _target);
_isVisible = [_pos, _duration] call effectIsVisible;
if (!_isVisible) exitWith {};

_source = "#particlesource" createVehicleLocal _pos;
_source setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 10, [0, 0, 0],[0, _offset, 0.5], 0, 1.277, 1, 0.025, [(0.5 * _scale), (8*_scale), (12*_scale), (15*_scale)], 
[[(_color select 0), (_color select 1), (_color select 2), 0.7],[(_color select 0), (_color select 1), (_color select 2), 0.5], [(_color select 0), (_color select 1), (_color select 2), 0.25], [1, 1, 1, 0]],[0.2], 1, 0.04, "", "", _target];

_source setParticleRandom [2, [0.3, 0.3, 0.3], [1.5, 1.5, 1], 20, 0.2, [0, 0, 0, 0.1], 0, 0, 360];
_source setDropInterval 0.03;
_source attachTo [_target];

Sleep _duration;
deleteVehicle _source;
