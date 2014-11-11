//
//      Name: cloakingDevice
//      Desc: Makes the vehicle invisible and unlockable for a duration
//      Return: None
//

private ['_vehicle', '_status', '_vehVel'];

_vehicle = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _vehicle) exitWith {};

// Are we already stealthed?
_status = _vehicle getVariable ["status", []];
if ('cloak' in _status || 'nocloak' in _status) exitWith {};

// Do we have ammo?
_vehAmmo = _vehicle getVariable ["ammo", 0];

_cost = (['CLK'] call getTagData) select 1;
if (_vehAmmo <= 0 || ((_vehAmmo - _cost) < 0) ) exitWith {
	["NEED AMMO", 1, warningIcon, colorRed, "warning"] spawn createAlert;   
};

// Are we going too fast?
_vehVel = [0,0,0] distance (velocity _vehicle);
if (_vehVel > 8) exitWith {
	["TOO FAST! ", 1, warningIcon, colorRed, "warning"] spawn createAlert;   
};

// Ok, grab what we need
_pos = ASLtoATL getPosASL _vehicle;
_duration = 2;

// Modify effect size by vehicle footprint
_dimensions = [_vehicle] call getBoundingBox;
_size = ( (_dimensions select 0) * (_dimensions select 1) * (_dimensions select 2) ) / 15;

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerStatic cutRsc ["RscStatic", "PLAIN" , 2];
playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_3.wss", _vehicle, false, _pos, 2, 1, 30];	

[       
    [
        _vehicle,
        ['cloak'],
        9999
    ],
    "addVehicleStatus",
    _vehicle,
    false 
] call BIS_fnc_MP;  

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


while {alive _vehicle && _vehAmmo > 0 && (!isEngineOn _vehicle) && !GW_LMBDOWN && fireKeyDown == ''} do {	

	Sleep _duration;	

	// Take ammo each tick
	_vehAmmo = _vehicle getVariable ["ammo", 0];
	_vehAmmo = _vehAmmo - _cost;
	if (_vehAmmo < 0) then { _vehAmmo = 0; };
	_vehicle setVariable ["ammo", _vehAmmo];

	[
		[
			_vehicle,
			2,
			_size
		],
	"cloakEffect"
	] call BIS_fnc_MP;

	_nearby = _pos nearEntities [["car"], 10];
	_found = false;

	if (count _nearby > 1) then {
		{

			if (_x != _vehicle) then {

				_isVehicle = _x getVariable ["isVehicle", false];
				_crew = count (crew _x);

				if (_isVehicle && _crew > 0) then {
					_found = true;
				};

			};

			if (_found) exitWith {};

		} ForEach _nearby;
	};

	_status = _vehicle getVariable ["status", []];
	if ( !('cloak' in _status) || _found ) exitWith {};

};

[       
    [
        _vehicle,
        ['nocloak'],
        5
    ],
    "addVehicleStatus",
    _vehicle,
    false 
] call BIS_fnc_MP;  

_layerStatic cutRsc ["RscStatic", "PLAIN" , 1];

[       
	[
		_vehicle,
		['cloak']
	],
	"removeVehicleStatus",
	_vehicle,
	false 
] call BIS_fnc_MP;  

playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_1.wss", _vehicle, false, _pos, 2, 1, 150];	

[       
    [
        _vehicle,
        false
    ],
    "setVisibleAttached",
    false,
    false 
] call BIS_fnc_MP;  

