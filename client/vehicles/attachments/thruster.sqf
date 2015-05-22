//
//      Name: verticalThruster
//      Desc: Allows vehicles to fly, basically
//      Return: None
//

private ["_vehicle", "_obj"];

_obj = [_this,0, objNull, [objNull]] call filterParam;
_vehicle = [_this,1, objNull, [objNull]] call filterParam;

if (isNull _obj || isNull _vehicle) exitWith { false };

_extraFuel = _vehicle getVariable ["fuel", 0];
_fuel = (fuel _vehicle) + _extraFuel;
_mass = getMass _vehicle;

_cost = (['THR'] call getTagData) select 1;

_s = if (_fuel < _cost) then {

	["LOW FUEL ", 0.3, warningIcon, colorRed, "warning"] spawn createAlert;

	[       
	    [
	        _vehicle,
	        "['nofuel']",
	        3
	    ],
	    "addVehicleStatus",
	    _vehicle,
	    false 
	] call gw_fnc_mp;  

	false

} else {
	
	// Cut chute if we're parachuting
	if (GW_CHUTE_ACTIVE) then { GW_CHUTE_ACTIVE = false };
		
	// Get object position
	_oPos = (visiblePositionASL _obj);
	_vPos = (visiblePositionASL _vehicle);
	_cPos = getCenterOfMass _vehicle;		

	// Actual center of vehicle
	_aPos = [((_vPos select 0) - (_cPos select 0)), ((_vPos select 1) - (_cPos select 1)), ((_vPos select 2) - (_cPos select 2))];

	// If the object is too far from CoM	
	_dist = _oPos distance _aPos;

	// Get angle of attack
	_heading = [_oPos,_aPos] call BIS_fnc_vectorFromXToY; 
	_vehicleVector = vectorUp _vehicle;
	_heading = _heading vectorAdd _vehicleVector;

	// Calculate power based off of weight
	_power = (3.5 - (_mass * 0.0001)) max 0.5;
	_maxPower = _power * 14;
	_thrusterVelocity = [_heading, _power] call BIS_fnc_vectorMultiply; 

	// Get velocity vector
	_velocity = velocity _vehicle;
	_newVelocity = _velocity;
	_newVelocity = _velocity vectorAdd _thrusterVelocity;		


	if ((_newVelocity select 2) > _maxPower) then {
		_newVelocity set[2, _maxPower];
	};

	_limit = 50;
	_totalVelocity = [0,0,0] distance _newVelocity;

	// Check we're not going too fast
	if (_totalVelocity > _limit) exitWith {
		["THRUSTER FAILURE!   ", 0.3, warningIcon, colorRed, "warning"] spawn createAlert;
		false
	};	

	// If we're too high
	_pos = (getPosATL _vehicle);
	_alt = (_pos select 2);		
	if (_alt > 80) exitWith { false };		
		
	// Fuel calculation
	_final = _fuel - _cost;	

	if (_final > 1) then {
		_allocated = _final - 1;
		_vehicle setVariable["fuel", _allocated, true];
		_vehicle setFuel 1;
	} else {
		_vehicle setVariable["fuel", 0, true];
		_vehicle setFuel _final;
	};					

	[
		[
		_obj,
		0.2
		],
		"thrusterEffect"
	] call gw_fnc_mp;

	_vehicle setVelocity _newVelocity;
	
	playSound3D ["a3\sounds_f\weapons\rockets\new_rocket_4.wss", _vehicle, false, _vPos, 1, 1, 50];
	playSound3D ["a3\sounds_f\weapons\rockets\new_rocket_6.wss", _vehicle, false, _vPos, 1, 1, 50];

	true
};

_s 


