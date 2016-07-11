//
//      Name: raceCheckpoints
//      Desc: Checkpoints system for races
//      Return: 
//

private ['_points', '_targetRace', '_startPosition', '_raceStatus', '_raceName'];

_points = [];

_targetRace = [_this, 0, [], [[], ""]] call bis_fnc_param;
_targetRace = if ((typename _targetRace) == "STRING") then { ((_targetRace call getRaceID) select 0) } else { _targetRace };
if (count _targetRace == 0) exitWith { hint 'Could not start - invalid race'; };

_points = [_targetRace, 1, _points, [[]]] call bis_fnc_param;

if (count _points == 0) exitWith { hint 'Could not start - bad point data'; };

// Get race information
_raceName = (_targetRace select 0) select 0;
_startPosition = _points select 0;
_firstPosition = _points select 1;
_raceStatus = [_targetRace, 3, -1, [0]] call filterParam;
_totalCheckpoints = count _points;
_maxTime = [_this, 1, 15, [0]] call bis_fnc_param;
_timeout = time + _maxTime;
_startTime = time;
_totalDistance = [_points, false] call calculateTotalDistance;

// Reset any previously existing race properties
GW_CHECKPOINTS = _points;
GW_CHECKPOINTS_COMPLETED = [];
GW_CHECKPOINTS_PROGRESS = 0;
GW_CHECKPOINTS_COMPLETED = [];

// Create checkpoint halo as a guide
[GW_CURRENTVEHICLE, 9999, 'client\images\checkpoint_halo.paa',{ 

	_rT = _this select 0;
	_rB = _this select 1;

	if (count GW_CHECKPOINTS == 0 || GW_CHECKPOINTS_PROGRESS == count GW_CHECKPOINTS) exitWith { false };
	_cP = GW_CHECKPOINTS select GW_CHECKPOINTS_PROGRESS;

	_dirDif = ([GW_CURRENTVEHICLE, _cP] call dirTo) - (getDir GW_CURRENTVEHICLE);
	_dirTo = [_dirDif] call normalizeAngle;
	_dirToRB = [_dirTo + 180] call normalizeAngle;

	[_rT, [-90,0,_dirTo]] call setPitchBankYaw;
	[_rB, [90,0,_dirToRB]] call setPitchBankYaw;

	((alive GW_CURRENTVEHICLE) || (count GW_CHECKPOINTS > 0))

}, false, [0,2,0.5], true] spawn createHalo;

// Temporary invulnerability until first checkpoint
[GW_CURRENTVEHICLE, ["noshoot", "nouse", "noammo", "nofuel"], 9999] call addVehicleStatus;

// Checkpoint trigger configuration
_distTolerance = 15;

// Create initial checkpoint group
_checkpointGroup = [GW_CHECKPOINTS_PROGRESS, GW_CHECKPOINTS] call createCheckpoint;

