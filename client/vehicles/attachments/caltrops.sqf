//
//      Name: dropCaltrops
//      Desc: Deploys spikey fencing scattered behind the vehicle that shreds tyres
//      Return: None
//

private ["_obj", "_vehicle"];

_obj = _this select 0;
_vehicle = _this select 1;

if (isNull _vehicle || isNull _obj) exitWith { false };
if (!alive _vehicle) exitWith { false };

_this spawn {

	_obj = _this select 0;
	_vehicle = _this select 1;

	_pos = (ASLtoATL getPosATL _vehicle);
	["DROPPING CALTROPS", 1, warningIcon, nil, "default"] spawn createAlert;   

	_cost = (['CAL'] call getTagData) select 1;

	_ammo = _vehicle getVariable ["ammo", 0];
	_newAmmo = _ammo - _cost;
	if (_newAmmo < 0) then { _newAmmo = 0; };
	_vehicle setVariable["ammo", _newAmmo];

	// Loops through active caltrops to detect nearby vehicles, then cleans up when done
	createCaltropDetector = {
		
		GW_CALTROP_DETECTOR = true;

		_timeout = time + 60;
		for "_i" from 0 to 1 step 0 do {

			if (time > _timeout || isNil "GW_CALTROP_DETECTOR" || (count GW_CALTROP_ARRAY == 0)) exitWith {};


			{
				[(_x select 1), (_x select 2)] spawn popIntersects;	
				if (GW_DEBUG) then { [(_x select 1), (_x select 2), 1] spawn debugLine; };			
			} Foreach GW_CALTROP_ARRAY;
			Sleep 0.05;
		};	

		{
			_o = _x select 0;		
			GW_WARNINGICON_ARRAY = GW_WARNINGICON_ARRAY - [_o];
			GW_DEPLOYLIST = GW_DEPLOYLIST - [_o];
			deleteVehicle _o;		
		} Foreach GW_CALTROP_ARRAY;

		GW_CALTROP_ARRAY = [];
		GW_CALTROP_DETECTOR = nil;
	};

	// Drop a caltrop at the specified location
	dropDebris = {

		_oPos = _this select 0;
		_oDir = _this select 1;

		Sleep 0.5;

		_type = "Land_New_WiredFence_5m_F";
		_oPos = [_oPos, 8, 8, 0] call setVariance;
		_oPos set[2, -2.35];
		_o = createVehicle [_type, _oPos, [], 0, "CAN_COLLIDE"];
		_o setPosATL _oPos;

		playSound3D ["a3\sounds_f\weapons\other\sfx9.wss", GW_CURRENTVEHICLE, false, (ASLtoATL visiblePositionASL GW_CURRENTVEHICLE), 2, 1, 50];

		[		
			[
				_o,
				false
			],
			"setObjectSimulation",
			false,
			false 
		] call BIS_fnc_MP;

		_o setDir _oDir;

		// Quarter of a second before arming
		Sleep 0.25;

		GW_WARNINGICON_ARRAY = GW_WARNINGICON_ARRAY + [_o];
		GW_DEPLOYLIST = GW_DEPLOYLIST + [_o];

		GW_CALTROP_ARRAY pushback [ _o, (ATLtoASL (_o modelToWorld [2.5,0,2])), (ATLtoASL (_o modelToWorld [-2.5,0,2])) ];

		// If there's not a detector active, make a new one
		if (isNil "GW_CALTROP_DETECTOR") then {
			[] spawn createCaltropDetector;
		};

	};

	if (isNil "GW_CALTROP_ARRAY") then {
		GW_CALTROP_ARRAY = [];
	};

	playSound3D ["a3\sounds_f\sfx\vehicle_drag_end.wss", GW_CURRENTVEHICLE, false, (ASLtoATL visiblePositionASL GW_CURRENTVEHICLE), 2, 1, 50];

	// Make our own tyres partially invulnerable for a limited duration
	[_vehicle, ['invTyres'], 3] call addVehicleStatus;

	// Create a maximum of 10 caltrops
	for "_i" from 0 to 10 step 1 do {

		_rnd = random 100;
		_vel = [0,0,0] distance (velocity _vehicle);
		_alt = (ASLtoATL getPosASL _vehicle) select 2;

		if (_rnd > 25 && _alt < 2) then {

			[] spawn cleanDeployList;

			// Ok, let's position it behind the vehicle
			_maxLength = ([_vehicle] call getBoundingBox) select 1;
			_oPos = _vehicle modelToWorldVisual [0, (-1 * ((_maxLength/2) + 2)), 0];
			_oDir = random 360;

			[_oPos, _oDir] spawn dropDebris;
		};

		Sleep 0.25;
	};

};

true

