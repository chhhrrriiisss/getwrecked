//
//      Name: cloakingDevice
//      Desc: Makes the vehicle invisible and unlockable for a duration
//      Return: None
//

private ['_vehicle', '_status', '_vehVel'];

_vehicle = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _vehicle) exitWith { false };

// Are we already stealthed?
_status = _vehicle getVariable ["status", []];
if ('cloak' in _status || 'nocloak' in _status) exitWith { false };

// Do we have ammo?
_vehAmmo = _vehicle getVariable ["ammo", 0];

_cost = (['CLK'] call getTagData) select 1;
if (_vehAmmo <= 0 || ((_vehAmmo - _cost) < 0) ) exitWith {
	["NEED AMMO", 1, warningIcon, colorRed, "warning"] spawn createAlert;   
	false
};

// Are we going too fast?
_vehVel = [0,0,0] distance (velocity _vehicle);
if (_vehVel > 8) exitWith {
	["TOO FAST! ", 1, warningIcon, colorRed, "warning"] spawn createAlert;   
	false
};

// Ok, grab what we need
_pos = ASLtoATL getPosASL _vehicle;

// Modify effect size by vehicle footprint
_dimensions = [_vehicle] call getBoundingBox;
_size = ( (_dimensions select 0) * (_dimensions select 1) * (_dimensions select 2) ) / 15;

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerStatic cutRsc ["RscStatic", "PLAIN" , 2];

playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_3.wss", _vehicle, false, _pos, 2, 1, 30];	

[_vehicle, ['cloak'], 9999] call addVehicleStatus;

[       
    [
        _vehicle,
        true
    ],
    "setVisibleAttached",
    false,
    false 
] call BIS_fnc_MP;  

player action ["engineoff", _vehicle];

// Wait for simulation to be enabled
_timeout = time + 2;
waitUntil{ 
    if ( (time > _timeout) || !isEngineOn _vehicle ) exitWith { true };
    false
};

[_vehicle, _vehAmmo, _cost, _size, _pos] spawn {

	_v = _this select 0;
	_vA= _this select 1;
	_c = _this select 2;
	_s = _this select 3;
	_p = _this select 4;

	_prevFuel = fuel _v;
	_v setFuel 0;

	for "_i" from 0 to 1 step 0 do {

		if (!alive _v || _vA <= 0 || isEngineOn _v || GW_LMBDOWN || fireKeyDown != '') exitWith {};

		Sleep 2;	

		// Take ammo each tick
		_vA = _v getVariable ["ammo", 0];
		_vA = _vA - _c;
		if (_vA < 0) then { _vA = 0; };
		_v setVariable ["ammo", _vA];

		[
			[
				_v,
				2,
				_s
			],
		"cloakEffect"
		] call BIS_fnc_MP;

		_nearby = _p nearEntities [["car"], 10];
		_found = false;

		if (count _nearby > 1) then {
			{

				if (_x != _v) then {

					_isVehicle = _x getVariable ["isVehicle", false];
					_crew = count (crew _x);

					if (_isVehicle && _crew > 0) then {
						_found = true;
					};

				};

				if (_found) exitWith {};

			} ForEach _nearby;
		};

		_status = _v getVariable ["status", []];
		if ( !('cloak' in _status) || _found ) exitWith {};

	};

	_v setFuel _prevFuel;

	[       
	    [
	        _v,
	        "['nocloak']",
	        4
	    ],
	    "addVehicleStatus",
	    _v,
	    false 
	] call BIS_fnc_MP;  

	_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
	_layerStatic cutRsc ["RscStatic", "PLAIN" , 2];

	[       
		[
			_v,
			"['cloak']"
		],
		"removeVehicleStatus",
		_v,
		false 
	] call BIS_fnc_MP;  

	playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_1.wss", _v, false, _p, 2, 1, 150];	

	[       
	    [
	        _v,
	        false
	    ],
	    "setVisibleAttached",
	    false,
	    false 
	] call BIS_fnc_MP;  

};

true