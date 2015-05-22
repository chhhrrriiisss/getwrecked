//
//      Name: firepOD
//      Desc: Fires small barrage of rockets that does light damage
//      Return: None
//

private ['_gun', '_target', '_vehicle'];

_this spawn {

	_indirect = true;
	{	
		if ((_x select 0) == (_this select 0)) exitWith { _indirect = false; };
	} count GW_AVAIL_WEAPONS > 0;

	for "_i" from 0 to 1 step 1 do {

		_gPos = (_this select 0) modelToWorldVisual [-3,0,0.25];
		_vehicle = _this select 2;
		_targetPos = if (_indirect) then { ((_this select 0) modelToWorldVisual [-50,0,0]) } else { ([(_this select 1), 40,30] call setVariance) };

		// If round lands too close
		_status = _vehicle getVariable ['status', []];
		_dist = (screenToWorld [0.5,0.5] distance (ASLtoATL visiblePositionASL GW_CURRENTVEHICLE));

		if (_dist < 20 && !('invulnerable' in _status)) then {
			_d = if ('nanoarmor' in _status) then { 0.01 } else { ((random 0.1) + 0.05) };
			_vehicle setDammage ((getDammage _vehicle) + _d);
			_vehicle call updateVehicleDamage;
		};

		_heading = [ASLtoATL _gPos, ASLtoATL _targetPos] call BIS_fnc_vectorFromXToY;
		_velocity = [_heading, 50] call BIS_fnc_vectorMultiply; 		

		_rocket = createVehicle ["M_Titan_AT_static", _gPos, [], 0, "FLY"];
		playSound3D ["a3\sounds_f\weapons\rockets\new_rocket_8.wss", (_this select 2), false, (ASLtoATL visiblePositionASL (_this select 2)), 10, 1, 40]; 

		_rocket setVectorDir _heading;
		_rocket setVelocity _velocity;

		[(_this select 0)] spawn muzzleEffect;

		[(ATLtoASL _gPos), (ATLtoASL _targetPos), "RPD"] call markIntersects;	

		[_rocket, _velocity, _targetPos] spawn {
			_lastPos = (ASLtoATL visiblePositionASL (_this select 0));

			waitUntil {		
				Sleep 0.1;
				// _lastPos = (ASLtoATL visiblePositionASL (_this select 0));
				// (_this select 1) set [2, ((_this select 1) select 2) -0.09];				
				// (_this select 0) setVelocity (_this select 1);
				(!alive (_this select 0))
			};

			[_lastPos, 5, "RPD"] call markNearby;
			[_lastPos, 10, 10] call shockwaveEffect;

		};

		addCamShake [1, 1,20];

		Sleep ((random 0.1) + 0.1);

	};

};

true
