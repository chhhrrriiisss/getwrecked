//
//      Name: infernoEffect
//      Desc: Used by the flamePad
//      Return: None
//

_target = [_this,0, objNull, [objNull]] call filterParam;
_duration = [_this,1, 1, [0]] call filterParam;
_size = [_this,2, 1, [0]] call filterParam;

if (isNull _target || _duration < 0) exitWith {};

_pos = (ASLtoATL visiblePositionASL _target);
_isVisible = [_pos, _duration] call effectIsVisible;

if (!_isVisible) exitWith {};

// 
// Smoke Effect
//

_smokeScale = [_size, 0.5, 1] call limitToRange;
_source2 = "#particlesource" createVehicleLocal _pos;
_source2 setParticleParams 
/*Sprite*/		[["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "",// File,Ntieth,Index,Count,Loop(Bool)
/*Type*/			"Billboard",
/*TimmerPer*/		1,
/*Lifetime*/		8,
/*Position*/		[0,0,0],
/*MoveVelocity*/	[0,0,0.5],
/*Simulation*/		0,1.277,1,0.025,//rotationVel,weight,volume,rubbing
/*Scale*/			[5 * _smokeScale,6 * _smokeScale,7 * _smokeScale,8 * _smokeScale],
/*Color*/			[[0,0,0,0],[0,0,0,0.6],[0,0,0,0.6],[0,0, 0,0.4], [0,0,0,0.15], [1,1,1,0]],
/*AnimSpeed*/		[0.2],
/*randDirPeriod*/	1,
/*randDirIntesity*/	0.04,
/*onTimerScript*/	"",
/*DestroyScript*/	"",
/*Follow*/			_this,
/*Angle*/              0,
/*onSurface*/          true,
/*bounceOnSurface*/    0.5,
/*emissiveColor*/      [[0,0,0,0]]];

// RANDOM / TOLERANCE PARAMS
_source2 setParticleRandom
/*LifeTime*/		[2,
/*Position*/		[2, 2, 0.5],
/*MoveVelocity*/	[1.5, 1.5, 3],
/*rotationVel*/		20,
/*Scale*/		0.2,
/*Color*/		[0, 0, 0, 0.1],
/*randDirPeriod*/	0,
/*randDirIntesity*/	0,
/*Angle*/		360];

_source2 setDropInterval 0.1;
_source2 attachTo [_this];

//
//	Refract Effect
//

_scale = 0.5 * _size;	
_source3  = "#particlesource" createvehiclelocal _pos;
_source3 setParticleCircle [0, [0, 0, 0]];
_source3 setParticleRandom [0.2, [15 * _scale, 15 * _scale, 0], [0, 0, 0], 1, 0.5, [0, 0, 0, 0], 0, 0];
_source3 setDropInterval 0.05;
_source3 attachTo [_this];

_source3 setParticleParams
[
["\A3\data_f\ParticleEffects\Universal\Refract",1, 0, 1, 0],					//ShapeName ,1,0,1],	
"",																		//AnimationName
"Billboard",															//Type
3,																		//TimerPeriod
6,																	//LifeTime
[0.1, 0.1, 0.1],																//Position
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
_this																	//Object
];	


// 
//	Fire Effect
//
_source = "#particlesource" createVehicle _pos;
_source setParticleClass "ObjectDestructionFire1Smallx";
_source setDropInterval 0.0125;
	// RANDOM / TOLERANCE PARAMS
_source setParticleRandom
/*LifeTime*/		[3,
/*Position*/		[3, 3, 0.5],
/*MoveVelocity*/	[1, 1, 2],
/*rotationVel*/		20,
/*Scale*/		1.2 * _size,
/*Color*/		[0, 0, 0, 1],
/*randDirPeriod*/	3,
/*randDirIntesity*/	0.1,
/*Angle*/		0];

_source attachTo [_this];

Sleep _duration;

deleteVehicle _source;

deleteVehicle _source3;	

Sleep 0.5;

deleteVehicle _source2;	