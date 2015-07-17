//
//      Name: fireLockOn
//      Desc: Fires a missile that tracks a locked target
//      Return: None
//

private ['_gun', '_target', '_vehicle', '_m', '_v', '_t'];

params ['_gun', '_nil', '_vehicle'];

_repeats = 1;
_round = "M_Titan_AT";
_soundToPlay = "a3\sounds_f\weapons\Launcher\nlaw_final_2.wss";
_fireSpeed = 0.3;
_projectileSpeed = 125;

_gPos = _gun selectionPosition "otochlaven";
_gPos set[1, 4];
_gPos set[2, 2];

if (count GW_LOCKEDTARGETS <= 0) exitWith {};
	
_lockedTarget = (GW_LOCKEDTARGETS select 0);

if (!alive _lockedTarget) then {

	GW_LOCKEDTARGETS = GW_LOCKEDTARGETS - [_lockedTarget];

} else { 

	_gPos = _gun modelToWorld _gPos;

	_missile = createVehicle [_round, _gPos, [], 0, "FLY"];	

	_tPos = _gun modelToWorld [0,10,0];
	_tPos set[2, (_gPos select 2) + 15];

	_heading = [_gPos,_tPos] call BIS_fnc_vectorFromXToY;
	_velocity = [_heading, 50] call BIS_fnc_vectorMultiply; 

	_missile setVectorDir _heading; 
	_missile setVelocity _velocity; 

	addCamShake [.5, 1,30];
	playSound3D [_soundToPlay, _gun, false, getPos _gun, 1, 1, 50];		

	// Spawn the loop that keeps updating the missile heading/velocity
	[_missile, _vehicle, _lockedTarget] spawn {		

		Sleep 0.75;

		params ['_mis', '_v', '_t'];
		
		_timeout = time + 10;

		for "_i" from 0 to 1 step 0 do {

			if (!alive _mis || !alive _v || !alive _t || time > _timeout) exitWith {};

			// Abort updating the heading if the target has escaped locking
			_status = _t getVariable ["status", []];
			if ("nolock" in _status || !("locked" in _status)) exitWith {};

			_cPos = visiblePosition _mis;
			_tPos = visiblePosition _t;	

			_speed = 85;

			_heading = [_cPos,_tPos] call BIS_fnc_vectorFromXToY;

			_distanceToTarget = ([_cPos select 0, _cPos select 1, 0] distance [_tPos select 0, _tPos select 1, 0]);
			_heightAboveTerrain = (_cPos select 2);

			[(ATLtoASL _cPos), (ATLtoASL _tPos), "MIS"] call markIntersects;
			
			if (_distanceToTarget > 5 && _heightAboveTerrain <= 3) then {					
				_heading set[2, 0];

			} else {

				if (_distanceToTarget < 4) then {

					if ('invulnerable' in _status) exitWith {};
					_d = if ('nanoarmor' in _status) then { 0.025 } else { ((random 0.1) + 0.05) };

					_armor = _t getVariable ['GW_Armor', 1];
					_d = [(_d / (_armor / 8)), 0, _d] call limitToRange;

					_t setDamage ((getDammage _t) + _d);

					[
						_t,
						"updateVehicleDamage",
						_t,
						false
					] call bis_fnc_mp;
				};
			};

			_velocity = [_heading, _speed] call BIS_fnc_vectorMultiply; 	

			_mis setVectorDir _heading; 
			_mis setVelocity _velocity; 

			Sleep 0.01;

		};

	};		

	Sleep _fireSpeed;
};


true
