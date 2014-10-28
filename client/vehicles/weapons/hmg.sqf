//
//      Name: fireHmg
//      Desc: Fires a burst of .50 cal rounds at the target
//      Return: None
//

private ['_gun', '_target', '_vehicle'];

_gun = _this select 0;
_target = _this select 1;
_vehicle = _this select 2;

_repeats = 1;
_round = "B_127x99_Ball";
_soundToPlay = "a3\sounds_f\weapons\HMG\HMG_gun.wss";
_fireSpeed = 0.5;
_projectileSpeed = 800;
_range = 300;

_special = _vehicle getVariable ["special", []];

[
	[
		_gun
	],
	"muzzleEffect"
] call BIS_fnc_MP;

for "_i" from 1 to _repeats step 1 do {

	_targetPos = if (typename _target == 'OBJECT') then { getPosASL _target } else { _target };
	_gPos = _gun selectionPosition "otochlaven";
	_gPos set[1, 2];
	_gPos set[2, -0.7];
	_gPos = _gun modelToWorld _gPos;

	_heading = [_gPos, _targetPos] call BIS_fnc_vectorFromXToY;
	_velocity = [_heading, _projectileSpeed] call BIS_fnc_vectorMultiply; 

	playSound3D ["a3\sounds_f\weapons\HMG\HMG_gun.wss", _gun, false, _gPos, 2, 1, 150];

	// If we're using HE Ammo
	if ('EXP' in _special) then {		
		_round = "B_35mm_AA_Tracer_Yellow";		
		_fireSpeed = 2; // Slow fire rate to prevent spam
	};

	// If we're using incendiary ammo
	if ('IND' in _special) then {		
		_round = "B_127x99_Ball_Tracer_Yellow";		
		[(getPosASL _gun), (ATLtoASL _targetPos), _vehicle, 25] spawn burnIntersects;
	};	

	_bullet = createVehicle [_round, _gPos, [], 0, "FLY"];

	if (GW_DEBUG) then { [_gPos, _targetPos, 3] spawn debugLine; };

	[(ATLtoASL _gPos), (ATLtoASL _targetPos)] call markIntersects;

	_bullet setVectorDir _heading; 
	_bullet setVelocity _velocity; 

	Sleep _fireSpeed;
};

addCamShake [0.2, .3,20];

true
