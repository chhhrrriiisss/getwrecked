//
//      Name: activateElectromagnet
//      Desc: Deploys an electromagnet that attracts nearby vehicles
//      Return: None
//
private ['_obj', '_vehicle'];

_this spawn {

	if (isNil { _this select 1}) exitWith { false };
	
	_object = _this select 0;
	_vehicle = _this select 1;

	if (!alive _vehicle) exitWith { false };

	_pos = ASLtoATL visiblePositionASL _vehicle;

	playSound3D ["a3\sounds_f\vehicles\armor\APC\APC2\int_engine_start.wss", _vehicle, false, _pos, 3, 1, 250];

	Sleep 0.5 + (random 0.5);

	_status = _vehicle getVariable ["status", []];
	if ('emp' in _status || 'cloak' in _status) exitWith { false };

	playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_2.wss", _vehicle, false, _pos, 5, 1, 50];
	playSound3D [format["a3\sounds_f\sfx\earthquake%1.wss", ceil (random 4)], _vehicle, false, _pos, 10, 1, 150];

	_magnetizeNearby = {

		private ['_object', '_range', '_pos', '_nearby'];

		_range = 50;
		_object = _this;
		_pos = ASLtoATL visiblePositionASL _object;
		_nearby =  _pos nearEntities [["Car"], _range];		
		
		{
			_isVehicle = _x getVariable ['isVehicle', false];

			if (_isVehicle) then {

				_dist = _pos distance (ASLtoATL visiblePositionASL _x);

				if (_dist < _range && _x != GW_CURRENTVEHICLE) then {

					_status = _x getVariable ['status', []];
					if ('magnetized' in _status) exitWith {};

					[
						[
							_x,
							_object					
						],
						"magnetizeEffect",
						_x,
						false
					] call gw_fnc_mp;				

				};

			};

			false 

		} count _nearby > 0;

	};

	[
		[
			_object,
		    5,
		    0.1
		],
		"magnetEffect"
	] call gw_fnc_mp;

	_timeout = time + 5;
	_n = 0;
	waitUntil {
		_n = _n + 1;
		_object call _magnetizeNearby;
		addCamShake[random (_n/3), 1, 10];
		Sleep 1;
		(time > _timeout)
	};

	playSound3D ["a3\sounds_f\vehicles\armor\APC\APC2\int_engine_stop.wss", _vehicle, false, _pos, 2, 1, 150];

};

true



