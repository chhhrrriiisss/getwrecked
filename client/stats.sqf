//
//      Name: logStat
//      Desc: Handles updating and saving vehicle stats to profile name space
//      Return: None
//

private ['_name'];

if (isNil "GW_ISLOGGING") then {
	GW_ISLOGGING = false;
};

if (GW_ISLOGGING) exitWith {};
GW_ISLOGGING = true;

_statToLog = [_this,0, "", [""]] call BIS_fnc_param;
_vehicle = [_this,1, objNull, [objNull]] call BIS_fnc_param;
_value = [_this,2, 0, [0]] call BIS_fnc_param;
_forceSync = [_this,3, false, [false]] call BIS_fnc_param;

if (_statToLog == "" || isNull _vehicle) exitWith {};

_var = switch (_statToLog) do {	
	case "death":{"deaths"};
	case "destroyed":{"destroyed"};
	case "kill": {"kills"};
	case "mileage":	{"mileage"};
	case "moneyEarned":	{"moneyEarned"};
	case "timeAlive":{ "timeAlive"};
	case "deploy": {"deploys"};
};

_previousValue = _vehicle getVariable[_var, 0];
_previousValue = if (typename _previousValue != "SCALAR") then { 0 } else { _previousValue };
_totalValue = _previousValue + _value;
_vehicle setVariable [_var, round(_totalValue)]; 

// If its 9 seconds since last sync, sync data to profile
_remainder = round (time) % 9;

if (isNil "GW_LASTSYNC") then { 
	GW_LASTSYNC = (time - 10); 
};

_currentTime = time;

// Every 10 seconds, sync the data
if ((_currentTime - GW_LASTSYNC) >= 10 || _forceSync) then {

	GW_LASTSYNC = time;


	_newStats = [];
    {
    	_data = _vehicle getVariable [GW_STATS_ORDER select (_foreachindex), nil];
    	if (isNil "_data") then {
    		_newStats set [count _newStats, nil];
    	} else {
    		_newStats set [count _newStats, _data];
    	};          
    } Foreach GW_STATS_ORDER;

	_name = _vehicle getVariable ["name", nil];

	// If we've actually got a name to work with
	if (isNil "_name") then {} else {		

		_raw = profileNameSpace getVariable[_name, nil]; 

		if (isNil "_raw") then {} else {

			_data = [_raw,0, [], [[]]] call BIS_fnc_param;
			_meta = [_data,6, [], [[]]] call BIS_fnc_param;
			_meta set[4, _newStats];
			_data set[6, _meta];
			_raw set[0, _data];
			
			profileNameSpace setVariable[_name, _raw]; 
			saveProfileNamespace;	

			['Stats Update', format['%1/%2', _name, time]] call logDebug;
		};

	};	

};

GW_ISLOGGING = false;

true