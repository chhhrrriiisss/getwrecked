//
//      Name: fireHarpoon
//      Desc: Fires a hook that grabs and electrocutes vehicles
//      Return: None
//

private ["_obj"];

_obj = _this select 0;
_target = _this select 1;
_vehicle = _this select 2;

_repeats = 3;
_projectileSpeed = 100;
_projectileRange = 50;
_lifetime = 7;

// Prevent multiple harpoons from the same launcher
_srcRope = _obj getVariable ['sourceRope', nil];
if (!isNil "_srcRope") then {
	ropeDestroy _srcRope;
};

_oPos = _obj modelToWorldVisual [0,0,0];
_tPos = if (typename _target == 'OBJECT') then { (ASLtoATL getPosASL _target) } else { _target };

if ((_tPos select 2) < 2) then { _tPos set [2, 2]; };

_heading = [_oPos,_tPos] call BIS_fnc_vectorFromXToY;
_velocity = [_heading, _projectileSpeed] call BIS_fnc_vectorMultiply; 
_velocity = (velocity _vehicle) vectorAdd _velocity;

_src = createVehicle ["Land_PenBlack_F", _oPos, [], 0, "CAN_COLLIDE"];

_attachPoint = _vehicle worldToModel (ASLtoATL visiblePositionASL _obj);
_attachPoint set[1, (_attachPoint select 1) + 0.5];
_attachPoint set[0, (_attachPoint select 0) - 0.075];

playSound3D ["a3\sounds_f\weapons\smokeshell\smoke_1.wss", _vehicle, false, (ASLtoATL visiblePositionASL _vehicle), 3, 1, 40]; 

_rope = ropeCreate[_vehicle, _attachPoint, _src, [0,0,0], 20];
[_src,[0,0,0]] ropeAttachTo _rope;

_obj setVariable ['sourceRope', _rope];
_src setVariable ['sourceRope', _rope];
_src setVectorDir _heading; 
_src setVelocity _velocity; 

[_obj] spawn muzzleEffect;

if (GW_DEBUG) then { [ (ATLtoASL _oPos), (ATLtoASL _tPos), 0.1] spawn debugLine; };


// _objects = lineIntersectsWith [ (ATLtoASL _oPos), (ATLtoASL _tPos), _vehicle, objNull, false];
// systemchat str _objects;

// {

// 	_isVehicle = _x getVariable ["isVehicle", false];

// 	if (_isVehicle && { _x distance _vehicle < 40 }) exitWith {

// 		systemchat str _x;
// 		// Create a new rope at the distance between the two objects
// 		_rope2 = ropeCreate[_vehicle, _attachPoint, _x, [0,0,0], 20];

// 	};

// } count _objects > 0;

_src addEventHandler['EpeContactStart', {	
	
	if (!isNull (_this select 1)) then {

		_o = _this select 0;
		_v = _this select 1;
		
		_isVehicle = _v getVariable ["isVehicle", false];

		if (_isVehicle && _v != (vehicle player)) then {

			_srcRope = _o getVariable ['sourceRope', nil];

			systemchat 'contact!';

			_attachPoint = _v worldToModel (ASLtoATL visiblePositionASL _o);
			systemchat str _attachPoint;

			[_v, [0,0,0]] ropeAttachTo _srcRope;

			// _newAttachPoint = _v worldToModel (ASLtoATL visiblePositionASL _o); // Not used atm due to unreliability
			// _rope2 = ropeCreate[(_srcPoint select 1), (_srcPoint select 0), _v, [0,0,0], 20];

		};

	};
	
}];

_vehicle addEventHandler['RopeBreak', {

	systemchat 'rope detached';
}];


[_src, _rope, _obj] spawn { 
	
	_o = _this select 0;
	_r = _this select 1;
	_obj = _this select 2;

	_timeout = time + 3;
	waitUntil{
	if ( time > _timeout || (((getPos _o) select 2) < 0.1) ) exitWith { true };
	false
	};

	if (isNull ropeAttachedTo _r) then {

		ropeDestroy _r;
		_obj setVariable ['sourceRope', nil];
		_o removeEventHandler['EpeContactStart', 0];
		deleteVehicle _o;

	};

};

true


// private ['_gun', '_target', '_vehicle'];

// _gun = _this select 0;
// _target = _this select 1;
// _vehicle = _this select 2;

// _round = "B_127x99_Ball";
// _soundToPlay = "a3\sounds_f\weapons\HMG\HMG_gun.wss";
// _fireSpeed = 0.35;
// _projectileSpeed = 600;
// _range = 300;

// _special = _vehicle getVariable ["special", []];

// [_gun] spawn muzzleEffect;

// _targetPos = if (typename _target == 'OBJECT') then { getPosASL _target } else { _target };
// _gPos = _gun selectionPosition "otochlaven";
// _gPos set[1, 2];
// _gPos set[2, -0.7];
// _gPos = _gun modelToWorld _gPos;

// _heading = [_gPos, _targetPos] call BIS_fnc_vectorFromXToY;
// _velocity = [_heading, _projectileSpeed] call BIS_fnc_vectorMultiply; 

// playSound3D ["a3\sounds_f\weapons\HMG\HMG_gun.wss", _gun, false, _gPos, 2, 1, 150];

// // If we're using HE Ammo
// if ('EXP' in _special) then {		
// 	_round = "B_35mm_AA_Tracer_Yellow";		
// 	_fireSpeed = 2; // Slow fire rate to prevent spam
// };

// // If we're using incendiary ammo
// if ('IND' in _special) then {		
// 	_round = "B_127x99_Ball_Tracer_Yellow";		
// 	[(getPosASL _gun), (ATLtoASL _targetPos), _vehicle, 15, 0] spawn burnIntersects;
// };	

// _bullet = createVehicle [_round, _gPos, [], 0, "FLY"];

// if (GW_DEBUG) then { [_gPos, _targetPos, 0.1] spawn debugLine; };

// [(ATLtoASL _gPos), (ATLtoASL _targetPos)] spawn markIntersects;

// _bullet setVectorDir _heading; 
// _bullet setVelocity _velocity; 

// addCamShake [0.2, .3,20];

// true
