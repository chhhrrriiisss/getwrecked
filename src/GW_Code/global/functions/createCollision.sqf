//
//      Name: createCollision
//      Desc: Generate new setVelocity vectors for two colliding vehicles
//      Return: None
//

params ['_v1', '_vectIn', '_v2', '_vectOut'];

if (_v1 == _v2) exitWith {};
if (GW_DEBUG) then { systemchat format['%1 colliding with %2 at %3.', typeof _v1, typeof _v2, time]; };

if (isNil "GW_LAST_VELOCITY_UPDATE") then { GW_LAST_VELOCITY_UPDATE = time - 1; };
if (time - GW_LAST_VELOCITY_UPDATE < 0.025) exitWith {};
GW_LAST_VELOCITY_UPDATE = time;


if (isNil "GW_LAST_AUDIO_UPDATE") then { GW_LAST_AUDIO_UPDATE = time - 0.2; };
if (time - GW_LAST_AUDIO_UPDATE > 0.1) then {
	GW_LAST_AUDIO_UPDATE = time;
	_sfx = if ((random 100) > 50) then { "a3\sounds_f\sfx\missions\vehicle_drag_end.wss" } else { "a3\sounds_f\sfx\missions\vehicle_collision.wss" };
	playSound3D [_sfx, _v1, false, (ASLtoATL visiblePositionASL _v1), 10, 1, 50];
};

_speed = ((velocity _v1) distance [0,0,0]) * 0.12;
_vectIn = [(_vectIn select 0) * _speed, (_vectIn select 1) * _speed, (_vectIn select 2) * _speed];

_dist = _v1 distance _v2;
[_v1, _v2, _dist, (_this select 1)] spawn {

	_timeout = time + 3;
	_v = (_this select 3);
	waitUntil {			
		_d = (_this select 0) distance (_this select 1);
		_speed = [2 * _d, 0.05, 2] call limitToRange;
		_dir = [(_this select 1), (_this select 0)] call dirTo;
		(_this select 0) setVelocity [(_v select 0)+(sin _dir*_speed),(_v select 1)+(cos _dir*_speed),(_v select 2) + 0.1];	



		(time > _timeout) || (_d >= (_this select 2))
	};		

};

// Don't apply velocity to vehicles attached to other vehicles
if (!isNull (attachedTo _v2)) exitWith {};

_vectOut = [(_vectIn select 0) * -5, (_vectIn select 1) * -5, (_vectIn select 2) * -5];	
if (local _v2) then {
		_v2 setVelocity _vectOut;
} else {
	[       
		[
			_v2,
			_vectOut
		],
		"setVelocityLocal",
		_v2,
		false 
	] call bis_fnc_mp;
};
