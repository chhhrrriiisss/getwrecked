//
//      Name: cloakEffect
//      Desc: Uses a refract effect to simulate a cloaked entity
//      Return: None
//

private ['_target', '_pos', '_duration', '_size'];

 _target = [_this,0, objNull, [objNull]] call filterParam;
_duration = [_this,1, 1, [0]] call filterParam;
_size = [_this,2, 1, [0]] call filterParam;

if (isNull _target || _duration < 0 || _size < 0) exitWith {};

_pos = (ASLtoATL visiblePositionASL _target);
_isVisible = [_pos, _duration] call effectIsVisible;
if (!_isVisible) exitWith {};

// Prep pe
_source  = "#particlesource" createvehiclelocal _pos;
_source setParticleCircle [0, [0, 0, 0]];
_source setParticleRandom [0.2, [0, 0, 0], [0.0, 0.0, 0], 1, 0.5, [0, 0, 0, 0], 0, 0];
_source setDropInterval 0.02;
_source attachTo [_target];

_source setParticleParams
[
	["\A3\data_f\ParticleEffects\Universal\Refract",1, 0, 1, 0],					//ShapeName ,1,0,1],	
	"",																		//AnimationName
	"Billboard",															//Type
	1,																		//TimerPeriod
	0.25,																	//LifeTime
	[0, 0, -0.25],																//Position
	[3, 3, -3],															//MoveVelocity
	1,																		//RotationVelocity
	3,																		//Weight
	3,																		//Volume
	0.1,																	//Rubbing
	[_size],																	//Size
	[[1, 1, 1, 0.15]],		//0.15												//Color
	[1],					  												//AnimationPhase
	0,																		//RandomDirectionPeriod
	0,																		//RandomDirectionIntensity
	"",																		//OnTimer
	"",																		//BeforeDestroy
	_target																	//Object
];	

Sleep _duration;
deleteVehicle _source;
