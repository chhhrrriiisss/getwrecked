//
//      Name: smokeEffect
//      Desc: Large white clouds of smoke in a trail
//   

_target = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_duration = [_this,1, 1, [0]] call BIS_fnc_param;

if (isNull _target || _duration < 0) exitWith {};
_pos = visiblePosition _target;
if ((visiblePositionASL player) distance _pos > GW_EFFECTS_RANGE) exitWith {};

_source = "#particlesource" createVehicleLocal _pos;
_source setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 10, [0, 0, 0],
[0, 0, 0.5], 0, 1.277, 1, 0.025, [0.5, 8, 12, 15], [[1, 1, 1, 0.7],[1, 1, 1, 0.5], [1, 1, 1, 0.25], [1, 1, 1, 0]],
[0.2], 1, 0.04, "", "", _target];
_source setParticleRandom [2, [0.3, 0.3, 0.3], [1.5, 1.5, 1], 20, 0.2, [0, 0, 0, 0.1], 0, 0, 360];
_source setDropInterval 0.05;
_source attachTo [_target];

Sleep _duration;
deleteVehicle _source;
