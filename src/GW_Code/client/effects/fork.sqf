//
//      Name: forkEffect
//      Desc: Handles getting attached to another vehicle
//		Return: None
//

params ['_t', '_s', '_d', '_vP'];
_status = _t getVariable ['status', []];

// Too far away from suggested attach point
if ( (_vP distance (_s worldToModelVisual (_t modelToWorldVisual [0,0,0]))) > 1.2) exitWith {};

_d = if ('nanoarmor' in _status) then { 0.05 } else { _d };
if ('invulnerable' in _status) then {} else {
	_t setDammage ((getdammage _t) + _d);
	_t call updateVehicleDamage;
};

if ('invulnerable' in _status || 'cloak' in _status || 'forked' in _status || 'nofork' in _status) exitWith {};
[_t, ['forked'], 9999] call addVehicleStatus;
_forkTimeout = time + random 10;

_vect = [_t, _s] call getVectorDirAndUpRelative;

// Update simulation for all clients
[		
	[
		_t,
		false
	],
	"setObjectSimulation",
	false,
	false 
] call bis_fnc_mp;

// Wait for simulation off before attaching
_timeout = time + 1;
waitUntil {
	((time > _timeout) || !(simulationEnabled _t))
};

_t attachTo [_s];
_t setVectorDirAndUp _vect;

playSound3D ["a3\sounds_f\sfx\missions\vehicle_drag_end.wss", _t, false, (ASLtoATL visiblePositionASL _t), 2, 1, 50];

_initVel = [0,0,0] distance (velocity _s);

Sleep 1;

// Wait for vehicle velocity to be slow enough
waitUntil{
	Sleep 0.1;
	_relativeVel = (velocityModelSpace _s);
	_currentVel = [0,0,0] distance (velocity _s);
	((time > _forkTimeout) || ( (_relativeVel  select 0) <= 0.1 && (_relativeVel  select 1) <= 0.1 ) || (_currentVel < _initVel))
};

detach _t;

[_t, ['forked']] call removeVehicleStatus;
[_t, ['nofork'], 5] call addVehicleStatus;

_timeout = time + 2;
waitUntil{
	Sleep 0.1;
	((time > _timeout) || (_t distance _s > 3))
};

// Update simulation for all clients
[		
	[
		_t,
		true
	],
	"setObjectSimulation",
	false,
	false 
] call bis_fnc_mp;