for "_i" from 0 to 1 step 0 do {

	if ((GW_CHECKPOINTS_PROGRESS == count GW_CHECKPOINTS) || count GW_CHECKPOINTS == 0 || time > _timeout || !alive GW_CURRENTVEHICLE || !alive player) exitWith {};

	// Calculate how far through the race we are	
	_checkpointsCompleted = +GW_CHECKPOINTS;
	_checkpointsCompleted resize GW_CHECKPOINTS_PROGRESS;
	_distanceTravelled = [_checkpointsCompleted, FALSE] call calculateTotalDistance;
	
	// Check if we're actually past the checkpoint we're tracking (to calculate accurate distance data)
	_isPast = true;
	_distanceToLastCheckpoint = if (GW_CHECKPOINTS_PROGRESS > 0) then { 

		_currentCheckpoint = GW_CHECKPOINTS select GW_CHECKPOINTS_PROGRESS;
		_lastCheckpoint = _checkpointsCompleted select (count _checkpointsCompleted - 1);

		// Check we're on the correct side of the checkpoint by comparing vehicle dir to checkpoint dir
		_dirTo = [_lastCheckpoint, _currentCheckpoint] call dirTo;
		_dirV = [_lastCheckpoint, GW_CURRENTVEHICLE] call dirTo;
		_dirDif = [_dirTo - _dirV] call flattenAngle;

		if (abs _dirDif > 90) exitWith { _isPast = false; 0 };		

		// Return a distance that's no greater than the total distance between current + last cp
		([(GW_CURRENTPOS distance _lastCheckpoint), 0, (_lastCheckpoint distance _currentCheckpoint)] call limitToRange)

	} else { 0 };

	// Total progress based off of distance travelled / total race distance
	_distanceTravelled = _distanceTravelled + _distanceToLastCheckpoint;	
	GW_CURRENTRACE_PROGRESS = 1 - ((_totalDistance - _distanceTravelled) / _totalDistance);
	
	// Publically update progress once every second
	if (round (time) % 1 == 0) then { GW_CURRENTVEHICLE setVariable ['GW_R_PR', GW_CURRENTRACE_PROGRESS, true]; };

	_distanceToCheckpoint = GW_CURRENTPOS distance (ASLtoATL (GW_CHECKPOINTS select GW_CHECKPOINTS_PROGRESS));
	if (_distanceToCheckpoint < _distTolerance) then {			

		// Remove shooting/use restrictions after first WP
		if (GW_CHECKPOINTS_PROGRESS == 0) then {
			[GW_CURRENTVEHICLE, ["noshoot", "nouse", "noammo", "nofuel"]] call removeVehicleStatus;
		};

		// If even number, give ammo, if odd give fuel
		if (GW_CHECKPOINTS_PROGRESS % 2 == 0) then {

			// Give 10% ammo
			_maxAmmo = GW_CURRENTVEHICLE getVariable ["maxAmmo", 1];
			_targetAmmo = [_maxAmmo * 0.1, 1] call roundTo;
			_newAmmo = [(GW_CURRENTVEHICLE getVariable ["ammo", 0]) + _targetAmmo, 0, _maxAmmo] call limitToRange;
			GW_CURRENTVEHICLE setVariable ["ammo", _newAmmo];

			["", 1, plusAmmoIcon, [0,0,0,0.5], "slideUp", "upgrade"] spawn createNotification;

		} else {

			// Give 10% fuel per checkpoint
			_maxFuel = GW_CURRENTVEHICLE getVariable ["maxFuel", 1];
			_totalFuel = _maxFuel + fuel GW_CURRENTVEHICLE;
			_targetFuel = [_totalFuel * 0.1, 1] call roundTo;
			if (_targetFuel < 0.99) then {	
				_newFuel = [fuel GW_CURRENTVEHICLE + _targetFuel, 0, 1] call limitToRange;
				GW_CURRENTVEHICLE setFuel _newFuel;
			} else { 
				GW_CURRENTVEHICLE setFuel 1;
				__newFuel = [(GW_CURRENTVEHICLE getVariable ["fuel", 0]) + (_targetFuel - 1), 0, _maxFuel] call limitToRange;
				GW_CURRENTVEHICLE setVariable ["fuel", _newFuel];
			};	

			["", 1, plusFuelIcon, [0,0,0,0.5], "slideUp", "upgrade"] spawn createNotification;

		};

		// Calculate current timestamp for icon time fade once we pass it
		_timeStamp = (serverTime - GW_CURRENTRACE_START) call formatTimeStamp;
		_timeStamp = format['+%1', _timeStamp];
		GW_CURRENTVEHICLE say "blipCheckpoint";		
		
		// Update our race progress
		GW_CHECKPOINTS_COMPLETED pushback [(GW_CHECKPOINTS select GW_CHECKPOINTS_PROGRESS), _timeStamp, 1];
		GW_CHECKPOINTS_PROGRESS = GW_CHECKPOINTS_PROGRESS + 1;

		// If we're on the last checkpoint, don't bother deleting just yet
		if (GW_CHECKPOINTS_PROGRESS == count GW_CHECKPOINTS) exitWith {};

		// Delete previous checkpoint group 
		{ 
			deleteVehicle _x;
		} foreach _checkpointGroup;

		// Create new checkpoint if not last point
		_checkPointGroup = [GW_CHECKPOINTS_PROGRESS, GW_CHECKPOINTS] call createCheckpoint;

	};

	// Once time gets low enough, start warning with bleeps
	_timeLeft = [_maxTime - (time - _startTime), 0, 99999] call limitToRange;
	if (_timeLeft <= (_maxTime * 0.3) ) then {
		_timeLeft = (_timeout - time) call formatTimeStamp;
		hint format['-%1', _timeLeft];
		GW_CURRENTVEHICLE say "beepTarget";
	};

	Sleep 0.25;

};

