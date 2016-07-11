//
//      Name: burnEffect
//      Desc: Sets an object on fire with smoke and flames
//      Return: None
//

_target = [_this,0, objNull, [objNull]] call filterParam;
_duration = [_this,1, 1, [0]] call filterParam;

if (isNull _target || _duration < 0) exitWith {};

_pos = (ASLtoATL visiblePositionASL _target);
_isVisible = [_pos, _duration] call effectIsVisible;
if (!_isVisible) exitWith {};

_source = "#particlesource" createVehicle _pos;
_source setParticleClass "ObjectDestructionFire1Smallx";
_source setDropInterval 0.075;
_source attachTo [_target];

_source2 = "#particlesource" createVehicleLocal _pos;
_source2 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 5, [0, 0, 0],
[0, 0, 0.5], 0, 1.277, 1, 0.025, [1, 2, 4, 6], [[0, 0, 0, 0.7],[0, 0, 0, 0.5], [0, 0, 0, 0.25], [1, 1, 1, 0]],
[0.2], 1, 0.04, "", "", _target];
_source2 setParticleRandom [2, [0.3, 0.3, 0.3], [1.5, 1.5, 1], 20, 0.2, [0, 0, 0, 0.1], 0, 0, 360];
_source2 setDropInterval 0.75;
_source2 attachTo [_target];

_scale = 0.1;

_source3  = "#particlesource" createvehiclelocal _pos;
_source3 setParticleCircle [0, [0, 0, 0]];
_source3 setParticleRandom [0.2, [15 * _scale, 15 * _scale, 0], [0, 0, 0], 1, 0.5, [0, 0, 0, 0], 0, 0];
_source3 setDropInterval 0.02;
_source3 attachTo [_target];

_source3 setParticleParams
[
	["\A3\data_f\ParticleEffects\Universal\Refract",1, 0, 1, 0],					//ShapeName ,1,0,1],	
	"",																		//AnimationName
	"Billboard",															//Type
	1,																		//TimerPeriod
	2,																	//LifeTime
	[0, 0, 0],																//Position
	[30 * _scale, 30 * _scale, 0],															//MoveVelocity
	0,																		//RotationVelocity
	3,																		//Weight
	3,																		//Volume
	0.1,																	//Rubbing
	[5 * _scale, 60 * _scale],																	//Size
	[[1, 1, 1, 0.5], [1, 1, 1, 0.3],  [1, 1, 1, 0]],		//0.15												//Color
	[1],					  												//AnimationPhase
	0,																		//RandomDirectionPeriod
	0,																		//RandomDirectionIntensity
	"",																		//OnTimer
	"",																		//BeforeDestroy
	_target																	//Object
];	

Sleep _duration;

deleteVehicle _source;	
deleteVehicle _source2;	
deleteVehicle _source3;	