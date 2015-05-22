//
//      Name: triggerVehicleStatus
//      Desc: Spawns a status sffect dependent on active status
//      Return: None
//

private ['_loop', '_statusEffect', '_commandToLoop', '_targetVehicle', '_vehicleStatus', '_inVehicle'];

_loop = true;
_statusEffect = _this select 0;
_maxTimeout = _this select 1;
_targetVehicle = _this select 2;
_vehicleStatus = _targetVehicle getVariable ['status', []];
_inVehicle = player in _targetVehicle;

if ({ if (_x == _statusEffect) exitWith {1}; false } count ["disabled", "tyresPopped", "emp", "forked", "harpoon"] isEqualTo 1) then {
	['disabled', _targetVehicle, 1] call logStat; 
};

if ({ if (_x == _statusEffect) exitWith {1}; false } count ["overcharge", "extradamage", "nanoarmor", "jammer", "fire", "invulnerable"] isEqualTo 1) then {
	if !(_inVehicle) exitWith {};
	[] call desaturateScreen;
};

if ("teleport" == _statusEffect) then {

	_zoneToSend = GW_VALID_ZONES select (floor (random ((count GW_VALID_ZONES) - 1)));
	_zoneToSend = if ((_zoneToSend select 1) == "safe" || ((random 100) > 50)) then { GW_CURRENTZONE } else { (_zoneToSend select 0) };
	if (GW_DEBUG) then { systemChat format['%1 teleported to %2.', _targetVehicle, _zoneToSend]; };
	[format['%1Zone', _zoneToSend] call findLocationInZone, _targetVehicle] spawn teleportTo;
};

if ("emp" == _statusEffect || "harpoon" == _statusEffect) then {

	_targetVehicle setVelocity ([(random 1), (random 1), (random 1) + 1] vectorAdd (velocity _targetVehicle));
	playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_3.wss", _targetVehicle, false, (ASLtoATL visiblePositionASL _targetVehicle), 10, 1, 100]; 

	if !(_inVehicle) exitWith {};

	_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
	_layerStatic cutRsc ["RscStatic", "PLAIN" ,2];      
	
	"dynamicBlur" ppEffectEnable true; 
	"dynamicBlur" ppEffectAdjust [2]; 
	"dynamicBlur" ppEffectCommit 1; 
	"filmGrain" ppEffectEnable true; 
	"filmGrain" ppEffectAdjust [0.1, 0.5, 2, 0, 0, true];  
	"filmGrain" ppEffectCommit 1;	
};

if ("locked" == _statusEffect) then {
	_condition = { ("locked" in _vehicleStatus) };
	[_this, 9999, 'client\images\lock_halo.paa', _condition, false] spawn createHalo;
	playSound "beep_warning";
};

_commandToLoop = switch (true) do { 

	case ("cloak" == _statusEffect): {{

	
		_p = (ASLtoATL visiblePositionASL _this);
		if ((_p select 2) < 0) then {
			_p set [2, 0.5];
			_this setPos _p;
		};	
	}};

	case ("disabled" == _statusEffect): {{

		_this sethit ["wheel_1_1_steering", 1];
		_this sethit ["wheel_1_2_steering", 1];
		_this sethit ["wheel_2_1_steering", 1];
		_this sethit ["wheel_2_2_steering", 1];

		[_this, 0] spawn slowDown;            

	}};

	case ("limpets" == _statusEffect): {{

		_random = random 100;
		
		if (player in _this) then { addCamShake [0.5, 0.25,30]; };

		if (_random > 70) then {

			_vel = velocity _this;
			_rnd = (random 4);

			_random = random 100;		

			_this setVelocity [_vel select 0, _vel select 1, (_vel select 2) + _rnd];      
			
			if (player in _this) then { addCamShake [3, 0.25,10]; };

			[
				[
					_this,
					0.1,
					[0,0,0,0.2],
					2,
					-1
				],
				"smokeEffect"
			] call gw_fnc_mp;    

		};

	}};

	case ("tyresPopped" == _statusEffect && !("invTyres" in _vehicleStatus) ): {{

		_this sethit ["wheel_1_1_steering", 1];
		_this sethit ["wheel_1_2_steering", 1];
		_this sethit ["wheel_2_1_steering", 1];
		_this sethit ["wheel_2_2_steering", 1];

		[_this, 0.97] spawn slowDown;                 

	}};

	case ("invTyres" == _statusEffect): {{

		_this sethit ["wheel_1_1_steering", 0];
		_this sethit ["wheel_1_2_steering", 0];
		_this sethit ["wheel_2_1_steering", 0];
		_this sethit ["wheel_2_2_steering", 0];        

	}};

	case ("inferno" == _statusEffect && !("nanoarmor" in _vehicleStatus)): {{


		// Put out fire if we drive in water
		if (surfaceIsWater (visiblePositionASL _this)) then {

			[_this, ['fire', 'inferno']] call removeVehicleStatus;

		} else {                                         
			_status = _this getVariable ['status', []];
		    _dmg = getDammage _this;
		    _rnd = (random 7) + 14;
		    _rnd = (_rnd / 10000) * FIRE_DMG_SCALE;
		    _newDmg = _dmg + _rnd;
		    _this setDammage _newDmg;
		    _this call updateVehicleDamage;
		};

		
	}};

	case ("fire" == _statusEffect): {{

		

		// Put out fire if we drive in water
		if (surfaceIsWater (visiblePositionASL _this)) then {

			[_this, ['fire', 'inferno']] call removeVehicleStatus;

		} else {                                         
			_status = _this getVariable ['status', []];
		    _rnd = (random 5) + 10;
		    _rnd = (_rnd / 10000) * FIRE_DMG_SCALE;
		    _rnd = if ("nanoarmor" in _status) then { 0.001 } else { _rnd };
		    _newDmg = (getDammage _this) + _rnd;
		    _this setDammage _newDmg;
		    _this call updateVehicleDamage;
		};

	}};

	case ("emp" == _statusEffect || "harpoon" == _statusEffect): {{
		
		_status = _this getVariable ['status', []];
		if ("nuke" in _status) then {} else {
			[_this, 0.3] spawn slowDown;   
		};

		_special = _this getVariable ['special', []];
		if ('EMF' in _special) then {
			for "_i" from 0 to (['EMF', _this] call hasType) step 1 do {
				if ((random 100) > 98) exitWith { [_this, ['emp']] call removeVehicleStatus; };
			};
		};
	}}; 

	default
	{
		_loop = false;
	};
};

if (!_loop) exitWith {};

[_statusEffect, _commandToLoop, _maxTimeout, _targetVehicle] spawn {

	private ['_timeout', '_inVehicle', '_status', '_special', '_targetVehicle'];
	
	_targetVehicle = (_this select 3);
	_timeout = time + (_this select 2);	

	waitUntil {
		_targetVehicle call (_this select 1);
		_status = (_this select 3) getVariable ['status', []];
		Sleep 0.25;
		(!((_this select 0) in _status) || (time > _timeout) )
	};

};