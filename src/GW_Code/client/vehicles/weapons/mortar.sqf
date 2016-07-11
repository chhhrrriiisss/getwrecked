//
//      Name: fireMortar
//      Desc: Fires a mortar round that disables tyres
//		Return: None
//

private ['_gun', '_target', '_vehicle'];

_this spawn {

	params ['_gun', '_target'];

	_repeats = 0;
	_round = "R_TBG32V_F";
	_soundToPlay = "a3\sounds_f\weapons\Mortar\mortar_05.wss";
	_fireSpeed = 1;
	_projectileSpeed = -500;
	_range = 30;


	addCamShake [.5, 1,20];

	if (count GW_LOCKEDTARGETS <= 0) then {

		for "_i" from 0 to _repeats step 1 do {

			// _targetPos = if (typename _target == 'OBJECT') then { (ASLtoATL getPosASL _target) } else { _target };
			_targetPos = screenToWorld [0.5, 0.5];
			_gPos = _gun selectionPosition "otochlaven";
			_gPos = _gun modelToWorld _gPos;
			_gPos set [2, (_gPos select 2) + 3];

			_dir = [_gPos, _targetPos] call dirTo;	
			_tPos = [_gun, _range, _dir] call relPos;
			_tPos set[2, 500];

			_launch = createVehicle [_round, _gPos, [], 0, "FLY"];

			_heading = [_gPos,_tPos] call BIS_fnc_vectorFromXToY;
			_velocity = [_heading, 100] call BIS_fnc_vectorMultiply; 

			_launch setVectorUp [0,0,1];
			_launch setDir _dir;
			_launch setVelocity _velocity;

			playSound3D [_soundToPlay, _gun, false,ATLtoASL _gPos, 1, 1, 50];

			Sleep 1;
			deleteVehicle _launch;

			_targetPos = [_targetPos, 5, 5] call setVariance;

			[_targetPos, _projectileSpeed] call mortarImpact;

			Sleep _fireSpeed;
		};

	} else {	

		_gPos = _gun selectionPosition "otochlaven";
		_gPos = _gun modelToWorld _gPos;
		_gPos set[2, (_gPos select 2) + 3];

		{
			if (!alive _x) then {

				GW_LOCKEDTARGETS = GW_LOCKEDTARGETS - [_x];

			} else { 

				[_x, "MOR"] spawn markAsKilledBy;
				
				_tPos = getPosATL _x;		
				_targetPos = _tPos;	
				_tPos set[2, 500];

				_status = _x getVariable ["status", []];
				if ("nolock" in _status) then {

					_dir = getDir (vehicle player);
					_dir = _dir + ((random 90) - 45);
					_targetPos = [_targetPos, 15, _dir] call relPos;		
					GW_LOCKEDTARGETS = GW_LOCKEDTARGETS - [_x];
				};	

				_launch = createVehicle [_round, _gPos, [], 0, "FLY"];

				_dir = [_gPos, _tPos] call dirTo;	
				_heading = [_gPos,_tPos] call BIS_fnc_vectorFromXToY;
				_velocity = [_heading, 100] call BIS_fnc_vectorMultiply; 

				_launch setVectorUp [0,0,1];
				_launch setDir _dir;
				_launch setVelocity _velocity;
		
				playSound3D [_soundToPlay, _gun, false,_gPos, 1, 1, 50];

				_dist = (_targetPos distance _gPos) / 1000;

				Sleep 0.1;
				deleteVehicle _launch;

				[_targetPos, (_projectileSpeed * 2)] call mortarImpact;

				Sleep _fireSpeed;
			};

		} ForEach GW_LOCKEDTARGETS;

	};

};

true
