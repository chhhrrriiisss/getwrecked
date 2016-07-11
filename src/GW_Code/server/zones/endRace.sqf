//
//      Name: endRace
//      Desc: Handles race end scenario, determining vehicles left and ending race once all killed
//      Return: None
//

params ['_raceName', '_vehicle'];
private ['_raceName', '_id', '_vehicle'];

_raceStatus = [_raceName] call checkRaceStatus;
if (_raceStatus == -1) exitWith {};

_raceData = _raceName call getRaceID;

if (isNil "_raceData") exitWith {};
if (count _raceData == 0) exitWith {};
_raceID = (_raceData select 1);

_raceStartTime = ((_raceData select 0) select 0) select 5;
_finalTime = serverTime - _raceStartTime;

// Find ID in active array and delete;
_activeArray = ((GW_ACTIVE_RACES select _raceID) select 5);
_activeID = _activeArray find _vehicle;
_activeArray deleteAt _activeID;

// Add vehicle to finished array
_finishedArray = ((GW_ACTIVE_RACES select _raceID) select 6);
_finishedArray pushBack _vehicle;

// Determine position based off of index in finish array
_finalPosition = (_finishedArray find _vehicle) + 1;

// Publish position/time to client
GW_CR_F = [_finalTime, _finalPosition];
if (!local _vehicle) then {
	(owner _vehicle) publicVariableClient "GW_CR_F";
};

[_raceName, _vehicle] call removeFromRace;

// // Are we the last player? Delete the race from the active races
// if (count _activeArray == 0 || ({ if (alive _x) exitWith { 1 }; false } count _activeArray) <= 0) then {

// 	// Delete the race from the active races
// 	GW_ACTIVE_RACES deleteAt _raceID;
// 	publicVariable "GW_ACTIVE_RACES";
// };

// Race already ended, abort doing anything else
if (_raceStatus == 3) exitWith {};

// Set race to ended
[_raceName, 3] call checkRaceStatus;



true