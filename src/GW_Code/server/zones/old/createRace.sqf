params ['_checkPoints', '_config'];

_minTimeout = 60;
_minPlayers = [_config, 0, 2, [0]] call bis_fnc_param;

//
_onExit = {
	pubVar_systemChat = _this;
	if (isServer) exitWith { systemchat _this; };
	publicVariable "pubVar_systemChat";
};

// Create starting grid and begin checking for minPlayers
_startPosition = [_checkPoints, 0, [], [[]]] call bis_fnc_param;
if (count _startPosition == 0) exitWith { 'Error: Invalid start position.' call _onExit; };

_raceVehicles = [];
_timeout = time + _minTimeout;
waitUntil {
	Sleep 1;	
	_raceVehicles = _startPosition nearEntities [["Car"], 100];
	((time > _timeout) || (count _raceVehicles >= _minPlayers))
};

// Not enough vehicles in zone to start
if (time > _timeout) exitWith { 
	_raceVehicles = _startPosition nearEntities [["Car"], 100];
	{ (Driver _x) setDammage 1; _x setDammage 1; } foreach _raceVehicles;
	'Not enough people to begin race.' call _onExit; 	
};

// Set current race to 'active' to prevent people joining

// Create custom race key and sync to clients
_raceStart = format['%1', ([random 99999, 0] call roundTo) ];
_raceEnd = format['%1', ([random 99999, 0] call roundTo) ];
systemchat format ['raceID = %1', _raceID];
copyToClipboard _raceID;

// Enough vehicles, sync start time with all clients
_startTime = 15;
{
	[[[_raceStart, _raceEnd], {

		_timeout = time + 15;
		waitUntil {
			Sleep 0.5;
			_timeLeft = [(_timeout - time), 2] call roundTo;
			99999 cutText [format['%1', ([_timeLeft, 0, 15] call limitTo) ],"PLAIN",0.5];
			(time > _timeout && (!isNil (_this select 0)) )
		};

		hint 'race started';

		_timeout = time + 60;
		_startTime = time;
		waitUntil {
			Sleep 0.1;
			99999 cutText [format['%1', ([(time - _startTime), 2] call roundTo)], "PLAIN",0.1];
			(time > _timeout) || (!isNil (_this select 1))
		};

		hint 'race ended';

	}], "BIS_fnc_spawn", _x, false, false] call BIS_fnc_MP;

} foreach _raceVehicles;

	



