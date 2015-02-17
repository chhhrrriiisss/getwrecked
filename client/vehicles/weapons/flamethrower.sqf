//
//      Name: fireFlamethrower
//      Desc: Fires a burst of fire, gasoline and general unpleasantry
//      Return: None
//

private ["_obj"];

_obj = _this select 0;
_target = _this select 1;
_vehicle = _this select 2;

_repeats = 3;
_projectileSpeed = 60;
_projectileRange = 50;
_lifetime = 7;

_cost = (['FLM'] call getTagData) select 1;
_fuel = (fuel _vehicle + (_vehicle getVariable ["fuel", 0])) - _cost;

if (_fuel <= 0.01) exitWith {		
	["LOW FUEL!", 0.5, warningIcon, colorRed, "warning"] spawn createAlert;  
};

if (_fuel > 1) then {
	_vehicle setFuel 1;
	_vehicle setVariable ["fuel", (_fuel - 1)];
} else {
	_vehicle setFuel _fuel;
	_vehicle setVariable ["fuel", 0];
};

_oPos = _obj modelToWorldVisual [0,-4,0];
_tPos = if (typename _target == 'OBJECT') then { (ASLtoATL getPosASL _target) } else { _target };

_heading = [_oPos,_tPos] call BIS_fnc_vectorFromXToY;
_velocity = [_heading, _projectileSpeed] call BIS_fnc_vectorMultiply; 
// _velocity = (velocity _vehicle) vectorAdd _velocity;

// Fire sound effect
[		
	[
		_vehicle,
		"flamethrower",
		50
	],
	"playSoundAll",
	true,
	false
] call BIS_fnc_MP;	  

_src = createVehicle ["Land_PenBlack_F", _oPos, [], 0, "CAN_COLLIDE"];
[_src, 1.5] spawn flameEffect;

[
	[
		_src,
		_lifetime
	],
	"flameEffect",
	false,
	false
] call BIS_fnc_MP;

_src setVectorDir _heading; 
_src setVelocity _velocity;

_vehiclePos = (ASLtoATL getPosASL _vehicle);
_nearby = _vehiclePos nearEntities [["Car"], 50];

if (count _nearby < 0) exitWith {};



_src addEventHandler['EpeContact', {	
	if ((_this select 1) == (vehicle player)) exitWith {};
	[(_this select 1), 100, 6] spawn setVehicleOnFire;
}];

_src spawn {

	for "_i" from 0 to 1 step 0 do {

		if (!alive _this) exitWith {};

		_nearby = (ASLtoATL visiblePositionASL _this) nearEntities[["Car"], 6];
		{ 
			if (_x distance (ASLtoATL visiblePositionASL _this) < 4 && _x != (vehicle player)) exitWith {
				_null = [_x, 100, 6] spawn setVehicleOnFire;
			};
			false
		} count _nearby > 0;

		Sleep 0.25;

	};

};

[_src, _lifeTime] spawn { 

	Sleep 3.5;

	_o = _this select 0;
	_l = _this select 1;

	_timeout = time + _l;
	waitUntil{
	if ( time > _timeout || (((getPos _o) select 2) < 0.5) ) exitWith { true };
	false
	};

	_o removeEventHandler['EpeContact', 0];
	deleteVehicle _o;

};

true
