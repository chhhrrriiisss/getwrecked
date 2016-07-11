//
//      Name: deployRace
//      Desc: Prepares vehicle for deployment, checks for empty areas and fail conditions
//      Return: None
//

params ['_vehicleToDeploy', '_unit', '_targetRace'];
private ['_pad', '_unit', '_location', '_vehicleToDeploy'];

if (GW_DEPLOY_ACTIVE) exitWith { systemChat 'Cant deploy more than one vehicle at once.'; false };
GW_DEPLOY_ACTIVE = true;

_abortAction = {	
	systemchat _this;
	GW_DEPLOY_ACTIVE = false; 
	false
};

// Set as last loaded vehicle
_targetName = _vehicleToDeploy getVariable ['name', ''];
GW_LASTLOAD = _targetName;

_success = [_vehicleToDeploy, _unit] call preVehicleDeploy;
if (!_success) exitWith {
	GW_DEPLOY_ACTIVE = false; 
	false 
};

_targetRace = [_this, 2, [], [[]]] call filterParam;
if (count _targetRace == 0) exitWith { 'Bad race data, deploy aborted. Use !reset races if this persists.' call _abortAction; };

// Determine the start checkpoint
_racePoints = _targetRace select 1;
_raceName = (_targetRace select 0) select 0;
_raceHost = _targetRace select 2;
_startPosition = _racePoints select 0;
_firstPosition = _racePoints select 1;
_raceStatus = [_targetRace, 3, -1, [0]] call filterParam;
_raceID = (_raceName call getRaceID) select 1;

// If race entry is invalid or no races exist, abort
if (count GW_ACTIVE_RACES == 0) exitWith { 'No active races! Deploy aborted. ' call _abortAction; };
if (isNil { (GW_ACTIVE_RACES select _raceID) }) exitWith { 'Bad race id, aborted! Use !reset races if this persists.' call _abortAction; };

// Get direction to first checkpoint
_dirTo = [_startPosition, _firstPosition] call dirTo;

// Add a listener, so setDir is updated once we have a new position
_currentPos = getPos _vehicleToDeploy;
[_vehicleToDeploy, _startPosition] spawn {
	
	_v = _this select 0;
	_p = getPos _v;
	_timeout = time + 5;
	waitUntil {
		_d = (getPos _v) distance _p;
		((time > _timeout) || (_d > 1))
	};

	if (_p distance (getpos _v) <= 3) exitWith {
		systemChat 'No valid deploy location available.';
		GW_DEPLOY_ACTIVE = false;
		_v call destroyInstantly;
	};

	_d = [(getPos _v), (_this select 1)] call dirTo;
	_v setDir _d;

	(driver _v) setVariable ['GW_prevPos', (getPos _v)];

};

// Get server to place us at an empty grid position
[
	[format["[((GW_ACTIVE_RACES select %1) select 4),['Car', 'Man'], 8]", _raceID],_vehicleToDeploy, false],
	'setPosEmpty',	
	false,
	false
] call bis_fnc_mp;	

// Clean up all deployables owned by this player (particularily bad for races due to clogging up checkpoints)
{
	deleteVehicle _x;
} foreach GW_DEPLOYLIST;

// Set ZoneImmune and broadcast (for checkInZone checks)
_vehicleToDeploy setVariable ['GW_ZoneImmune', true, true];
[_vehicleToDeploy] call initVehicleDeploy;
['globalZone'] call setCurrentZone;

// Everything is ok, return true
GW_DEPLOY_ACTIVE = false;

// Record a successful deployment
['deploy', GW_SPAWN_VEHICLE, 1] call logStat; 

// Set our ready state to not-ready by default
GW_CURRENTVEHICLE setVariable ['GW_R_PR', -1, true];

// Initialize race lobby dialog
[(GW_ACTIVE_RACES select _raceID)] spawn raceLobby;

TRUE
