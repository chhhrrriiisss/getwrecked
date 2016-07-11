//
//      Name: magnetEffect
//      Desc: Large refraction effect to simulate magnetic pulse
//      Return: None
//

private ['_target', '_pos', '_duration', '_size'];

_target = [_this,0, objNull, [objNull]] call filterParam;
_duration = [_this,1, 1, [0]] call filterParam;
_scale = [_this,2, 1, [0]] call filterParam;

if (isNull _target || _duration < 0) exitWith {};

_pos = (ASLtoATL visiblePositionASL _target);
_isVisible = [_pos, _duration] call effectIsVisible;
if (!_isVisible) exitWith {};

_source  = "#particlesource" createvehiclelocal _pos;
_source setParticleCircle [0, [0, 0, 0]];
_source setParticleRandom [0.2, [15 * _scale, 15 * _scale, 0], [0, 0, 0], 1, 0.5, [0, 0, 0, 0], 0, 0];
_source setDropInterval 0.01;
_source attachTo [_target];

_source setParticleParams
[
	["\A3\data_f\ParticleEffects\Universal\Refract",1, 0, 1, 0],					//ShapeName ,1,0,1],	
	"",																		//AnimationName
	"Billboard",															//Type
	1,																		//TimerPeriod
	0.15,																	//LifeTime
	[0, 0, 0],																//Position
	[30 * _scale, 30 * _scale, 0],															//MoveVelocity
	0,																		//RotationVelocity
	3,																		//Weight
	3,																		//Volume
	0.1,																	//Rubbing
	[5 * _scale, 60 * _scale],																	//Size
	[[1, 1, 1, 1], [1, 1, 1, 0.7],  [1, 1, 1, 0.1]],		//0.15												//Color
	[1],					  												//AnimationPhase
	0,																		//RandomDirectionPeriod
	0,																		//RandomDirectionIntensity
	"",																		//OnTimer
	"",																		//BeforeDestroy
	_target																	//Object
];	

Sleep _duration;

deleteVehicle _source;