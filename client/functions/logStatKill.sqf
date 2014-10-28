//
//      Name: logStatKill
//      Desc: Executed from server, to log a kill stat to the local client
//      Return: None
//

_prev = player getVariable ["prevVeh", nil];

if (!isNil "_prev") then {

	if (player in _prev) then {
		_wantedValue = _prev getVariable ["GW_WantedValue", 0];
		_wantedValue = _wantedValue + 200;
		_prev setVariable ["GW_WantedValue", _wantedValue];
	};

	['kill', _prev, 1] call logStat;
};