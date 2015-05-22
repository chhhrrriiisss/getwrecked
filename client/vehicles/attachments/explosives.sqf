//
//      Name: dropExplosives
//      Desc: Drops a bag of explosives that can be remotely detonated
//      Return: None
//

private ["_obj", "_vehicle", "_o"];

if (isNull ( _this select 0) || isNull (_this select 1)) exitWith { false };

[] spawn cleanDeployList;

_obj = _this select 0;
_vehicle = _this select 1;

playSound3D ["a3\sounds_f\sfx\vehicle_drag_end.wss",_vehicle, false, getPosATL _vehicle, 2, 1, 50];

_type = typeOf _obj;
deleteVehicle _obj;

// Ok, let's position it behind the vehicle
_maxLength = ([_vehicle] call getBoundingBox) select 1;
_pos = _vehicle modelToWorldVisual [0, (-1 * ((_maxLength/2) + 2)), 0];

// Spawn it
_obj = nil;
_obj = createVehicle [_type, _pos, [], 0, 'CAN_COLLIDE']; // So it doesnt collide when spawned in]
_holder = createVehicle ["Land_PenBlack_F", _pos, [], 0, 'CAN_COLLIDE']; // So it doesnt collide when spawned in]

_obj attachTo [_holder, [0,0,0.1]];

[_obj, _holder, _vehicle] spawn { 
	_o = _this select 0;

	_timeout = time + 10;
	waitUntil {
		Sleep 0.1;
		((((getPos (_o)) select 2) < 1) || time > _timeout)
	};

	detach _o;
	deleteVehicle (_this select 1);
	_p = (ASLtoATL visiblePositionASL _o);
	_p set [2, 0];
	_o setPos _p;

	// Recompile the vehicle to account for dropping one bag
	[_this select 2] call compileAttached;

	// Refresh hud bars
	GW_HUD_REFRESH = true;

};

_releaseTime = time;
_timer = 120;
_timeout = time + _timer;

// Handlers to trigger effect early
_obj addEventHandler['HandleDamage', {	(_this select 0) setVariable ["triggered", true]; }];
_obj addEventHandler['killed', {	(_this select 0) setVariable ["triggered", true]; }];
_obj addEventHandler['Explosion', {	(_this select 0) setVariable ["triggered", true]; }];
_obj addEventHandler['Hit', { (_this select 0) setVariable ["triggered", true]; }];

// Add to targets array
_existingTargets = _vehicle getVariable ["GW_detonateTargets", []];
_newTargets = _existingTargets + [_obj];
_vehicle setVariable ["GW_detonateTargets", _newTargets];

GW_WARNINGICON_ARRAY = GW_WARNINGICON_ARRAY + [_obj];
GW_DEPLOYLIST = GW_DEPLOYLIST + [_obj];



[_obj, _timeout, _vehicle] spawn {
	
	_o = _this select 0;
	_t = _this select 1;
	_v = _this select 2;

	_triggered = false;

	for "_i" from 0 to 1 step 0 do {

		if (!alive _o || time > _t || _triggered) exitWith {};

		_triggered = _o getVariable ["triggered", false];
		playSound3D ["a3\sounds_f\sfx\beep_target.wss", _o, false, getPos _o, 2, 1, 25]; 
		Sleep 0.5;
	};

	// If the object is still alive, let's go boom
	if (alive _o) then {

		_pos = (ASLtoATL visiblePositionASL _o);

		playSound3D ["a3\sounds_f\weapons\mines\electron_trigger_1.wss", _o, false, _pos, 2, 1, 150]; 
		
		_pos set [2,2];

		_o enableSimulation false;
		[		
			[
				[_o],
				false
			],
			"setObjectSimulation",
			false,
			false 
		] call gw_fnc_mp;

		_bomb = createVehicle ["Bo_GBU12_LGB", _pos, [], 0, "FLY"];		
		_bomb setVelocity [0,0,-10];
		[_pos, 40, 15] call shockwaveEffect;		

		_nearby = _pos nearEntities [["Car"], 30];	

		if (count _nearby > 0) then {
			{
				_status = _x getVariable ['status', []];

				if ('invulnerable' in _status) then {} else {

					if (_x != (_v)) then { [_x, "EPL"] call markAsKilledBy; };

					_modifier = [1 - (30 / ( _x distance _pos)), 0.5, 1] call limitToRange;					
					_d = if ('nanoarmor' in _status) then { 0.05 } else { (random (0.1) + 0.5) };
					_d = _d * _modifier;

					if (_d > 0) then {

						_x setDammage ((getdammage _x) + _d);

						[       
							_x,
							"updateVehicleDamage",
							_x,
							false
						] call gw_fnc_mp; 

					};

				};
				
				false
				
			} count _nearby > 0;
		};

		Sleep 0.5;
		
		deleteVehicle _o;	
		[_pos, [0,0,0], 30] call impactEffect;	

	};

	// Cleanup
	_o removeAllEventHandlers "Hit";
	_o removeAllEventHandlers "Explosion";
	_o removeAllEventHandlers "HandleDamage";

	_detonateTargets = _v getVariable ["GW_detonateTargets", []];
	_newTargets = _detonateTargets - [_o];
	_v setVariable ["GW_detonateTargets", _newTargets];

	

	GW_WARNINGICON_ARRAY = GW_WARNINGICON_ARRAY - [_o];
	GW_DEPLOYLIST = GW_DEPLOYLIST - [_o];



};



true