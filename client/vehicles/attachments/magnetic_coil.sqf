//
//      Name: magneticCoil
//      Desc: Deploys a burst of magnetism that launches nearby vehicles in wierd directions
//      Return: None
//

private ['_obj', '_vehicle'];

if (isNil { _this select 1}) exitWith { false };
_vehicle = _this select 1;
if (!alive _vehicle) exitWith { false };

Sleep 1;

_pos = ASLtoATL getPosASL _vehicle;

_minPower = 50;
_maxPower = 120;
_power = random (_maxPower - _minPower) + _minPower;

_minRange = 50;
_maxRange = 80;
_range = random (_maxRange - _minRange) + _minRange;

playSound3D ["a3\sounds_f\sfx\alarmCar.wss", _vehicle, false, _pos, 3, 1, 200]; 
playSound3D ["a3\sounds_f\vehicles\armor\APC\APC2\int_engine_start.wss", _vehicle, false, _pos, 3, 1, 250];

Sleep 1 + (random 1);

_status = _vehicle getVariable ["status", []];
if ('emp' in _status || 'cloak' in _status) exitWith { false };

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
		if (_dist < _minRange) then { _dist = _minRange; };
		if (_dist > _maxRange) then {} else {

			// Get the angle we're getting thrown too
			_dir = [_vehicle, _X] call dirTo;
			_dist = if (_dist < (_maxRange / 2)) then { (_dist * 9) } else { (_dist * 3) };
			_relPos = [_vehicle, _dist, _dir] call BIS_fnc_relPos;

			// Closer, more height		
			_relPos set[2, (_dist / 8)];

			// Use vehicle pos to calculate velocity vector
			_vehPos = (ASLtoATL visiblePositionASL _x);
			_heading = [_vehPos,_relPos] call BIS_fnc_vectorFromXToY;	

			if (GW_DEBUG) then {
				SYSTEMCHAT FORMAT['%1 / %2 / %3', _vehPos, _relPos, _heading];
				[(ATLtoASL _vehPos), (ATLtoASL _relPos), 0.5] spawn debugLine;	
			};

			// Calculate power based off of weight
			_mass = getMass _x;	
			_calcPower = 100;
			_calcPower = ((_power / (_mass * 0.001)) max 10) + (_dist / 6);
			[_calcPower, _minPower, _maxPower] call limitToRange;
			_vel = [_heading, _calcPower] call BIS_fnc_vectorMultiply; 
				
			//Apply velocity to vehicles
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

	};

	false
	
} count _nearby > 0;

playSound3D ["a3\sounds_f\vehicles\armor\APC\APC2\int_engine_stop.wss", _vehicle, false, _pos, 2, 1, 150];

true



