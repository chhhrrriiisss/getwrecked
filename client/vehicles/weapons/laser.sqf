//
//      Name: fireLaser
//      Desc: Fires a laser at the target, that sets light to vehicles in path
//      Return: None
//

private ["_obj"];

_obj = _this select 0;
_target = _this select 1;
_vehicle = _this select 2;

_oPos = (ASLtoATL getPosASL _obj);
_tPos = if (typename _target == 'OBJECT') then { (ASLtoATL getPosASL _target) } else { _target };

_points = [_obj, _tPos];

[_obj] spawn muzzleEffect;

[
	[
		[[1,0,0,1], 1, _points]
	],
	"laserLine"
] call BIS_fnc_MP;

playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_2.wss", _obj, false, _oPos, 2, 1, 50];	

[_obj, _target, _vehicle] spawn {

	_projectileSpeed = 1000;
	_oPos = (ASLtoATL getPosASL (_this select 0));
	_tPos = if (typename (_this select 1) == 'OBJECT') then { (ASLtoATL getPosASL (_this select 01)) } else { (_this select 1) };

	[(ATLtoASL _oPos), (ATLtoASL _tPos), "LSR"] call markIntersects;	

	for "_i" from 1 to 15 step 1 do {

		_oPos = (_this select 0) modelToWorldVisual [0,-2, 0];
		_oPos set [2, (_oPos select 2) + 0.4]; // Adjusted center of laser

		[(_this select 0)] spawn muzzleEffect;

		_tPos = if (typename (_this select 1) == 'OBJECT') then { (ASLtoATL getPosASL (_this select 01)) } else { (_this select 1) };

		_heading = [_oPos,_tPos] call BIS_fnc_vectorFromXToY;
		_velocity = [_heading, _projectileSpeed] call BIS_fnc_vectorMultiply; 

		_bullet = createVehicle ["B_127x99_Ball_Tracer_Red", _oPos, [], 0, "CAN_COLLIDE"];
		_bullet setVectorDir _heading; 
		_bullet setVelocity _velocity; 

		[ATLtoASL _oPos, ATLtoASL _tPos, (vehicle player), 90, 0] spawn burnIntersects;
		[(ATLtoASL _oPos), (ATLtoASL _tPos), "LSR"] call markIntersects;

		Sleep 0.05;

	};

};

true