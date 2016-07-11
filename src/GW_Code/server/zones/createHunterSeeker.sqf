params ['_sourceVehicle', '_currentZone'];

diag_log format['%1 spawned a hunter seeker in %2.', (owner _sourceVehicle), _currentZone];

if !(_sourceVehicle isEqualType objNull) exitWith { diag_log "Not a valid parameter for hunter seeker." ; };
if (isNull _sourceVehicle) exitWith { diag_log "Cant spawn hunter seeker as source vehicle is null." ; };
if (!alive _sourceVehicle) exitWith { diag_log "Cant spawn hunter seeker as source vehicle is dead." ; };

// Function for finding a valid target for hunter seeker
findSeekerTarget = {
	
	private ['_ts','_z', '_ex','_targets', '_selected'];
	params ['_z', '_ex'];
	_ts = [_z, { (_this != (vehicle _this)) }, true] call findAllInZone;

	_count = if (isNil "_this select 2") then { 0 } else { _this select 2 };

	// Abort if we've not found a target within 10 attempts
	if (_count > 10) exitWith { objNull };

	// Remove target exclusions
	{
		_ts deleteAt (_ts find _x);
	} foreach _ex;

	// Remove null or !alive targets
	{
		if (isNull _x) then { _ts deleteAt _forEachIndex; };
		if (!alive _x) then { _ts deleteAt _forEachIndex; };
	} foreach _ts;

	// Abort if no targets left
	if (count _ts == 0) exitWith { objNull };

	// Compile list of targets/positions
	_targets = [];
	{
		_p = _x getVariable ['GW_R_PR', 0];
		_targets pushback [_x, _p];
	} foreach _ts;

	// Sort the list by lead positions
	_targets = [_targets,[],{ (_x select 1) },"DESCEND"] call BIS_fnc_sortBy;

	// Resize the list to increase chance of selecting higher positions
	_rndLength = [ceil (random (count _targets - 1)), 1, (count _targets - 1)] call limitToRange;
	_targets resize _rndLength;

	_selected = (selectRandom _targets) select 0;


	// Abort if bad target
	if (isNull _selected || {!alive _selected}) exitWith { 
		_count = _count + 1;
		([_z, _ex, _count] call findSeekerTarget)
	};

	(vehicle _selected)

};

// Find us a target (if not specified by function call)
_target = if (isNil {_this select 2}) then { ([_currentZone, [_sourceVehicle, driver _sourceVehicle]] call findSeekerTarget) } else { (_this select 2) };
if (isNull _target) exitWith { diag_log 'No targets available for hunter seeker.'; };

diag_log format['Target for missile is: %1', _target];

GW_TEST_TARGET = _target;

// Defer launch until it's clear above us
_timeout = time + 5;
waitUntil {
	Sleep 0.5;
	_intersects = lineIntersectsSurfaces [ATLtoASL (_sourceVehicle modelToWorld [0,0,0]), ATLtoASL (_sourceVehicle modelToWorld [0,0,100]), _sourceVehicle, objnull, true, 1];
	((count _intersects == 0) || (time > _timeout))
};

// Calculate launch and initial target properties
_launchPos = _sourceVehicle modelToWorld [0,0,5];
_missilePos = _launchPos;
_targetPos = (ASLtoATL getPosASL _target);
_round = "M_Titan_AT";
_missile = createVehicle [_round, _launchPos, [], 0, "FLY"];	

playSound3D ["a3\sounds_f\weapons\rockets\new_rocket_3.wss", _sourceVehicle, false, getPosASL _sourceVehicle, 5, 1, 100]; 

_dirTo = [_missile, _target] call dirTo;
_speed = 35;
_beepFrequency = 1;
_lastBeep = time - _beepFrequency;
_initDistance = _launchPos distance _targetPos;

_statusFrequency = 15;
_lastStatus = time - _statusFrequency;

// Prep phase
_timeout = time + 1;
for "_i" from 0 to 1 step 0 do {
	_missile setVelocity [0,0,50];
	_missile setVectorUp [0,0,-1];
	if (time > _timeout) exitWith {};
};

// Tracking phase
_timeout = time + 60;
for "_i" from 0 to 1 step 0 do {

	// If target goes bad, find us another
	_noValidTarget = if (isNull _target || {!alive _target}) then {

		_target = [_currentZone, [_sourceVehicle, driver _sourceVehicle, _target]] call findSeekerTarget;
		
		diag_log format['Swapping target: %1', _target];

		if (isNull _target || {!alive _target}) exitWith { true };

		diag_log 'Aborted due to lack of targets';

		_initDistance = _missilePos distance _targetPos;

		false

	} else { false };

	// If the selected target is still bad, abort
	if (_noValidTarget) exitWith {};

	// Missile dead or out of time
	if (!alive _missile || time > _timeout) exitWith {};

	_missilePos = getPosASL _missile;
	_targetPos = getPosASL _target;
	_heightAboveTerrain = _missilePos select 2;
	_distanceToTarget = _missilePos distance _targetPos;	

	// Apply 'HSMLOCK' status every 15 seconds
	if (time - _lastStatus > _statusFrequency) then {
		_lastStatus = time;

		[
			[
	            _target,
	            "['hsmlock']",
	            _statusFrequency
	        ],
	        "addVehicleStatus",
	        _target,
	        false 
		] call bis_fnc_mp;  

	};

	// Send proximity beep to target
	if (time - _lastBeep > _beepFrequency) then {

		_lastBeep = time;
		_beepFrequency = [(_distanceToTarget / _initDistance), 0.15, 1] call limitToRange;

		_missile say3D "beep_light";

		// Send target beep
		[		
			[
				_target,
				"beep_light",
				100
			],
			"playSoundAll",
			_target,
			false
		] call bis_fnc_mp;	 


	};

	// _cam camSetTarget _missile;
	// _cam camSetRelPos [0,-3,1];
	// _cam camPrepareFOV 0.6;
	// _cam camCommit 0;

	if (_distanceToTarget < 5) exitWith {

		// Bombs don't actually do any damage so this is just for effect
		_bomb = createVehicle ["Bo_GBU12_LGB", (ASLtoATL getPosASL _target), [], 0, "FLY"];	

		// Nanoarmor will make this survivable
		_status = _target getVariable ['status', []];
		_d = if ('nano' in _status) then { 0.5 } else { 0.95 };

		_target setDammage ((getdammage _target) + _d);

		[       
			_target,
			"updateVehicleDamage",
			_target,
			false
		] call bis_fnc_mp; 	
	};

	_speed = [_speed + 0.04, 35, 200] call limitToRange;
	_heading = [_missilePos,_targetPos] call BIS_fnc_vectorFromXToY;
	_velocity = [_heading, _speed] call BIS_fnc_vectorMultiply; 	
	_intersects = lineIntersectsSurfaces [ATLtoASL (_missile modelToWorld [0,0,0]), _targetPos, _missile, _target, true, 1];

	// If we detected a collision, avoid it
	if (count _intersects > 0 ) then {
		_distanceToIntersect = ((_intersects select 0) select 0) distance _missilePos;
		if (_distanceToIntersect > 150) exitWith {};
		_increaseToApply = [150 - _distanceToIntersect, 20,150] call limitToRange;
		_velocity set [2, (_velocity select 2) + _increaseToApply];
	};

	_missile setVectorDir (_heading vectorAdd [0,0,1]);
	_missile setVelocity _velocity; 

};

diag_log 'Hunter seeker missile ended.';

// Cleanup
deleteVehicle _missile;

// camdestroy _cam;
// player cameraeffect["terminate","back"];

