//
//      Name: flameEffect
//      Desc: Used by the flamethrower
//      Return: None
//

_target = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_duration = [_this,1, 1, [0]] call BIS_fnc_param;

if (isNull _target || _duration < 0) exitWith {};

_pos = (ASLtoATL visiblePositionASL _target);

if ((ASLtoATL visiblePositionASL player) distance _pos > GW_EFFECTS_RANGE) exitWith {};

_source = "#particlesource" createVehicle _pos;
_source setParticleClass "ObjectDestructionFire1Smallx";
_source setDropInterval 0.02;
_source attachTo [_target];

_source2 = "#particlesource" createVehicleLocal _pos;
_source2 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 5, [0, 0, 0],
[0, 0, 0.5], 0, 1.277, 1, 0.025, [2, 2, 2, 2], [[0, 0, 0, 0.7],[0, 0, 0, 0.5], [0, 0, 0, 0.25], [1, 1, 1, 0]],
[0.2], 1, 0.04, "", "", _target];
_source2 setParticleRandom [2, [0.3, 0.3, 0.3], [1.5, 1.5, 1], 20, 0.2, [0, 0, 0, 0.1], 0, 0, 360];
_source2 setDropInterval 0.02;
_source2 attachTo [_target];

Sleep _duration;

deleteVehicle _source;	
deleteVehicle _source2;	