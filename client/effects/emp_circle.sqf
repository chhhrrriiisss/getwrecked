//
//      Name: empCircle
//      Desc: Black pulse and refraction to simulate electromagnetism
//      Return: None
//

_target = [_this,0, objNull, [objNull]] call filterParam;
_duration = [_this,1, 1, [0]] call filterParam;

if (isNull _target || _duration < 0) exitWith {};

_pos = (ASLtoATL visiblePositionASL _target);
_isVisible = [_pos, _duration] call effectIsVisible;
if (!_isVisible) exitWith {};

_source = "#particlesource" createVehicleLocal _pos;	
_source setParticleCircle [0, [1000, 1000, 0.3]];
_source setParticleRandom [0, [0.25, 0.25, 0], [0, 0, 0], 1, 0, [0, 0, 0, 0], 0, 0];
_source setParticleParams [["\A3\data_f\Cl_water", 1, 0, 1], "", "Billboard", 1, 0.5, [0, 0, 0], [0, 0, 0], 3, 10.18, 8, 0.075, [3, 5, 8, 14], [[0, 0, 0.01, 0.9], [0, 0, 0.01, 0.4], [0, 0, 0.01, 0.1]], [0.08], 0, 0, "", "", _target];
_source setDropInterval 1;
_source attachTo [_target];

_source2  = "#particlesource" createvehiclelocal _pos;
_source2 setParticleCircle [0, [0, 0, 0]];
_source2 setParticleRandom [0.2, [15, 15, 0], [0, 0, 0], 1, 0.5, [0, 0, 0, 0], 0, 0];
_source2 setDropInterval 0.01;
_source2 attachTo [_target];

_source2 setParticleParams
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
	[5, 30],																	//Size
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
deleteVehicle _source2;