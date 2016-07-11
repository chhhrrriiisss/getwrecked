//
//      Name: beamEffect
//      Desc: Orbital beam that melts and destroys vehicles
//      Return: None
//

_target = [_this,0, objNull, [objNull]] call filterParam;
_duration = [_this,1, 1, [0]] call filterParam;

if (isNull _target || _duration < 0) exitWith {};

_pos = (ASLtoATL visiblePositionASL _target);
_isVisible = [_pos, _duration] call effectIsVisible;

if (!_isVisible) exitWith {};

playSound3D ["a3\sounds_f\ambient\quakes\earthquake_3.wss", _target, false, _pos, 5, 10, 50];     

// 
// Light Effect
//

_target = createVehicle ["Land_FoodContainer_01_F", _pos, [], 0, 'CAN_COLLIDE'];
_target attachTo [(vehicle player), [0,50,0]];

_source2 = "#particlesource" createVehicleLocal _pos;
_source2 setParticleCircle [0, [0.1, 0.1, 3]];
_source2 setParticleParams 
/*Sprite*/		[["\A3\data_f\Cl_water", 1, 0, 1], "", 
/*Type*/			"Billboard",
/*TimmerPer*/		0,
/*Lifetime*/		0.5,
/*Position*/		[0, 0, 500], 
/*MoveVelocity*/	[0, 0, -2000],
/*Simulation*/		0, 30, 1, 0.075, 
/*Scale*/			[2, 3, 4, 5, 5], 
/*Color*/			[[1, 1, 0.3, 0], [1, 1, 0.3, 0.5], [1, 1, 0.3, 1], [1, 1, 0.3, 1]], 
/*AnimSpeed*/		[1.5, 0.5], 
/*randDirPeriod*/	0,
/*randDirIntesity*/	0,
/*onTimerScript*/	"",
/*DestroyScript*/	"",
/*Follow*/			_target,
/*Angle*/              0,
/*onSurface*/          true,
/*bounceOnSurface*/    0.5,
/*emissiveColor*/      [[0,0,0,0]]];

_source2 setParticleRandom 
	[0, 
	[0, 0, 0], 
	[0, 0, 0], 
	0, 
	1, 
	[0.1, 0.1, 0.3, 1], 
	0, 
	0
];

_source2 setDropInterval 0.0001;

//
//	Refract Effect
//

_scale = 0.5;	
_source3  = "#particlesource" createvehiclelocal _pos;
_source3 setParticleCircle [0, [0, 0, 0]];
_source3 setParticleRandom [0.2, [15 * _scale, 15 * _scale, 0], [0, 0, 0], 1, 0.5, [0, 0, 0, 0], 0, 0];
_source3 setDropInterval 0.01;
_source3 attachTo [_target];

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
_target																	//Object
];	

//
//	Scorch Effect
//

_source4  = "#particlesource" createvehiclelocal _pos;
_source4 setParticleCircle [0.5, [0, 0, 0]];
_source4 setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 1, [0, 0, 0, 0.5], 0, 0];
_source4 setParticleParams [["\A3\data_f\krater", 1, 0, 1], "", "SpaceObject", 0.05, 60, [0, 0, 0], [0, 0, 0], 0, 20, 7, 0.01, [1.5, 1.5, 1.5, 1.5], [[0, 0, 0, 1]], [5], 0, 0, "", "", _target];
_source4 setDropInterval 0.1;
_source4 attachTo [_target];

//
//	Smoke Effect
//	

_offset = 0;
_scale = 1;
_color = [0.1,0.1,0.1,1];

_source5 = "#particlesource" createVehicleLocal _pos;
_source5 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 10, [0, 0, 0],[0, _offset, 1], 0, 1.277, 1, 0.025, [(2 * _scale), (7*_scale), (11*_scale), (13*_scale)], [[(_color select 0), (_color select 1), (_color select 2), 0.7],[(_color select 0), (_color select 1), (_color select 2), 0.5], [(_color select 0), (_color select 1), (_color select 2), 0.25], [1, 1, 1, 0]],[0.2], 1, 0.04, "", "", _target];
_source5 setParticleRandom [2, [0.5, 0.5, 0.5], [1.5, 1.5, 1], 20, 0.2, [0, 0, 0, 0.1], 0, 0, 360];
_source5 setDropInterval 0.03;
_source5 attachTo [_target];


Sleep _duration;

deleteVehicle _target;
deleteVehicle _source2;	
deleteVehicle _source3;	
deleteVehicle _source4;	
deleteVehicle _source5;