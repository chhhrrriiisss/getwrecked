//
//      Name: selfDestruct
//      Desc: Does what it says on the tin (but also automatically triggers the eject system)
//      Return: None
//

_this spawn {

	private ["_vehicle"];
	params ['_nil', '_vehicle'];
	if (isNull _vehicle) exitWith { false };
	if (!local _vehicle || !alive _vehicle) exitWith { false };

	_timeout = 2;
	_modules = _vehicle getVariable ["tactical", []];
	if (count _modules == 0) exitWith { false };

	// Is there an eject system on this vehicle?
	_eject = false;
	_hasType = ['PAR', _vehicle] call hasType;
	if (_hasType > 0) then {
		[_vehicle, player] call ejectSystem;
	   	systemChat "Emergency eject activated.";
	   	_eject = true;
	};

	_isAi = _vehicle getVariable ['isAI', false];
	if (!_isAi) then {
		for "_i" from _timeout to 0 step -1 do {
			['SELF DESTRUCT', 1.5, warningIcon, colorRed, 'slideDown'] spawn createAlert;
			Sleep 0.3;
		};
	};

	_pos = (ASLtoATL getPosASL _vehicle);

	// Prevent invulnerability from stopping it
	_vehicle setVariable ["status", [], true];
	_nearby = _pos nearEntities [["Car", "Tank"], 30];

	{
		if (_x != _vehicle) then { 
			_status = _x getVariable ["status", []];

			if ("invulnerable" in _status) exitWith {};

			_tPos =  (ASLtoATL getPosASL _x);
			_tPos set[2, 0.5];
			_bomb = createVehicle ["Bo_GBU12_LGB", _tPos, [], 0, "CAN_COLLIDE"];

			if ("nanoarmor" in _status) exitWith { 
				_x setDammage ((getdammage _x) + 0.25);
				_x call updateVehicleDamage; 
			};

			_x call destroyInstantly;			

		};

		false
		
	} count _nearby > 0;

	Sleep 0.01;

	// Just in case
	_bomb = createVehicle ["Bo_GBU12_LGB", (ASltoATL getPosASL _vehicle), [], 0, "CAN_COLLIDE"];
	_vehicle call destroyInstantly;

};

true