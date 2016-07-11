if (!GW_RACE_GENERATOR_ACTIVE) exitWith {};

// current state
_editing = GW_RACE_EDITING;

// current race id
_id = GW_RACE_ID;

// Id of last active race
_lastRace = GW_ACTIVE_RACES select (count GW_ACTIVE_RACES) -1;
_lastRaceName = (_lastRace select 0) select 0;

// Find name within existing races
_index = -1;
{
	if (((_x select 0) select 0) == _lastRaceName) exitWith { _index = _forEachIndex; };
} foreach call getAllRaces;

if (_index == -1) exitWith {
	systemchat 'Active race not found in races array.';
};

// disableSerialization;
// _list = ((findDisplay 90000) displayCtrl 90011);	
// _list lbSetCurSel _index;

// If player is currently editing, wait until they save before updating race list
if (GW_RACE_EDITING) exitWith {};

[_id] call generateRaceList;

systemchat format['GW_ACTIVE_RACES updated! [%1]', time];
