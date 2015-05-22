//
//      Name: emergencyParachute
//      Desc: Creates a steerable parachute for a vehicle
//      Return: None
//

private ["_vehicle", "_player", "_newPos"];

_obj = [_this,0, objNull, [objNull]] call filterParam;
_vehicle = [_this,1, objNull, [objNull]] call filterParam;

if (isNull _vehicle) exitWith { false };
if (!local _vehicle) exitWith { false };

if (isNil "GW_CHUTE_ACTIVE") then { GW_CHUTE_ACTIVE = false; };
if (GW_CHUTE_ACTIVE) exitWith { false };

_pos = (ASLtoATL visiblePositionASL _vehicle);
_alt = _pos select 2;

if (_alt <= 4) exitWith { ['TOO LOW!', 0.25, warningIcon, colorRed, "flash"] spawn createAlert;  false }; 

[_obj, _vehicle] spawn {
	
	_vehicle = (_this select 1);
	_class = "Steerable_Parachute_F";
	GW_CHUTE = createVehicle [_class, [0,0,0], [], 0, "FLY"];
	GW_CHUTE addEventHandler['handleDamage', { false }];
	GW_CHUTE disableCollisionWith _vehicle;
	GW_CHUTE setPos (ASLtoATL visiblePositionASL (_this select 1));

	GW_WAITCOMPILE = true;

	_vehicle = (_this select 1);
	_vector = vectorUp _vehicle;
	_velocityHeading = [(velocity _vehicle), 5] call BIS_fnc_vectorMultiply; 

	GW_CHUTE setVectorUp _vector;

	_box = [_vehicle] call getBoundingBox;
	_height = _box select 2;


	_vehicle attachTo [GW_CHUTE, [0,0,-(_height / 4)]];
	player action ["engineoff", _vehicle];	

	_currentPos = (ASLtoATL visiblePositionASL _vehicle);
	GW_CHUTE_TARGET = GW_CHUTE modelToWorldVisual [_velocityHeading select 0, _velocityHeading select 1, _velocityHeading select 2];
	GW_CHUTE_TARGET = [GW_CHUTE_TARGET, 5, 5] call setVariance;
	GW_CHUTE_TARGET set [2, 0];

	[(_this select 1), GW_CHUTE] spawn {

		_veh = _this select 0;
		_chute = _this select 1;

		GW_CHUTE_ACTIVE = true;

		_pos = (ASLtoATL visiblePositionASL _veh);
		_heading = [_pos, GW_CHUTE_TARGET] call BIS_fnc_vectorFromXToY; 
		_velocity = [_heading, 10] call BIS_fnc_vectorMultiply; 
		GW_CHUTE setVelocity _velocity;
		_lastTarget = GW_CHUTE_TARGET;

		waitUntil {
			
			// Keep setting velocity to target
			_pos = (ASLtoATL visiblePositionASL _veh);
			_heading = [_pos, GW_CHUTE_TARGET] call BIS_fnc_vectorFromXToY; 
			_velocity = [_heading, 10.5] call BIS_fnc_vectorMultiply; 
			GW_CHUTE setVelocity _velocity;			

			// Adjust angle and heading to target
			_dist = _pos distance GW_CHUTE_TARGET;

			_angle = if (_dist < 100) then { [ ([(100 - _dist) * -0.25, 0, 15] call limitToRange), 0, -15] } else { 
				if (_dist > 100) exitWith { [ ([(_dist - 100) * 0.25, 0, 15] call limitToRange), 0, 0] };
				_heading 
			};

			[GW_CHUTE, _angle] call setPitchBankYaw;
			GW_CHUTE setVectorDir _heading;

			_lastTarget = GW_CHUTE_TARGET;

			// Check for objects directly below the vehicle
			_intersects = lineIntersectsWith [_veh modelToWorldVisual [0,0,0], _veh modelToWorldVisual [0,0,-3], _veh, GW_CHUTE, false];
			if (count _intersects > 0) then { systemchat 'object detected'; };
			if (GW_DEBUG) then { [_pos, GW_CHUTE_TARGET, 0.01] call renderLine; };
			if (GW_DEBUG) then { [_veh modelToWorldVisual [0,0,0], _veh modelToWorldVisual [0,0,-5], 0.01] call renderLine; };

			((_pos select 2 < 4) || !GW_CHUTE_ACTIVE || !alive (_this select 0) || (count _intersects > 0) )
		};

		playSound3D ["a3\sounds_f\weapons\Flare_Gun\flaregun_1_shoot.wss", _veh, false, (ASLtoATL visiblePositionASL _veh), 10, 1, 50]; 
		detach _veh;  		  
        GW_CHUTE_ACTIVE = false;
		GW_WAITCOMPILE = false;

		_chute spawn {
			Sleep (random 5);
			deleteVehicle _this;
		};	
	};
};

true
