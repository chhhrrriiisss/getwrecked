//
//      Name: dropCaltrops
//      Desc: Deploys spikey fencing scattered behind the vehicle that shreds tyres
//      Return: None
//

params ["_obj", "_vehicle"];

if (isNull _vehicle || isNull _obj) exitWith { false };
if (!alive _vehicle) exitWith { false };

_this spawn {
	
	params ['_obj', '_vehicle'];

	_pos = (ASLtoATL getPosATL _vehicle);
	["DROPPING CALTROPS", 1, warningIcon, nil, "default"] spawn createAlert;   

	_cost = (['CAL'] call getTagData) select 1;

	_ammo = _vehicle getVariable ["ammo", 0];
	_newAmmo = _ammo - _cost;
	if (_newAmmo < 0) then { _newAmmo = 0; };
	_vehicle setVariable["ammo", _newAmmo];

	isFirstDrop = true;

	// Drop a caltrop at the specified location
	dropDebris = {

		params ['_oPos', '_oDir'];
		
		_o = createVehicle ["Land_Razorwire_F", _oPos, [], 0, "CAN_COLLIDE"];
		_host = createVehicle ["Land_PenBlack_F", _oPos, [], 0, "CAN_COLLIDE"];		
		_host setVectorUp (vectorUp (GW_CURRENTVEHICLE));
		_o attachTo [_host, [0,0,-1.3]];
		_o setDir _oDir;

		GW_DEPLOYLIST pushBack _o;

		if (isFirstDrop) then {
			isFirstDrop = false;
			GW_WARNINGICON_ARRAY pushback _o;
		};		

		playSound3D ["a3\sounds_f\weapons\other\sfx9.wss", GW_CURRENTVEHICLE, false, visiblePositionASL GW_CURRENTVEHICLE, 2, 1, 50];

		_o allowDamage false;

		_o addEventHandler ['EpeContactStart', {
		
			_o1 = (_this select 0);
			_o2 = (_this select 1);	

			_isVehicle = _o2 getVariable ["isVehicle", false];
			if (!_isVehicle) exitWith {};

			[
				[_o2],
				'shredTyres',
				_o2,
				false
			] call bis_fnc_mp;	

			GW_DEPLOYLIST = GW_DEPLOYLIST - [(_this select 0)];
			GW_WARNINGICON_ARRAY = GW_WARNINGICON_ARRAY - [(_this select 0)];

		}];		

		_o addEventHandler ['Killed', { 		

			{
				_isVehicle = _x getVariable ["isVehicle", false];
				if (_isVehicle) then {

					systemchat 'Killed triggered';

					[
						[_x],
						'shredTyres',
						_x,
						false
					] call bis_fnc_mp;	
				};

				false
			} count ((ASLtoATL visiblePositionASL (_this select 0)) nearEntities [["Car"], 3]);

			GW_DEPLOYLIST = GW_DEPLOYLIST - [(_this select 0)];
			GW_WARNINGICON_ARRAY = GW_WARNINGICON_ARRAY - [(_this select 0)];

		}];			
		
		// After timeout or we're on the ground, delete source 
		_timeout = time + 5;
		waitUntil {
			(((getPos _host) select 2) < 0.5) || (time > _timeout)
		};
		detach _o;			
		deleteVehicle _host;

		_oPos = getPos _o;
		_o setPos [(_oPos select 0), (_oPos select 1), -1.3];
		_o setDir _oDir;
			
		_o allowDamage true;
	};

	playSound3D ["a3\sounds_f\sfx\missions\vehicle_drag_end.wss", GW_CURRENTVEHICLE, false, visiblePositionASL GW_CURRENTVEHICLE, 2, 1, 50];

	// Make our own tyres partially invulnerable for a limited duration
	[_vehicle, ['invTyres'], 3] call addVehicleStatus;

	// Create a maximum of 10 caltrops
	for "_i" from 0 to 10 step 1 do {

		_rnd = random 100;
		_vel = [0,0,0] distance (velocity _vehicle);
		_alt = (ASLtoATL getPosASL _vehicle) select 2;

		if (_rnd > 25) then {

			[] spawn cleanDeployList;

			// Ok, let's position it behind the vehicle
			_maxLength = ([_vehicle] call getBoundingBox) select 1;
			_oPos = _vehicle modelToWorldVisual [0, (-1 * ((_maxLength/2) + 2)), 0];
			_oDir = random 360;

			[_oPos, _oDir] spawn dropDebris;
		};

		Sleep (random 0.1 + (0.15));
	};

};

true

