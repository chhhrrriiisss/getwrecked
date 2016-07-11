//
//      Name: nitroBoost
//      Desc: Increases the vehicle's speed dramatically, consumes fuel
//      Return: None
//

private ["_vehicle", "_obj"];

_obj = [_this,0, objNull, [objNull]] call filterParam;
_vehicle = [_this,1, objNull, [objNull]] call filterParam;

if (isNull _vehicle || isNull _obj) exitWith { false};

_extraFuel = _vehicle getVariable ["fuel", 0];
_fuel = (fuel _vehicle) + _extraFuel;

_number = ['NTO', _vehicle] call hasType;
_cost = (['NTO'] call getTagData) select 1;
_cost = (_cost * _number);

_status = _vehicle getVariable ["status", []];
if ('tyresPopped' in _status || 'disabled' in _status) exitWith { false };

_s = if (_fuel < _cost) then {
	["LOW FUEL  ", 0.3, warningIcon, colorRed, "warning"] spawn createAlert;

	[       
	    [
	        _vehicle,
	        "['nofuel']",
	        3
	    ],
	    "addVehicleStatus",
	    _vehicle,
	    false 
	] call bis_fnc_mp;  

	false
} else {
		
		_vel = velocity _vehicle;
		_alt = (ASLtoATL (getPosASL _vehicle)) select 2;		
		_limit = 60 + (20 * _number);
		_velX = abs (_vel select 0);
		_velY = abs (_vel select 1);
		_velTotal = _velX + _velY;

		// If we're already going too fast, abort
		if ( (_velTotal > _limit) ) exitWith { false };	
		
		_mass = getMass _vehicle;

		// Calculate power based off of weight
		_power = (15 - (_mass * 0.0002)) max 1;

		_speed = _power; 
		
		// Wheels aren't touching the ground
		if ( _alt > 1 ) exitWith { false };	

		// Is the engine on? hah.
		if (!isEngineOn _vehicle) exitWith { false};

		[
			[
			_vehicle,
			0.75
			],
			"nitroEffect"
		] call bis_fnc_mp;

		_final = _fuel - _cost;	

		if (_final > 1) then {
			_allocated = _final - 1;
			_vehicle setVariable["fuel", _allocated];
			_vehicle setFuel 1;
		} else {
			_vehicle setVariable["fuel", 0.01];
			_vehicle setFuel _final;
		};						
		
		_dir = direction _vehicle;
		_vehicle setVelocity [(_vel select 0)+(sin _dir*_speed),(_vel select 1)+(cos _dir*_speed),(_vel select 2) + 0.1];	

		addCamShake [0.2, .3,20];

		true
};

_s

