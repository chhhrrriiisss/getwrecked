//
//      Name: targetLockOn
//      Desc: Checks for vehicles in los and scope and starts locking onto them
//      Return: None
//

if (isNil "GW_LASTLOCK_CHECK") then {
	GW_LASTLOCK_CHECK = time;
};

if (time - GW_LASTLOCK_CHECK <= 0.1) exitWith { true };
GW_LASTLOCK_CHECK = time;

private ['_pos', '_icon', '_limit', '_vehDir'];

_nearbyTargets = _this;
if (count _nearbyTargets == 0) exitWith {};

// Some required conditions
_vehicle = GW_CURRENTVEHICLE;
_pos = (ASLtoATL visiblePositionASL _vehicle);
_isCloaked = if ('cloak' in (_vehicle getVariable ["status", []]) ) then { true } else { false };

// Make sure we have these variables established
if (isNil "GW_VALIDTARGETS") then { GW_VALIDTARGETS = []; };
if (isNil "GW_LOCKEDTARGETS") then { GW_LOCKEDTARGETS = []; };
if (isNil "GW_ACQUIRE_ACTIVE") then { GW_ACQUIRE_ACTIVE = false; };
if (isNil "GW_TARGET_DIRECTION") then {	GW_TARGET_DIRECTION = 0; };

// Checks for valid targets within range
{	
	_isVehicle = _x getVariable ["isVehicle", false];
	_crew = crew _x;

	if (_x == _vehicle) then {} else {

		_fail = true;

		// Check that its a valid vehicle
		if (_isVehicle && (count _crew >= 0) && alive _x) then {	
							
			_vPos = getPosASL _vehicle;
			_tPos =  getPosASL _x;
			_dist = _vPos distance _tPos;

			// Is it within lock range and are we looking at it?
			_inRange = if (_dist <= GW_MAXLOCKRANGE && _dist >= GW_MINLOCKRANGE) then { true } else { false };
			_inScope = [GW_TARGET_DIRECTION, _x, GW_LOCKON_TOLERANCE] call checkScope;

			_vPos set [2, (_vPos select 2) + 2];					
			_tPos set [2, (_tPos select 2) + 2];
			_hasLos = if (count (lineIntersectsWith [_vPos, _tPos, _vehicle, _x]) == 0) then { true } else { false };

			['Lock on R/S/L', format['%1/%2/%3', _inRange, _inScope, _hasLos]] call logDebug;

			// When its in range, but not in list and alive
			if (_inScope && _inRange && _hasLos) then {						
				GW_VALIDTARGETS = (GW_VALIDTARGETS - [_x]) + [_x];
				_fail = false;
			};		

		};

		// If conditions werent met, cleanup
		if (_fail) then {


			if (!isNil "GW_ACQUIREDTARGET") then {
				if (_x == GW_ACQUIREDTARGET) then {
					GW_ACQUIREDTARGET = nil;

					// Cleanup any status we might have added
					[       
						[
							_x,
							"['locking']"
						],
						"removeVehicleStatus",
						_x,
						false 
					] call BIS_fnc_MP;  
				};
			};

			if (_x in GW_VALIDTARGETS) then {				
				GW_VALIDTARGETS = GW_VALIDTARGETS - [_x];	
			};

			if (_x in GW_LOCKEDTARGETS) then {			
				GW_LOCKEDTARGETS = GW_LOCKEDTARGETS - [_x];

				[   
					[
						_x,
						"['locked', 'locking']"
					],
					"removeVehicleStatus",
					_x,
					false 
				] call BIS_fnc_MP;  		

				playSound3D ["a3\sounds_f\sfx\Beep_Target.wss", (vehicle player), false, (visiblePosition  (vehicle player)), 2, 1, 20];  
			};
		};
	};
	false
} count _nearbyTargets > 0;

_dist = 9999;
_closest = GW_CURRENTVEHICLE;

// Find the closest target from those that are valid
{
	// Bad entry? Reset
	if (isNil "_x") exitWith { GW_VALIDTARGETS = []; };

	_d = _x distance (vehicle player);
	if (_d < _dist && _x != GW_CURRENTVEHICLE && !(_x in GW_LOCKEDTARGETS)) then {
		_closest = _x;

	};


} ForEach GW_VALIDTARGETS;


// Start locking closest target if we havent already
if (!GW_ACQUIRE_ACTIVE && !(_closest in GW_LOCKEDTARGETS) && !_isCloaked) then {

	_status = _closest getVariable ["status", []];

	// If we're not already locked and there's no CM
	if ( !("locked" in _status) && !("nolock" in _status) && !("cloak" in _status)) then {
		[_closest] spawn acquireTarget;


	};
	
};

// For all locked targets, show a marker
if (count GW_LOCKEDTARGETS > 0) then {

	_lockedTarget = GW_LOCKEDTARGETS select 0;
	_inScope = [GW_TARGET_DIRECTION, _lockedTarget, GW_LOCKON_TOLERANCE] call checkScope;

	// If the target is still alive and within view scope
	if (alive _lockedTarget && _inScope) then {

		_pos =  visiblePosition _lockedTarget;
		drawIcon3D [lockedIcon,colorRed,_pos,2.5,2.5,2, 'LOCKED', 0, 0.035, "PuristaMedium"];	
		_status = _lockedTarget getVariable ["status", []];

		// If we're not already locked and there's no CM
		if ( !("locked" in _status) && !("nolock" in _status) && !("cloak" in _status) ) then {

			[       
                [
                    _lockedTarget,
                    "['locked']",
                    15
                ],
                "addVehicleStatus",
                _lockedTarget,
                false 
        	] call BIS_fnc_MP;  
		};

	} else {		

		// Remove from the lock list if the target has been lost
		[       
            [
                _lockedTarget,
                "['locked']"
            ],
            "removeVehicleStatus",
            _lockedTarget,
            false 
    	] call BIS_fnc_MP;  

    	GW_LOCKEDTARGETS = GW_LOCKEDTARGETS - [_lockedTarget];
    	GW_VALIDTARGETS = GW_VALIDTARGETS - [_lockedTarget];

	};
};

true