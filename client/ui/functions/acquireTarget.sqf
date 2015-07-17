//
//      Name: acquireTarget
//      Desc: Begins a timer to track target vehicle and locks on success
//      Return: None
//

private ['_vehicle', '_target', '_acquireTime', '_data', '_status'];

// Dont acquire more than one target at once
if (GW_ACQUIRE_ACTIVE) exitWith {};
GW_ACQUIRE_ACTIVE = true;

params ['_target'];

// Calculate how long we'll need to lock the target
_acquireTime = time; 

// Adjust time to distance (further away = longer)
_distanceModifier = (_target distance (vehicle player)) / 500; 

// Targets with a larger signature are easier to lock
GW_CURRENTVEHICLE = (vehicle player);
_status = GW_CURRENTVEHICLE getVariable ["status", []];
_signature = if ('radar' in _status) then { "Large" } else { ( _target getVariable ['GW_Signature', 'Low']) };
_adjustedLockTime = switch (_signature) do { case "Large": { (GW_MINLOCKTIME / 3) }; case "Medium": { (GW_MINLOCKTIME * 0.6) }; case "Low": { (GW_MINLOCKTIME * 1) }; case "Tiny": { (GW_MINLOCKTIME * 2) }; default { GW_MINLOCKTIME }; };

_lockTime = time + _adjustedLockTime + (_distanceModifier);
_origLockTime = _lockTime;

_targetted = false;
_direction = 0;
_scale = 2;

_isCloaked = if ('cloak' in _status) then { true } else { false };	

// While its in locking range and alive
for "_i" from 0 to 1 step 0 do {

	
	if (_isCloaked || !GW_HASLOCKONS || !(_target in GW_VALIDTARGETS) || !alive _target || _targetted || _target == GW_CURRENTVEHICLE ) exitWith {};

	// No lock status kills lock
	_status = _target getVariable ["status", []];
	if ("nolock" in _status || ("cloak" in _status) || ("locked" in _status)) exitWith { if (GW_DEBUG) then { systemchat 'failed - no lock or cloak'; }; };

	// If it doesnt have a locking status, send one
	if ( !("locking" in _status) ) then {

		[       
			[
				_target,
				"['locking']",
				3 
			],
			"addVehicleStatus",
			_target,
			false 
		] call bis_fnc_mp;  
	};

	_pos =  _target modelToWorldVisual [0,0,0];

	// Combined velocity of both vehicles influences lock time
	_velTarget = [0,0,0] distance (velocity _target);
	_velSource = [0,0,0] distance (velocity (vehicle player));
	_vel = _velTarget + _velSource;	
	
	// Velocity increases lock time
	_lockTime = _lockTime + (_vel/1000);	

	// Distance increases lock time (and also aborts)
	_dist = _target distance (vehicle player);

	// If the target goes in or out of the min and max lock ranges
	if ( (_dist > GW_MAXLOCKRANGE) || (_dist < GW_MINLOCKRANGE) ) exitWith { if (GW_DEBUG) then { systemchat 'failed - out of range'; }; };

	// If we've succesfully reached the lock time
	_dif = _lockTime - time;
	if (_dif <= 0) exitWith { _targetted = true; };

	// Move the lock icon about a bit
	_variance = 0.08;
	_rndX = ( (random _variance) - (_variance/2) ) * _dif;
	_rndY = ( (random _variance) - (_variance/2) ) * _dif;
	_rndZ = ( (random _variance) - (_variance/2) ) * _dif;

	_pos set[0, (_pos select 0) + _rndX];
	_pos set[1, (_pos select 1) + _rndY];

	// Rotate the icon
	_direction = _direction - 3;
	_scale = ((_dif * 3) max 2) min 3;
	_string = format['%1s', round (_dif * (10 ^ 2)) / (10 ^ 2) ];

	// Draw the icon and make a beeping sound for thrills
	drawIcon3D [lockingIcon,colorRed,_pos,_scale,_scale,_direction, _string, 0, 0.04, "PuristaMedium"];
	player say3D "beep_light";

	Sleep 0.2;

};

if ('locking' in _status) then {

	[       
		[
			_target,
			"['locking']"
		],
		"removeVehicleStatus",
		_target,
		false 
	] call bis_fnc_mp;  
	
};

// If the lock was successful, add it to the locked targets list
if (_targetted) then {		
	GW_LOCKEDTARGETS = (GW_LOCKEDTARGETS - [_target]) + [_target];
};

GW_ACQUIRE_ACTIVE = false;

