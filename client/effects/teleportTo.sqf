params ['_o', '_v'];

if (!alive _v) exitWith {};

_pos = if (typename _o == "OBJECT") then { (ASLtoATL visiblePositionASL _o) } else { _o };

playSound3D ["a3\sounds_f\weapons\mines\electron_trigger_1.wss", _o, false, _pos, 5, 1, 100]; 

[
	[
		_v,
		4,
		0.5
	],
	"magnetEffect",
	true,
	false
] call bis_fnc_mp;

[		
	[
		_v,
		"railgun",
		35
	],
	"playSoundAll",
	true,
	false
] call bis_fnc_mp;

_v spawn {


	_timeout = time + 2;
	_n = 0;
	waitUntil {
		Sleep 0.25;
		_n = _n + 1;
		[_this, 5, 10] call shockwaveEffect;
		addCamShake[(random _n), 1, 10];
		(time > _timeout)
	};
};		

Sleep 2 + (random 1);

playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_1.wss", _v, false, (ASLtoATL visiblePositionASL _v), 10, 1, 150];	

_vel = velocity _v;
_dir = vectorDir _v;
_up = vectorUp _v;

_pos set [2, (_pos select 2) + 2];
_v setPos _pos;
addCamShake[10, 1, 10];
[_v, [_dir,_up]] call setVectorDirAndUpTo;
[       
	[
		_v,
		_vel
	],
	"setVelocityLocal",
	_v,
	false 
] call bis_fnc_mp;  