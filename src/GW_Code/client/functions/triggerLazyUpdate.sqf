
_timeDiff = time - GW_lastUpdate;

if (_timeDiff > GW_minUpdateFrequency || (_this select 1) == "manual") exitWith { 
	GW_lastUpdate = time;		
	[] call playerLoop; 
	true
};

if (_timeDiff < GW_maxUpdateFrequency) exitWith { false };
GW_lastUpdate = time;		

// Global max update frequency
_canTrigger = _this call {

	_triggerType = [_this, 1, "manual", [""]] call filterParam;

	// Manual trigger, just do it
	if (_triggerType == "manual") exitWith { true };

	_data = (_this select 0);

	if (_triggerType == "scroll") exitWith { true };

	// With keys, check for physical movement of player
	if (_triggerType == "key") exitWith {
		_key = _data select 1;

		_movementKeys = [];
		{
			_movementKeys append (actionKeys _x);
			false
		} count [
			"MoveForward",
			"MoveBack",
			"MoveLeft",
			"MoveRight",
			"EvasiveLeft",		
			"EvasiveRight",
			"TurnLeft",
			"TurnRight",
			"EvasiveBack"
		];

		// If we're not pressing a movement key, don't bother
		if !(_key in _movementKeys) exitWith { false };

		// Check we've moved a sufficient physical distance to trigger re-check
		_currentPos = (ASLtoATL visiblePositionASL player);
		if ((_currentPos distance GW_lastPosition) < GW_updateDistance) exitWith { false };
		GW_lastPosition = _currentPos;

		true
	};

	// With aim/mouse trigger, check we're aiming somewhere new
	if (_triggerType == "mouse") exitWith {

		_currentAim = [(_data select 1), (_data select 2), 0];
		_distanceMoved = (_currentAim distance GW_lastAimpoint);
		if ((_currentAim distance GW_lastAimpoint) < GW_updateAimpoint) exitWith { false };
		GW_lastAimpoint = _currentAim;

		true
	};

	true
};

if (!_canTrigger) exitWith {};

[] call playerLoop;