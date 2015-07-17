//
//      Name: fireFlamethrower
//      Desc: Fires a burst of fire, gasoline and general unpleasantry
//      Return: None
//

params ['_obj', '_target', '_vehicle'];

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
] call bis_fnc_mp;	  

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
] call bis_fnc_mp;

_src setVectorDir _heading; 
_src setVelocity _velocity;

_vehiclePos = (ASLtoATL getPosASL _vehicle);
_nearby = _vehiclePos nearEntities [["Car", "Tank"], 50];

if (count _nearby < 0) exitWith {};



_src addEventHandler['EpeContactStart', {	

	if ((_this select 1) == (vehicle player)) exitWith {};

	(_this select 0) removeEventHandler ['EpeContactStart', 0];

	[(_this select 1), 100, 6] spawn setVehicleOnFire;

	_status = (_this select 1) getVariable ['status', []];
	if ('nofire' in _status || 'invulnerable' in _status) exitWith {};

	[(_this select 1), 'FLM'] call markAsKilledBy;

	_d = if ('nanoarmor' in _status) then { 0 } else { 0.005 };
	(_this select 1) setDammage ((getDammage (_this select 1)) + _d);	
	
}];

_src spawn {

	waitUntil {

		_nearby = (ASLtoATL visiblePositionASL _this) nearEntities[["Car"], 6];
		{ 
			if (_x distance (ASLtoATL visiblePositionASL _this) < 4 && _x != (vehicle player)) exitWith {
				_null = [_x, 100, 6] spawn setVehicleOnFire;
				[_x, 'FLM'] call markAsKilledBy;
			};
			false
		} count _nearby > 0;

		Sleep 0.2;

		(!alive _this)
	};

};

[_src, _lifeTime] spawn { 

	Sleep 3;
	params ['_o', '_l'];

	_timeout = time + _l;
	waitUntil{
	if ( time > _timeout || (((ASLtoATL visiblePositionASL _o) select 2) < 0.5) ) exitWith { true };
	false
	};

	_o removeEventHandler['EpeContactStart', 0];
	deleteVehicle _o;

};

true
