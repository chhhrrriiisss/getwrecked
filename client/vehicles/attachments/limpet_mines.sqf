//
//      Name: dropLimpets
//      Desc: Deploys mines that attach to vehicles and cause them to shake/show up on radar
//      Return: None
//

private ["_obj", "_vehicle"];

_obj = _this select 0;
_vehicle = _this select 1;

if (isNull _obj || isNull _vehicle) exitWith { false };
if (!alive _vehicle) exitWith { false };

_this spawn {

	_obj = _this select 0;
	_vehicle = _this select 1;

	_pos = (ASLtoATL getPosASL _vehicle);

	["DROPPING MINES! ", 1, warningIcon, nil, "default"] spawn createAlert;   

	_cost = (['LPT'] call getTagData) select 1;

	_ammo = _vehicle getVariable ["ammo", 0];
	_newAmmo = _ammo - _cost;
	if (_newAmmo < 0) then { _newAmmo = 0; };
	_vehicle setVariable["ammo", _newAmmo];

	// Drops a detector that causes the mine to explode 
	dropLimpetTrigger = {

		_obj = _this select 0;
		_pos = (ASLtoATL getPosASL _obj);
		_pos set[2, 0];

		_timeout = time + 120;
		_triggered = false;	

		for "_i" from 0 to 1 step 0 do {

			if (!alive _obj || time > _timeout || _triggered) exitWith {};

			_hasHandlers = _obj getVariable ['hasHandlers', false];

			if (!_hasHandlers) then {
				
				// Add handlers
				_obj setVariable ['hasHandlers', true];
				_obj addEventHandler['EpeContact', {	(_this select 0) setVariable ["triggered", true]; }];
				_obj addEventHandler['HandleDamage', {	(_this select 0) setVariable ["triggered", true];  false }];
				_obj addEventHandler['Explosion', {	(_this select 0) setVariable ["triggered", true];   }];
				_obj addEventHandler['Hit', { (_this select 0) setVariable ["triggered", true];  }];

			};

			// Wait a quarter of a second between checks
			Sleep 0.25;

			_nearby = _pos nearEntities [["car"], 5];
			_triggered = _obj getVariable ["triggered", false];

			if (count _nearby > 0 || _triggered) then {

				{
					_status = _x getVariable ['status', []];
					_isVehicle = _x getVariable ['isVehicle', false];
					_velocity = (velocity _x);
					_vel = [0,0,0] distance _velocity;

					// If its a vehicle and its going fast blow it up
					if (_isVehicle) then {						

						playSound3D ["a3\sounds_f\weapons\mines\electron_trigger_1.wss", _obj, false, getPos _obj, 2, 1, 50]; 

						[       
							[
								_x,
								"['limpets']",
								9999
							],
							"addVehicleStatus",
							_x,
							false 
						] call gw_fnc_mp;  

						deleteVehicle _obj;

					} else {
						_triggered = false;
					};

					false
					
				} count _nearby > 0;

			};		

		};

		_obj removeAllEventHandlers "Hit";
		_obj removeAllEventHandlers "Explosion";
		_obj removeAllEventHandlers "HandleDamage";
		_obj removeAllEventHandlers "EpeContact";

		GW_WARNINGICON_ARRAY = GW_WARNINGICON_ARRAY - [_obj];
		GW_DEPLOYLIST = GW_DEPLOYLIST - [_obj];

		if (alive _obj) then {
			deleteVehicle _obj;
		};

	};

	// Drops the actual mine at the target location
	dropLimpetMine = {

		_oPos = _this select 0;
		_oDir = _this select 1;

		_type = "Land_Flush_Light_red_F";
		_oPos = [_oPos, 5, 5, 0] call setVariance;

		_o = createVehicle [_type, _oPos, [], 0, "CAN_COLLIDE"];
		_o enableSimulation false;
		_o setPosATL _oPos;

		[		
			[
				_o,
				false
			],
			"setObjectSimulation",
			false,
			false 
		] call gw_fnc_mp;

		playSound3D ["a3\sounds_f\weapons\other\sfx9.wss", GW_CURRENTVEHICLE, false, (ASLtoATL visiblePositionASL GW_CURRENTVEHICLE), 2, 1, 50];

		GW_WARNINGICON_ARRAY pushback _o;
		GW_DEPLOYLIST pushback _o;

		// Wait half a second before arming
		Sleep 0.5;

		[_o] spawn dropLimpetTrigger;


	};

	playSound3D ["a3\sounds_f\sfx\vehicle_drag_end.wss", GW_CURRENTVEHICLE, false,(ASLtoATL visiblePositionASL GW_CURRENTVEHICLE), 2, 1, 50];

	for "_i" from 0 to 3 step 1 do {
		
		_rnd = random 100;
		_vel = [0,0,0] distance (velocity _vehicle);
		_alt = (ASLtoATL getPosASL _vehicle) select 2;

		if (_alt < 2) then {

			[] spawn cleanDeployList;
			
			// Ok, let's position it behind the vehicle
			_maxLength = ([_vehicle] call getBoundingBox) select 1;
			_oPos = _vehicle modelToWorldVisual [0, (-1 * ((_maxLength/2) + 2)), 0];
			_oPos set[2,0];
			_oDir = random 360;

			[_oPos, _oDir] spawn dropLimpetMine;

		};

		Sleep 0.3;

	};

};

true