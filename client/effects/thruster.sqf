//
//      Name: thrusterEffect
//      Desc: Rocket burst, smoke and small refraction to simulate a rocket trail
//   

_target = [_this,0, objNull, [objNull]] call filterParam;
_duration = [_this,1, 1, [0]] call filterParam;

if (isNull _target || _duration < 0) exitWith {};

_pos = (ASLtoATL visiblePositionASL _target);
_isVisible = [_pos, _duration] call effectIsVisible;
if (!_isVisible) exitWith {};

_source = "#particlesource" createVehicleLocal _pos;
_source setParticleCircle [0, [0, 0, 0]];
_source setParticleParams [["\A3\data_f\Cl_water", 1, 0, 1], "", "Billboard", 1, 0.5, [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0.075, [0.4, 2, 3], [[0.99, 0.87, 0.41, 0.4], [0.8, 0.8, 0.8, 0.15], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _source];
_source setParticleRandom [0, [0.1, 0.1, 0], [0.175, 0.175, 0], 0, 0.1, [0, 0, 0, 0.1], 0, 0];	
_source setDropInterval 0.01;	
_source attachTo [_target]; 

_source2 = "#particlesource" createVehicleLocal _pos;
_source2 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 3, [0, 0, 0], [0, 0, 0.5], 0, 1.277, 1, 0.025, [0.5, 4, 6, 8], [[1, 1, 1, 0.7],[1, 1, 1, 0.5], [1, 1, 1, 0.25], [1, 1, 1, 0]],
[0.2], 1, 0.04, "", "", _source2];
_source2 setParticleRandom [2, [0.3, 0.3, 0.3], [1.5, 1.5, 1], 20, 0.2, [0, 0, 0, 0.1], 0, 0, 360];
_source2 setDropInterval 0.05;
_source2 attachTo [_target];

_source3  = "#particlesource" createvehiclelocal _pos;
_source3 setParticleCircle [0, [0, 0, 0]];
_source3 setParticleRandom [0.05, [0, 0, 0], [0, 0, 0], 1, 0.5, [0, 0, 0, 0], 0, 0];
_source3 setDropInterval 0.01;
_source3 attachTo [_target];

_source3 setParticleParams
[
	["\A3\data_f\ParticleEffects\Universal\Refract",1, 0, 1, 0],					//ShapeName ,1,0,1],	
	"",																		//AnimationName
	"Billboard",															//Type
	1,																		//TimerPeriod
	0.75,																	//LifeTime
	[0, 0, -2],																//Position
	[1, 1, 0],															//MoveVelocity
	0,																		//RotationVelocity
	3,																		//Weight
	3,																		//Volume
	0.1,																	//Rubbing
	[2, 4],																	//Size
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
deleteVehicle _source2;
deleteVehicle _source3;