// Only go to victory cutscene if we've actually completed the race
if ( time <= (_timeout + 0.1) && alive GW_CURRENTVEHICLE && alive (driver GW_CURRENTVEHICLE)  && GW_CHECKPOINTS_PROGRESS == count GW_CHECKPOINTS) then {

	GW_CURRENTVEHICLE say "electronTrigger";
	GW_CURRENTVEHICLE say "summon";

	[
		[_raceName, GW_CURRENTRACE_VEHICLE],
		'endRace',
		false,
		false
	] call bis_fnc_mp;	
		
	GW_CHECKPOINTS = [];
	GW_CHECKPOINTS_COMPLETED = [];	

	// Slow vehicle down
	[] spawn { 
		_timeout = time + 3;
		waitUntil { [GW_CURRENTVEHICLE, 0.97] spawn slowDown;  time > _timeout };
	};

	GW_HUD_ACTIVE = false;
	GW_HUD_LOCK = TRUE;

	// Spawn camera transition
	_handle = [] spawn orbitCamera;

	// Wait 3 seconds for server to tell us our time/position
	GW_CR_F = nil;
	_timeout = time + 3;
	waitUntil {
		!isNil "GW_CR_F" || time > _timeout
	};

	// If server hasn't responded, use local time
	if (isNil "GW_CR_F") then { 
		_timeStamp = (serverTime - GW_CURRENTRACE_START) call formatTimeStamp;
		GW_CR_F = [_timeStamp, 0]; 
	};

	_raceTime = (GW_CR_F select 0);	
	_racePosition = (GW_CR_F select 1);	

	// If we came first, log as race win
	if (_racePosition == 1) then { ['racewin', GW_CURRENTVEHICLE, 1, true] call logStat; };

	// Show title if we have a time or DNC
	waitUntil { (isNull (findDisplay 95000)) };	

	_exitFunction =	{  	
		9999 cutText ["", "BLACK", 0.01]; 
		GW_IGNORE_DEATH_CAMERA = true; 
		closeDialog 0;	
		true
	};

	// String formatter for race position
	_racePosition = if (_racePosition == 0) then { 'RACE COMPLETE' } else {
		_desc = _racePosition call {
			if (_this == 1) exitWith {'ST'};
			if (_this == 2) exitWith {'ND'};
			if (_this == 3) exitWith {'RD'};
			'TH'
		};
		format['YOU FINISHED %1%2', _racePosition, _desc]
	};

	// Show new title with time/position
	[ format["<t size='3.3' color='#ffffff' align='center' valign='middle' shadow='0'>%1</t><br /><t size='3.3' color='#ffffff' align='center' valign='middle' shadow='0'>+%2</t>", _racePosition, _raceTime call formatTimestamp], "RESPAWN", [false, { true }] , { true }, 9999, true, _exitFunction] call createTitle;
	
	Sleep 0.5; 

	terminate _handle;

	GW_CURRENTVEHICLE call destroyInstantly;

	GW_CURRENTRACE = "";

};

// Delete previous checkpoint group 
{ 
	deleteVehicle _x;
} foreach _checkpointGroup;


