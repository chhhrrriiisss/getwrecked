//
//      Name: fireLaser
//      Desc: Fires a laser at the target, that sets light to vehicles in path
//      Return: None
//

params ['_obj', '_target', '_vehicle'];

_oPos = _obj modelToWorldVisual [0,0,0];
_tPos = if (_target isEqualTo objNull) then { (ASLtoATL visiblePositionASL _target) } else { _target };

[_obj] spawn muzzleEffect;

[
	[
		[_obj, _tPos, 'LSR']
	],
	"laserLine",
	true,
	false
] call bis_fnc_mp;

playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_2.wss", _obj, false, ATLtoASL _oPos, 2, 1, 50];	

[_obj, _target, _vehicle] spawn {
	
	_indirect = (_this select 0) call isIndirect;
	_projectileSpeed = 1000;

	_oPos = (_this select 0) modelToWorldVisual [0,0,0];
	_tPos = if ((_this select 1) isEqualTo objNull) then { (ASLtoATL visiblePositionASL (_this select 01)) } else { (_this select 1) };
	_sourcePos = _tPos;

	[(ATLtoASL _oPos), (ATLtoASL _tPos), "LSR"] call markIntersects;	

	_heading = if (_indirect) then { ([ATLtoASL _oPos, ATLtoASL _tPos] call BIS_fnc_vectorFromXToY) } else { GW_CAMERA_HEADING };
	_velocity = [_heading, _projectileSpeed] call BIS_fnc_vectorMultiply; 
	

	for "_i" from 1 to 7 step 1 do {

		_oPos = (_this select 0) modelToWorldVisual [0,-2, 0];
		_oPos set [2, (_oPos select 2) + 0.4]; // Adjusted center of laser

		[(_this select 0)] spawn muzzleEffect;

		// _tPos = if ((_this select 1) isEqualTo objNull) then { (ASLtoATL visiblePositionASL (_this select 01)) } else { (_this select 1) };
		_velocity = _velocity vectorAdd GW_CURRENTVEL;

		

		_bullet = createVehicle ["B_127x99_Ball_Tracer_Red", _oPos, [], 0, "CAN_COLLIDE"];
		_bullet setVectorDir _heading; 
		_bullet setVelocity _velocity; 

		[ATLtoASL _oPos, ATLtoASL _tPos, GW_CURRENTVEHICLE, 2, 0] spawn burnIntersects;
		[(ATLtoASL _oPos), (ATLtoASL _tPos), "LSR"] call markIntersects;

		Sleep 0.1;

	};

};

true