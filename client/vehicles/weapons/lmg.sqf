//
//      Name: fireLmg
//      Desc: Fires a burst of 7.62mm rounds at high velocity
//      Return: None
//

private ['_gun', '_target', '_vehicle'];

_gun = _this select 0;
_target = _this select 1;
_vehicle = _this select 2;

_round = "B_762x51_Tracer_Green";
_soundToPlay = "a3\sounds_f\weapons\HMG\HMG_gun.wss";
_fireSpeed = 0.35;
_projectileSpeed = 800;
_range = 300;

_special = _vehicle getVariable ["special", []];

[_gun] spawn muzzleEffect;

_targetPos = if (typename _target == 'OBJECT') then { getPosASL _target } else { _target };
_gPos = _gun selectionPosition "otochlaven";
_gPos set[1, 2];
_gPos set[2, -0.7];
_gPos = _gun modelToWorld _gPos;

_heading = [_gPos, _targetPos] call BIS_fnc_vectorFromXToY;
_velocity = [_heading, _projectileSpeed] call BIS_fnc_vectorMultiply; 

playSound3D ["a3\sounds_f\weapons\Zafir\zafir_2a7.wss", _gun, false, _gPos, 2, 1, 150];

// // If we're using HE Ammo
// if ('EXP' in _special) then {		
// 	_round = "B_35mm_AA_Tracer_Yellow";		
// };

// // If we're using incendiary ammo
// if ('IND' in _special) then {		
// 	_round = "B_127x99_Ball_Tracer_Yellow";		
// 	[(getPosASL _gun), (ATLtoASL _targetPos), _vehicle, 15, 0] spawn burnIntersects;
// };	

_bullet = createVehicle [_round, _gPos, [], 0, "FLY"];

if (GW_DEBUG) then { [_gPos, _targetPos, 0.1] spawn debugLine; };

[(ATLtoASL _gPos), (ATLtoASL _targetPos), "LMG"] spawn markIntersects;

_bullet setVectorDir _heading; 
_bullet setVelocity _velocity; 

addCamShake [0.1, .3,20];

true
