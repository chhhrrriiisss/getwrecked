//
//      Name: fireLockOn
//      Desc: Fires a missile that tracks a locked target
//      Return: None
//

private ['_gun', '_target', '_vehicle'];

_gun = _this select 0;
_vehicle = _this select 1;

_repeats = 1;
_round = "M_Titan_AT";
_soundToPlay = "a3\sounds_f\weapons\Launcher\nlaw_final_2.wss";
_fireSpeed = 0.3;
_projectileSpeed = 125;

_gPos = _gun selectionPosition "otochlaven";
_gPos set[1, 4];
_gPos set[2, 2];

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

		_m = _this select 0;
		_v = _this select 1;
		_t = _this select 2;
		_timeout = time + 10;

		while {alive _m && alive _v && alive _t && time < _timeout} do {

			// Abort updating the heading if the target has escaped locking
			_status = _t getVariable ["status", []];
			if ("nolock" in _status || !("locked" in _status)) exitWith {};

			_cPos = visiblePosition _m;
			_tPos = visiblePosition _t;	

			_speed = 60;

			_heading = [_cPos,_tPos] call BIS_fnc_vectorFromXToY;

			_distanceToTarget = ([_cPos select 0, _cPos select 1, 0] distance [_tPos select 0, _tPos select 1, 0]);
			_heightAboveTerrain = (_cPos select 2);

			[(ATLtoASL _cPos), (ATLtoASL _tPos)] call markIntersects;
			
			if (_distanceToTarget > 5 && _heightAboveTerrain <= 3) then {					
				_heading set[2, 0];

			} else {

				if (_distanceToTarget < 2) then {
					_rnd = (random 0.25) + 0.25;
					_t setDammage _rnd;		
				};
			};

			_velocity = [_heading, _speed] call BIS_fnc_vectorMultiply; 	

			_m setVectorDir _heading; 
			_m setVelocity _velocity; 

			Sleep 0.1;

		};

	};		

	Sleep _fireSpeed;
};


true
