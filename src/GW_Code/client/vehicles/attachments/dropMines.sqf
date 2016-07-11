//
//      Name: dropMines
//      Desc: Deploys mines that explode when fast vehicles go near them 
//      Return: None
//

params ["_obj", "_vehicle"];

if (isNull _obj || isNull _vehicle) exitWith { false };
if (!alive _vehicle) exitWith { false };

_this spawn {
	
	params ['_obj', '_vehicle'];

	_pos = (ASLtoATL getPosASL _vehicle);

	["DROPPING MINES! ", 1, warningIcon, nil, "default"] spawn createAlert;   

	_cost = (['MIN'] call getTagData) select 1;

	_ammo = _vehicle getVariable ["ammo", 0];
	_newAmmo = _ammo - _cost;
	if (_newAmmo < 0) then { _newAmmo = 0; };
	_vehicle setVariable["ammo", _newAmmo];

	isFirstDrop = true;

	// Drops a detector that causes the mine to explode 
	dropTrigger = {

		params ['_obj'];
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

			_nearby = _pos nearEntities [["Car", "Tank"], 5];
			_triggered = _obj getVariable ["triggered", false];

			if (count _nearby > 0 || _triggered) then {

				{
					_status = _x getVariable ['status', []];
					_isVehicle = _x getVariable ['isVehicle', false];
					_velocity = (velocity _x);
					_vel = [0,0,0] distance _velocity;

					// If its a vehicle and its going fast blow it up
					if (_isVehicle && _vel > 1.5) then {

						if (_x != GW_CURRENTVEHICLE) then { [_x, "MIN"] call checkMark;	};

						playSound3D ["a3\sounds_f\weapons\mines\electron_trigger_1.wss", _obj, false, visiblePositionASL _obj, 5, 1, 50]; 

						_tPos =  (ASLtoATL visiblePositionASL _x);
						_tPos set[2, 0];
						_d = if ('nanoarmor' in _status) then { 0.05 } else { (0.2 + random 0.1) };

						_armor = _x getVariable ['GW_Armor', 1];
						_d = [(_d / (_armor / 8)), 0, _d] call limitToRange;

						_x setDamage ((getDammage _x) + _d);
						
						_bomb = createVehicle ["M_AT", _tPos, [], 0, "CAN_COLLIDE"];		
						_bomb setVelocity [0,0,-100];
						Sleep 0.01;			

						[_tPos, 10, 15] call shockwaveEffect;

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
	dropMine = {

		params ['_oPos', '_oDir'];

		_type = "Land_FoodContainer_01_F";
		_oPos = [_oPos, 5, 5, 0] call setVariance;

		_o = createVehicle [_type, _oPos, [], 0, "CAN_COLLIDE"];
		_host = createVehicle ["Land_PenBlack_F", _oPos, [], 0, "CAN_COLLIDE"];		
		_host setVectorUp (vectorUp (GW_CURRENTVEHICLE));
		_o attachTo [_host, [0,0,0]];
		_o setDir _oDir;
		_o allowDamage false;
		
		// Help limit warningIcon array spam by only showing first warning icon for a group
		if (isFirstDrop) then {
			isFirstDrop = false;
			GW_WARNINGICON_ARRAY pushback _o;			
		};

		GW_DEPLOYLIST pushback _o;

		// After timeout or we're on the ground, delete source 
		_timeout = time + 5;
		waitUntil {
			(((getPos _host) select 2) < 0.5) || (time > _timeout)
		};
		detach _o;			
		deleteVehicle _host;

		_oPos = getPos _o;

		_o setPos [(_oPos select 0), (_oPos select 1), -0.35];	
		_o enableSimulation false;
		_o allowDamage true;

		[		
			[
				_o,
				false
			],
			"setObjectSimulation",
			false,
			false 
		] call bis_fnc_mp;

		playSound3D ["a3\sounds_f\weapons\other\sfx9.wss", GW_CURRENTVEHICLE, false, visiblePositionASL GW_CURRENTVEHICLE, 6, 1, 50];

		// Wait half a second before arming
		Sleep 0.5;

		[_o] spawn dropTrigger;


	};

	playSound3D ["a3\sounds_f\sfx\missions\vehicle_drag_end.wss", GW_CURRENTVEHICLE, false,visiblePositionASL GW_CURRENTVEHICLE, 8, 1, 50];

	for "_i" from 0 to 4 step 1 do {
		
		_rnd = random 100;
		_vel = [0,0,0] distance (velocity _vehicle);
		_alt = (ASLtoATL getPosASL _vehicle) select 2;

	
		[] spawn cleanDeployList;
		
		// Ok, let's position it behind the vehicle
		_maxLength = ([_vehicle] call getBoundingBox) select 1;
		_oPos = _vehicle modelToWorldVisual [0, (-1 * ((_maxLength/2) + 2)), 0];
		_oDir = random 360;

		[_oPos, _oDir] spawn dropMine;

	

		Sleep 0.3;

	};

};

true