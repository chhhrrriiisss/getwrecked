//
//      Name: updateRaces
//      Desc: Function to automatically refresh race menu when GW_ACTIVE_RACES is updated and we're in the menu
//      Return: 
//

if (!GW_RACE_GENERATOR_ACTIVE) exitWith { false };

// current race id
_id = GW_RACE_ID;

// Id of last active race (one that was just added)
if (count GW_ACTIVE_RACES == 0) exitWith { false };
_lastRace = GW_ACTIVE_RACES select (count GW_ACTIVE_RACES) -1;
_lastRaceName = (_lastRace select 0) select 0;

// Find name within existing races
_index = -1;
{
	if (((_x select 0) select 0) == _lastRaceName) exitWith { _index = _forEachIndex; };
} foreach call getAllRaces;

if (_index == -1) exitWith { false };

// disableSerialization;
// _list = ((findDisplay 90000) displayCtrl 90011);	
// _list lbSetCurSel _index;

// If player is currently editing, wait until they save before updating race list ( triggered elsewhere )
if (GW_RACE_EDITING) exitWith { true };

// Index needs to increase by whatever GW_ACTIVE_RACES has changed by to avoid selecting a race that we're not actually looking at/editing

// _filterList = ((findDisplay 90000) displayCtrl 90011);
// _currentLength = lnbSize 90011;

// _newLength = cound (call getAllRaces);

[_id] call generateRaceList;

// systemchat format['GW_ACTIVE_RACES updated! [%1]', time];

true