//
//      Name: dustCircle
//      Desc: Small dust effect in a radius
//      Return: None
//

 _target = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_duration = [_this,1, 1, [0]] call BIS_fnc_param;

if (isNull _target || _duration < 0) exitWith {};
_pos = if (typename _target == "LOCATION") then { _target } else { visiblePositionASL _target };
if ((visiblePositionASL player) distance _pos > GW_EFFECTS_RANGE) exitWith {};

_source = "#particlesource" createVehicleLocal _pos;
_source setParticleClass "CircleDustSmall";
_source setDropInterval 0.02;
_source attachTo [_target];

Sleep _duration;
deleteVehicle _source;