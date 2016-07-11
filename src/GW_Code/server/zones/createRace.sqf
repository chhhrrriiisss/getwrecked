// Max 3 races active at a time
if ((count GW_ACTIVE_RACES) > 3) exitWith {
	GW_ACTIVE_RACES resize 3;
	publicVariable "GW_ACTIVE_RACES";
};

// Delay race requests by 2 seconds to minimize traffic/too many races ending at the same time
if (isNil "GW_LAST_RACE_REQUEST") then { GW_LAST_RACE_REQUEST = time - 2; };
_dif = (time - GW_LAST_RACE_REQUEST);
if (_dif < 2) exitWith {
	[_this, _dif] spawn {
		Sleep (_this select 1);
		(_this select 0) call createRace;
	};
};
GW_LAST_RACE_REQUEST = time;

params ['_raceRequest','_timeout'];
private ['_raceToInit', '_timeout', '_raceName', '_racePoints', '_raceHost', '_startPosition', '_firstPosition'];

_raceToInit = [_raceRequest, 0, "", [""]] call filterParam;
if (count toArray _raceToInit == 0) exitWith { diag_log 'Error bad race data or no race found'; };

// Compile the string to a workable array
_targetRace = call compile _raceToInit;
if (count _targetRace == 0) exitWith { diag_log 'Error bad race data or no race found'; };

// Get race information
_meta = (_targetRace select 0);
_raceName = _meta select 0;
_raceHost = _meta select 1;
_minPlayers =  [_meta, 3, 2, [0]] call filterParam; // 1 for testing (2 default)
_maxWaitPeriod = [_meta, 4, 60, [0]] call filterParam;

// Check a race with this name isn't already active
if ({	
	if ((((GW_ACTIVE_RACES select 0) select 0) select 0) == _raceName) exitWith { 1 };
	false
} count GW_ACTIVE_RACES > 0) exitWith {
	
	pubVar_systemChat = format['%1 race could not be started — race with name already running.', _raceName];
	diag_log pubVar_systemChat;

	// Attempt to find owner of this race
	_player = [_raceHost] call findUnit;
	if (isNil "_player") exitWith {};

	// Broadcash result
	if (local _player) exitWith { systemchat pubVar_systemChat; };
	(owner _player) publicVariableClient "pubVar_systemChat";
};


_racePoints = _targetRace select 1;
_raceHost = _targetRace select 2;
_startPosition = _racePoints select 0;
_firstPosition = _racePoints select 1;
_raceStatus = [_targetRace, 3, -1, [0]] call filterParam;

// Ensure start position is AGL
// _startPosition SET [2, (getTerrainHeightASL _startPosition)];
// systemchat format['START POSITION: %1', _startPosition];

// Clear up start position of any stray vehicles
_objects = nearestObjects [(ASLtoAGL _startPosition), [], 100];
{	
	_ignore = _x getVariable ['GW_CU_IGNORE', false];	
	if (_ignore) then {} else {
		{		
			deleteVehicle _x; 	
		} foreach (attachedObjects _x);
		deleteVehicle _x;
	};
} foreach _objects;

// Generate 12 unique start positions at first checkpoint
_gridPositions = [];
_invert = -1;
_gap = 2;
_size = 1;
_startDistance = 50;

_dirTo = [_startPosition, _firstPosition] call dirTo;
_dirOpp = [_dirTo + 180] call normalizeAngle;
_initPosition = [([_startPosition, _startDistance, _dirOpp] call relPos), (_gap/2), 90] call relPos;

for "_i" from 0 to 11 step 1 do {

	_invert = _invert * -1;
	_a = [_dirTo + (90 * _invert)] call normalizeAngle;
	_p = [_initPosition, (_gap * _i) + (_size * _i), _a] call relPos;
	_p set [2, 5];
	_gridPositions pushBack _p;

};

// Push array to active races and add start positions
// Then set race status to 'waiting phase' + SYNC
_targetRace set [4, _gridPositions];
(_targetRace select 0) set [5, serverTime + _maxWaitPeriod];
GW_ACTIVE_RACES pushback _targetRace;
[_raceName, 0] call checkRaceStatus;

