//
//      Name: emergencyParachute
//      Desc: Launches player from vehicle with a parachute
//      Return: None
//

private ["_vehicle", "_player", "_newPos"];

_obj = [_this,0, objNull, [objNull]] call filterParam;
_vehicle = [_this,1, objNull, [objNull]] call filterParam;

if (isNull _vehicle) exitWith { false };
if (!local _vehicle) exitWith { false };

if (isNil "GW_CHUTE_ACTIVE") then { GW_CHUTE_ACTIVE = false; };
if (GW_CHUTE_ACTIVE) exitWith { false };

_pos = (ASLtoATL getPosASL _vehicle);
_alt = _pos select 2;
_vel = [0,0,0] distance (velocity _vehicle);

if (_alt < 4) exitWith { ['TOO LOW!', 0.25, warningIcon, colorRed, "flash"] spawn createAlert;  false }; 

[_obj, _vehicle] spawn {

	_class = "Steerable_Parachute_F";
	GW_CHUTE = createVehicle [_class, [0,0,0], [], 0, "FLY"];
	GW_CHUTE setDir getDir (_this select 1);
	GW_CHUTE setPos getPos (_this select 1);

	_vel = velocity (_this select 1);      
	_vector = vectorUp (_this select 1);

	(_this select 1) attachTo [GW_CHUTE, [0,0,0]];

	_speed = 20;
	_dir = direction (_this select 1);
	GW_CHUTE setVectorUp _vector;
	GW_CHUTE setVelocity [(_vel select 0)+(sin _dir*_speed),(_vel select 1)+(cos _dir*_speed),(_vel select 2)];	

	[(_this select 1), GW_CHUTE] spawn {

		_veh = _this select 0;
		GW_CHUTE_ACTIVE = true;
		waitUntil {
			Sleep 0.1;
			((getPos _veh select 2 < 5) || !GW_CHUTE_ACTIVE || !alive (_this select 0))
		};

		_vel = velocity _veh;
		detach _veh;    
        _veh setVelocity _vel;

        missionNamespace setVariable ["#FX", [_veh, _vel select 2]];
        publicVariable "#FX";
        playSound3D [
            "a3\sounds_f\weapons\Flare_Gun\flaregun_1_shoot.wss",
            _veh
        ];
		
		detach (_this select 1);
		(_this select 1) disableCollisionWith _veh;   

		_time = time + 5;
		waitUntil {time > _time};
		if (!isNull (_this select 1)) then {deleteVehicle (_this select 1)};

		GW_CHUTE_ACTIVE = false;

	};
};

true
