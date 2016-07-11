//
//      Name: fireRpg
//      Desc: Fires a dumbfire missile that carries a mild explosive 
//      Return: None
//

params ['_gun', '_target', '_vehicle'];

_indirect = (_this select 0) call isIndirect;
_repeats = 1;
_round = "R_PG32V_F";
_soundToPlay = "a3\sounds_f\weapons\Launcher\nlaw_final_2.wss";

[_gun] spawn muzzleEffect;

_targetPos = if (_target isEqualTo objNull) then { getPosASL _target } else { _target };
_gPos = _gun modelToWorldVisual [2.5,0,-0.7];
if (GW_DEBUG) then { [_gPos, _targetPos, 3] spawn debugLine; };

_range = [(_gPos distance _targetPos) / 4, 70, 150] call limitToRange;
_heading = if (_indirect) then { ([ATLtoASL _gPos, ATLtoASL _targetPos] call BIS_fnc_vectorFromXtoY) } else { GW_CAMERA_HEADING };
_velocity = [_heading, _range] call BIS_fnc_vectorMultiply; 
_velocity = _velocity vectorAdd GW_CURRENTVEL;

_bullet = createVehicle [_round, _gPos, [], 0, "FLY"];

[(ATLtoASL _gPos), (ATLtoASL _targetPos), "RPG"] call markIntersects;

_bullet setVectorDir _heading; 
_bullet setVelocity _velocity; 

playSound3D [_soundToPlay, _gun, false, getPosASL _gun, 10, 1, 50];		

addCamShake [.5, 1,20];

true