// Announce race to all players
pubVar_systemChat = format['%1 started a race — use the race menu to join it.',_raceHost];
publicVariable "pubVar_systemChat";
systemchat pubVar_systemChat;

// GW_CURRENTRACE_START = serverTime + _maxWaitPeriod;

// Wait for 60 seconds or players > minPlayers
_timeout = time + _maxWaitPeriod;
_v = [];
waitUntil {

	Sleep 1;

	// Ensure we only count vehicles with drivers
	_v = (ASLtoAGL _startPosition) nearEntities [["Car"], 150];
	{
		_isVehicle = _x getVariable ['isVehicle', false];
		_hasDriver = !isNull (driver _x);
		_hasDriver = true;
		if (!_isVehicle || !_hasDriver || !alive _x) then { _v deleteAt _forEachIndex; };
	} foreach _v;

	_raceStatus = [_raceName] call checkRaceStatus;	

	if ( ((count _v) >= _minPlayers) ) then { 

		// Set race status to 'ready'
		if (_raceStatus == 0) then { [_raceName, 1] call checkRaceStatus; };

		_allReady = true;
		{
			_isReady = _x getVariable ['GW_R_PR', -1];

			// Push start time to local client
			// (owner _x) publicVariableClient "GW_CURRENTRACE_START";
			if (_isReady == -1) exitWith { _allReady = false; };
		} foreach _v;

		// Race status is 'ready' and all players confirm 'ready', start!
		_raceStatus =  [_raceName] call checkRaceStatus;
		if (_allReady && _raceStatus == 1) then {
			[_raceName, 2] call checkRaceStatus;
		};

	} else {

		// Set race status to 'waiting'
		if (_raceStatus == 1) then { [_raceName, 0] call checkRaceStatus; };
	};

	// If the race status is 1 (sufficient players) start if all players confirm 'ready'


	//_left = [([(_timeout - time), 0, _maxWaitPeriod] call limitToRange), 0] call roundTo;

	// Send timer message to each vehicle in zone every few seconds
	// if (_left % 2 == 0) then {		
	// 	_string = if ((count _v) < _minPlayers) then { 'Waiting for players... %1s' } else { 'Reached minimum players — starting in %1s' };
	// 	pubVar_systemChat = format[_string, _left, (count _v)];
	// 	{
	// 		// Message all players in race + let them know who they are playing with
	// 		if (local _x) then { 	
	// 			systemchat pubVar_systemChat; 
	// 		} else {				
	// 			(owner _x) publicVariableClient "pubVar_systemChat";
	// 		};

	// 	} foreach _v;
	// };
	
	_raceStatus = [_raceName] call checkRaceStatus;	
	((time > _timeout) || _raceStatus == 2)
};

// Get race ID again incase the array has updated
_id = (_raceName call getRaceID) select 1;
if (_id == -1) exitWith {

	// Announce race to all players
	pubVar_systemChat = 'Error starting race — race already active or invalid.';
	publicVariable "pubVar_systemChat";
	systemchat pubVar_systemChat;
};

(GW_ACTIVE_RACES select _id) set [5, _v];
(GW_ACTIVE_RACES select _id) set [6, []];
publicVariable "GW_ACTIVE_RACES";

// If race has enough players, auto-start
_raceStatus = [_raceName] call checkRaceStatus;	
if (_raceStatus == 1) then {
	[_raceName,2] call checkRaceStatus;	
};

// Insufficient players or TIMEOUT
if (time > _timeout && _raceStatus == 0) exitWith {
	GW_ACTIVE_RACES deleteAt _id;
	publicVariable "GW_ACTIVE_RACES";

	// Announce race to all players
	pubVar_systemChat = 'A race failed to start — not enough players.';
	publicVariable "pubVar_systemChat";
	systemchat pubVar_systemChat;

};

// Message all players in race + let them know who they are playing with
// {
	
// 	if (local _x) then { 
// 		GW_CR_V = _v;
// 	} else {
// 		GW_CR_V = _v;
// 		(owner _x) publicVariableClient "GW_CR_V";
// 	};
// } foreach _v;
