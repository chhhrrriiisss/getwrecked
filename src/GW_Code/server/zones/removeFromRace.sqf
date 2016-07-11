//
//      Name: removeFromRace
//      Desc: Handles deaths during race, ending race when all players are killed
//      Return: None
//

params ['_raceName', '_vehicle'];
private ['_raceName', '_id', '_vehicle'];

_raceStatus = [_raceName] call checkRaceStatus;

if (_raceStatus == -1) exitWith {};

_raceData = _raceName call getRaceID;
_raceID = (_raceData select 1);

_activeArray = [(GW_ACTIVE_RACES select _raceID), 5, [], [[]]] call filterParam;
_finishedArray = [(GW_ACTIVE_RACES select _raceID), 6, [], [[]]] call filterParam;
_activeArray deleteAt (_activeArray find _vehicle);


pubVar_systemChat = "";

// If everybody died
_endRace = if (count _activeArray == 0 && count _finishedArray == 0) then {		
	pubVar_systemChat = format['%1 race ended — all participants were killed.', _raceName];
	true
} else {
		
	// If everybody active died, but there's finalists
	if (count _activeArray == 0 && count _finishedArray > 0) exitWith {
		pubVar_systemChat = format['%1 race ended — only a special few survived.', _raceName];
		true
	};

	false

};

if (_endRace) then {
	[_raceName, 3] call checkRaceStatus;
	GW_ACTIVE_RACES deleteAt _raceID;
};

publicVariable "GW_ACTIVE_RACES";

// If no message to display
if (count toArray pubVar_systemChat == 0) exitWith { false };

systemchat pubVar_systemChat;
publicVariable "pubVar_systemChat";

true