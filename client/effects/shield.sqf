//
//      Name: shieldEffect
//      Desc: Red bubble surrounding vehicle to simulate an "iron curtain" (If you've never played RA2, which rock have you been under?)
//   

_target = [_this,0, objNull, [objNull]] call filterParam;
_duration = [_this,1, 1, [0]] call filterParam;
_color = [_this,2, [1, 0.2, 0.2, 0.25], [[]]] call filterParam;

if (isNull _target || _duration < 0) exitWith {};

_pos = (ASLtoATL visiblePositionASL _target);
_isVisible = [_pos, _duration] call effectIsVisible;
if (!_isVisible) exitWith {};

_source = "#particlesource" createVehicleLocal _pos;
_source setParticleCircle [0, [0, 0, 0]];
_source setParticleParams [["\A3\data_f\missileSmoke", 1, 0, 1], "", "Billboard", 1, 0.1, [0, 0, 0], [0, 0, 0], 0, 0, 1, 0.075, [9, 8, 8, 8, 8, 8, 8, 8], [_color, _color, [0.5, 0.5, 0.5, 0.25]], [0.08, 0.08, 0.08, 0.08], 0, 0, "", "", _target];
_source setParticleRandom [0, [0.25, 0.25, 0], [0, 0, 0], 0, 0, [0.1, 0, 0, 0], 0, 0];
_source setDropInterval 0.005;
_source attachTo [_target];
Sleep _duration;
deleteVehicle _source;