//
//      Name: magnetEffect
//      Desc: Large refraction effect to simulate magnetic pulse
//      Return: None
//

private ['_target', '_pos', '_duration', '_size'];

_target = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_duration = [_this,1, 1, [0]] call BIS_fnc_param;

if (isNull _target || _duration < 0) exitWith {};
_pos = visiblePositionASL _target;

_source  = "#particlesource" createvehiclelocal _pos;
_source setParticleCircle [0, [0, 0, 0]];
_source setParticleRandom [0.2, [15, 15, 0], [0, 0, 0], 1, 0.5, [0, 0, 0, 0], 0, 0];
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
	[30, 30, 0],															//MoveVelocity
	0,																		//RotationVelocity
	3,																		//Weight
	3,																		//Volume
	0.1,																	//Rubbing
	[5, 60],																	//Size
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