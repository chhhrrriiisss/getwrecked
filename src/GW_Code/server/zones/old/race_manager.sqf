//
//      Name: raceManager
//      Desc: Handles races
//      Return: None
//


// if (isNil "GW_RACE_STATUS") then {
// 	GW_RACE_STATUS = [];
// };

// GW_RACE_MIN = 2;
// GW_RACE_WAIT_TIMER = 10;
// GW_RACE_TIMEOUT = 600;

// params ['_player', '_zone'];

// _status = 0; // Default, not active

// setRaceStatus = {	
// 	_exists = false;
// 	{
// 		if ((_x select 0) == (_this select 0)) exitWith {
// 			_exists = true;
// 			_x set [1, (_this select 1)];
// 		};
// 		false
// 	} forEach GW_RACE_STATUS;

// 	if (!_exists) then {
// 		GW_RACE_STATUS pushback [_this select 0, _this select 1];
// 	};
// };

// _zoneString = format['%1Zone', _zone];
// _status = 0;
// {
// 	if (_zoneString == (_x select 0)) exitWith {
// 		_status = (_x select 1);
// 	};

// } ForEach GW_RACE_STATUS;

// if (_status == 3) exitWith {
// 	systemchat 'Race active - not joinable!';
// };

// if (_status == 2) exitWith {
// 	systemchat 'Race active - but joinable!';
// };

// if (_status == 1) exitWith {
// 	systemchat 'Waiting for players in that zone!';
// };

// if (_status == 0) exitWith {
	
// 	_str = format['%1 is starting a race on %2%3', name _player, _zone];
// 	systemchat _str;
// 	pubVar_systemChat = _str;
//     publicVariable "pubVar_systemChat";
// 	_timeout = time + 60;

// 	format['%1Zone', _zone] spawn {

// 		[_this, 1] call setRaceStatus;
// 		_timeout = time + GW_RACE_WAIT_TIMER;

// 		waitUntil {
// 			Sleep 1;
// 			hint format['Waiting for players (%1s)', [round (_timeout - time), 0, GW_RACE_WAIT_TIMER] call limitToRange ];
// 			((count ( [_this] call findAllInZone ) >= GW_RACE_MIN) || time > _timeout )
// 		};

// 		if (time > _timeout) exitWith {
// 			hint '';
// 			systemChat 'Race aborted - not enough players!';
// 			[_this, 0] call setRaceStatus;
// 		};

// 		hint '';
// 		[_this, 0] call setRaceStatus;

// 	};

// };