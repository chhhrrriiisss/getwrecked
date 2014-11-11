//
//      Name: magneticCoil
//      Desc: Deploys a burst of magnetism that launches nearby vehicles in wierd directions
//      Return: None
//

private ['_obj', '_vehicle'];

_vehicle = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _vehicle) exitWith {};

Sleep 1;

_pos = ASLtoATL getPosASL _vehicle;

_minPower = 400;
_maxPower = 500;
_power = random (_maxPower - _minPower) + _minPower;

_minRange = 80;
_maxRange = 90;
_range = random (_maxRange - _minRange) + _minRange;

playSound3D ["a3\sounds_f\sfx\alarmCar.wss", _vehicle, false, _pos, 2, 1, 100]; 
playSound3D ["a3\sounds_f\vehicles\armor\APC\APC2\int_engine_start.wss", _vehicle, false, _pos, 2, 1, 150];

Sleep 1 + (random 1);

if (!alive _vehicle) exitWith {};
_status = _vehicle getVariable ["status", []];
if ('emp' in _status || 'cloak' in _status) exitWith {};

playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_2.wss", _vehicle, false, _pos, 2, 1, 150];
playSound3D ["a3\sounds_f\sfx\earthquake1.wss", _vehicle, false, _pos, 10, 1, 150];

[
	[
	_vehicle,
	3
	],
"magnetEffect"
] call BIS_fnc_MP;

_nearby = _pos nearEntities[["Car"], _range];

{
	_isVehicle = _x getVariable ["isVehicle", false];



	if (_isVehicle && _x != _vehicle) then {

		// How far away are we?
		_dist = _vehicle distance _x;
		_dist = (_range - _dist);
		if (_dist < 25) then { _dist = 25; };

		// Get the angle we're getting thrown too
		_dir = [_vehicle, _x] call BIS_fnc_dirTo;
		_relPos = [_vehicle, _dist, _dir] call BIS_fnc_relPos;

		// Closer, more height		
		_relPos set[2, (_dist / 4)];

		// Use vehicle pos to calculate velocity vector
		_vehPos = getPosATL _x;
		_heading = [_vehPos,_relPos] call BIS_fnc_vectorFromXToY;		

		// Calculate power based off of weight
		_mass = getMass _x;	
		_calcPower = ((_power / (_mass * 0.001)) max 10) + (_dist / 5);
		_vel = [_heading, _calcPower] call BIS_fnc_vectorMultiply; 

		if (GW_DEBUG) then { systemChat format['%1 / %2 / %3', typeof _x, _calcPower, _mass]; };

		if (_x != (_vehicle)) then { [_x] call markAsKilledBy; };
			
		// Apply velocity to vehicles
		if (local _x) then {
			
			_x setVelocity _vel;

		} else {

			[       
				[
					_x,
					_vel
				],
				"setVelocityLocal",
				_x,
				false 
			] call BIS_fnc_MP;  

		};

	};

	false
	
} count _nearby > 0;

playSound3D ["a3\sounds_f\vehicles\armor\APC\APC2\int_engine_stop.wss", _vehicle, false, _pos, 2, 1, 150];







