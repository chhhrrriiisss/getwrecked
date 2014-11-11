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
_projectileSpeed = 40;
_projectileRange = 50;
_lifetime = 7;

_cost = (['FLM'] call getTagData) select 1;
_cost = 0.02;
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

_oPos = _obj modelToWorldVisual [0,-3,0];
_tPos = if (typename _target == 'OBJECT') then { (ASLtoATL getPosASL _target) } else { _target };

_heading = [_oPos,_tPos] call BIS_fnc_vectorFromXToY;
_velocity = [_heading, _projectileSpeed] call BIS_fnc_vectorMultiply; 
_velocity = (velocity _vehicle) vectorAdd _velocity;

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
_nearby  = [GW_CURRENTZONE] call findAllInZone;

if (count _nearby < 0) exitWith {};

_src addEventHandler['EpeContact', {
	
	_target = _this select 1;
	_isVehicle = _target getVariable ["isVehicle", false];
	_status = _target getVariable ["status", []];

	if ( !('fire' in _status) && _isVehicle ) then {

		_rnd = random 6 + 6;

		if (_target != (vehicle player) ) then { [_target] call markAsKilledBy;  };

		[       
            [
                _target,
                ['fire'],
                _rnd
            ],
            "addVehicleStatus",
            _target,
            false 
		] call BIS_fnc_MP;  

		[
			[
				_target,
				_rnd
			],
			"burnEffect"
		] call BIS_fnc_MP;

	};

}];

Sleep 2;

_timeout = time + _lifetime;
waitUntil{
	if ( time > _timeout || (((getPos _src) select 2) < 0.5) ) exitWith { true };
	false
};

_src removeEventHandler['EpeContact', 0];
deleteVehicle _src;

