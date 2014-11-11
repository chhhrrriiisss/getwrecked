//
//      Name: fireRailgun
//      Desc: Fires a very fast projectile that destroys any vehicles in its path
//      Return: None
//

private ["_obj"];

_obj = _this select 0;
_target = _this select 1;
_vehicle = _this select 2;

_repeats = 1;
_projectileSpeed = 2000;

_oPos = (ASLtoATL getPosASL _obj);

playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_1.wss", _obj, false, _oPos, 2, 1, 50];	

_rnd = ((random 2) + 1.5);
_rnd spawn { addCamShake [0.4, (_this + 0.5),150]; };

Sleep _rnd;

_vel = velocity _vehicle;
_dir = [GW_TARGET_DIRECTION] call normalizeAngle;

_oPos = _obj modelToWorld [3,0,-0.7];
_tPos = GW_TARGET;

_heading = [_oPos,_tPos] call BIS_fnc_vectorFromXToY;
_velocity = [_heading, _projectileSpeed] call BIS_fnc_vectorMultiply; 

_bullet = createVehicle ["M_NLAW_AT_F", _oPos, [], 0, "FLY"];

_bullet disableCollisionWith _obj;
_bullet disableCollisionWith _vehicle;

_power = -20;
_vehicle setVelocity [(_vel select 0)+(sin _dir*_power),(_vel select 1)+(cos _dir*_power),(_vel select 2) + 0.4];	

playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_2.wss", _obj, false, _oPos, 2, 1, 50];	
addCamShake [10, .1,30];

[(ATLtoASL _oPos), (ATLtoASL _tPos)] call markIntersects;
[ATLtoASL _oPos, ATLtoASL _tPos, (vehicle player), 0.5] spawn damageIntersects;

_bullet setVectorDir _heading; 
_bullet setVelocity _velocity; 



