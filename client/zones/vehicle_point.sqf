//
//      Name: servicePoint
//      Desc: Handles adding ammo, health or fuel to a vehicle when over a pad
//      Return: None
//

params ['_vehicle', '_type'];
_driver = (driver _vehicle);

if (isNil "GW_LASTSERVICE_CHECK") then {
	GW_LASTSERVICE_CHECK = time;
};

if (time - GW_LASTSERVICE_CHECK < 0.5) exitWith { true };
GW_LASTSERVICE_CHECK = time;

_inUse = _vehicle getVariable ['inUse', false];
_currentDmg = getDammage _vehicle;
_lowVelocity = if ((velocity _vehicle) distance [0,0,0] < 10) then { true } else { false };

if (_type == "REPAIR" && _currentDmg > 0 && _lowVelocity) exitWith {

	if (!_inUse) then {
		_vehicle setVariable ['inUse', true];
		["REPAIRING...      ", 1, healthIcon, nil, "flash"] spawn createAlert;
	};

	[		
		[
			_vehicle,
			"rep",
			30
		],
		"playSoundAll",
		true,
		false
	] call bis_fnc_mp;	

	_vehicle setDamage ((getDammage _vehicle) - 0.05);

	true
	
};

_maxFuel = (_vehicle getVariable ["maxFuel",1]);		
_currentFuel = (fuel _vehicle) + (_vehicle getVariable ["fuel",0]);

if (_type == "REFUEL" && _currentFuel < _maxFuel && _lowVelocity ) exitWith {

	if (!_inUse) then {
		_vehicle setVariable ['inUse', true];
		["REFUELLING...      ", 1, fuelIcon, nil, "flash"] spawn createAlert;
	};

	[		
		[
			_vehicle,
			"rep",
			30
		],
		"playSoundAll",
		true,
		false
	] call bis_fnc_mp;	

	_increment = (_maxFuel * 0.05);

	if ((fuel _vehicle) < 0.99) then {
		_vehicle setFuel ((fuel _vehicle) + _increment);
	} else {
		_vehicle setFuel 1;
		_vehicle setVariable ["fuel", (_vehicle getVariable ["fuel", 0]) + _increment];
	};	

	true	
};

_maxAmmo= (_vehicle getVariable ["maxAmmo",1]);		
_currentAmmo = (_vehicle getVariable ["ammo",0]);

if (_type == "REARM" && _currentAmmo < _maxAmmo && _lowVelocity ) exitWith {	

	if (!_inUse) then {
		_vehicle setVariable ['inUse', true];
		["REARMING...      ", 1, ammoIcon, nil, "flash"] spawn createAlert;
	};

	[		
		[
			_vehicle,
			"upgrade",
			20
		],
	"playSoundAll",
	true,
	false
	] call bis_fnc_mp;	 

	_increment = _maxAmmo * 0.1;

	_vehicle setVariable["ammo", (_currentAmmo + _increment)];

	true
	
};

// If it was just activated, block for a bit to prevent abuse
if (_inUse) then {
	_lastService = _vehicle getVariable ['GW_NEARBY_SERVICE', 'SERVICE'];
	_lastServiceString = _lastService call { 
		if (_this == "REFUEL") exitWith { 'REFUELLED!' };
		if (_this == "REARM") exitWith { 'REARMED!' };
		if (_this == "REPAIR") exitWith { 'REPAIRED!' };
		'COMPLETE!'
	};	

	[_lastServiceString, 1, successIcon, nil, "slideDown"] spawn createAlert;
	[_vehicle, ['noservice'], 3] call addVehicleStatus;
};

_vehicle setVariable ['inUse', false];
_vehicle setVariable ['GW_NEARBY_SERVICE', nil];

true