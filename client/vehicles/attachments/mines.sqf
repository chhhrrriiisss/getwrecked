//
//      Name: dropMines
//      Desc: Deploys mines that explode when fast vehicles go near them 
//      Return: None
//

private ["_obj", "_vehicle"];

_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_vehicle = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _obj || isNull _vehicle) exitWith {};

_pos = (ASLtoATL getPosASL _vehicle);

["DROPPING MINES! ", 1, warningIcon, nil, "default"] spawn createAlert;   

_cost = (['MIN'] call getTagData) select 1;

_ammo = _vehicle getVariable ["ammo", 0];
_newAmmo = _ammo - _cost;
if (_newAmmo < 0) then { _newAmmo = 0; };
_vehicle setVariable["ammo", _newAmmo];

// Drops a detector that causes the mine to explode 
dropTrigger = {

	_obj = _this select 0;
	_pos = (ASLtoATL getPosASL _obj);
	_pos set[2, 0];

	_timeout = time + 120;
	_triggered = false;

	// Add handlers
	_obj addEventHandler['EpeContact', {	(_this select 0) setVariable ["triggered", true]; }];
	_obj addEventHandler['HandleDamage', {	(_this select 0) setVariable ["triggered", true];  false }];
	_obj addEventHandler['Explosion', {	(_this select 0) setVariable ["triggered", true];   }];
	_obj addEventHandler['Hit', { (_this select 0) setVariable ["triggered", true];  }];

	while {alive _obj && time < _timeout && !_triggered} do {

		// Wait half a second first
		Sleep 0.5;

		_nearby = _pos nearEntities [["car"], 5];
		_triggered = _obj getVariable ["triggered", false];

		if (count _nearby > 0 || _triggered) then {

			{
				_status = _x getVariable ['status', []];
				_isVehicle = _x getVariable ['isVehicle', false];
				_velocity = (velocity _x);
				_vel = [0,0,0] distance _velocity;

				// If its a vehicle and its going fast blow it up
				if (_isVehicle && _vel > 1.5) then {

					[_x] call checkMark;	

					playSound3D ["a3\sounds_f\weapons\mines\electron_trigger_1.wss", _obj, false, getPos _obj, 2, 1, 50]; 

					_tPos =  (ASLtoATL getPosASL _x);
					_tPos set[2, 0.25];
					_x setDammage 0.98;
					_bomb = createVehicle ["Bo_GBU12_LGB", _tPos, [], 0, "CAN_COLLIDE"];					
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

	_oPos = _this select 0;
	_oDir = _this select 1;

	_type = "Land_FoodContainer_01_F";
	_oPos = [_oPos, 5, 5, 0] call setVariance;
	_oPos set[2, -0.4];

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
	] call BIS_fnc_MP;

	playSound3D ["a3\sounds_f\weapons\other\sfx9.wss", (vehicle player), false, getPos (vehicle player), 2, 1, 50];

	GW_WARNINGICON_ARRAY pushback _o;
	GW_DEPLOYLIST pushback _o;

	// Wait half a second before arming
	Sleep 0.5;

	[_o] spawn dropTrigger;


};

playSound3D ["a3\sounds_f\sfx\vehicle_drag_end.wss", (vehicle player), false, getPos (vehicle player), 2, 1, 50];

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

		[_oPos, _oDir] spawn dropMine;

	};

	Sleep 0.3;

};

