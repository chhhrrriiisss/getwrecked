//
//      Name: fireHmg
//      Desc: Fires a burst of .50 cal rounds at the target
//      Return: None
//

params ['_gun', '_target', '_vehicle'];

_round = "B_127x99_Ball";
_soundToPlay = "a3\sounds_f\weapons\HMG\HMG_gun.wss";
_fireSpeed = 0.35;
_projectileSpeed = 600;
_range = 300;

[_gun] spawn muzzleEffect;

_targetPos = if (typename _target == 'OBJECT') then { (_target modelToWorldVisual [0,0,0.5]) } else { _target };
_gPos = _gun modelToWorldVisual [0, 3, -0.7];

_heading = [_gPos, _targetPos] call BIS_fnc_vectorFromXToY;
_velocity = [_heading, _projectileSpeed] call BIS_fnc_vectorMultiply; 

playSound3D ["a3\sounds_f\weapons\HMG\HMG_gun.wss", _gun, false, _gPos, 7, 1, 100];

// If we're using HE Ammo
if ('EXP' in GW_VEHICLE_SPECIAL) then {		
	_round = "B_35mm_AA_Tracer_Yellow";		
	_fireSpeed = 2; // Slow fire rate to prevent spam
};

// If we're using incendiary ammo
if ('IND' in GW_VEHICLE_SPECIAL) then {		
	_round = "B_127x99_Ball_Tracer_Yellow";		
	[(getPosASL _gun), (ATLtoASL _targetPos), _vehicle, 15, 0] spawn burnIntersects;
};	

_bullet = createVehicle [_round, _gPos, [], 0, "CAN_COLLIDE"];

if (GW_DEBUG) then { [_gPos, _targetPos, 0.01] spawn debugLine; };

[(ATLtoASL _gPos), (ATLtoASL _targetPos), "HMG"] spawn markIntersects;

_bullet setVectorDir _heading; 
_bullet setVelocity _velocity; 

addCamShake [0.2, .3,20];

true
