//
//      Name: nitroEffect
//      Desc: Large, trailing refraction and engine noise
//     

private ['_target', '_pos', '_duration'];

_target = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_noise = [_this, 2, true, [false]] call BIS_fnc_param;

if (isNull _target) exitWith {};
_pos = visiblePositionASL _target;
if ((visiblePositionASL player) distance _pos > GW_EFFECTS_RANGE) exitWith {};

// Size of vehicle changes drop height of refraction
_height = ([_target] call getBoundingBox) select 2;
_pos set[2, (_pos select 2) + _height];
_duration = _this select 1;

// Mix the sound up a bit
if ((random 100) > 50 && _noise) then { _target say3D "nitro"; } else { _target say3D "nitroAlt"; };

_source  = "#particlesource" createvehiclelocal _pos;
_source setParticleCircle [0, [0, 0, 0]];
_source setParticleRandom [0.05, [0, 0, 0], [0, 0, 0], 1, 0.5, [0, 0, 0, 0], 0, 0];
_source setDropInterval 0.01;
_source attachTo [_target];

_source setParticleParams
[
	["\A3\data_f\ParticleEffects\Universal\Refract",1, 0, 1, 0],					//ShapeName ,1,0,1],	
	"",																		//AnimationName
	"Billboard",															//Type
	1,																		//TimerPeriod
	0.75,																	//LifeTime
	[0, -5, 0],																//Position
	[1, 1, 0],															//MoveVelocity
	0,																		//RotationVelocity
	3,																		//Weight
	3,																		//Volume
	0.1,																	//Rubbing
	[4, 4],																	//Size
	[[1, 1, 1, 1], [1, 1, 1, 0.5],  [1, 1, 1, 0.1]],		//0.15												//Color
	[1],					  												//AnimationPhase
	0,																		//RandomDirectionPeriod
	0,																		//RandomDirectionIntensity
	"",																		//OnTimer
	"",																		//BeforeDestroy
	_target																	//Object
];	

Sleep _duration;
deleteVehicle _source;