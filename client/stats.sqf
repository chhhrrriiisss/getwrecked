//
//      Name: stats
//      Desc: Handles updating and saving vehicle stats to profile name space
//      Return: None
//

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

switch (_statToLog) do {
	
	case "death":
	{		
		_previousDeaths = _vehicle getVariable ["deaths", 0];
		_totalDeaths = _previousDeaths + _value;
		_vehicle setVariable ['deaths', round(_totalDeaths)]; 
	};

	case "destroyed":
	{		
		_previousDestroys = _vehicle getVariable ["destroyed", 0];
		_totalDestroys = _previousDestroys + _value;
		_vehicle setVariable ['destroyed', round(_totalDestroys)]; 
	};

	case "kill":
	{		
		_previousKills = _vehicle getVariable ["kills", 0];
		_totalKills = _previousKills + _value;
		_vehicle setVariable ['kills', round(_totalKills)]; 
	};

	case "mileage":
	{
		_previousDistance = _vehicle getVariable ["mileage", 0];
		_totalDistance = _previousDistance + _value;
		_vehicle setVariable ['mileage', round(_totalDistance)]; 

	};

	case "moneyEarned":
	{
		_previousValue = _vehicle getVariable ["moneyEarned", 0];
		_totalEarned = _previousValue + _value;
		_vehicle setVariable ['moneyEarned', _totalEarned]; 

	};

	case "timeAlive":
	{
		_previousAlive = _vehicle getVariable ["timeAlive", 0];
		_totalAlive = _previousAlive + _value;
		_vehicle setVariable ['timeAlive', _totalAlive]; 

	};

	case "deploy":
	{
		_previousAlive = _vehicle getVariable ["deploys", 0];
		_totalAlive = _previousAlive + _value;
		_vehicle setVariable ['deploys', _totalAlive]; 

	};

};

// If its 9 seconds since last sync, sync data to profile
_remainder = round (time) % 9;

if (isNil "GW_LASTSYNC") then { 
	GW_LASTSYNC = (time - 10); 
};

_currentTime = time;

// Every 10 seconds, sync the data
if ((_currentTime - GW_LASTSYNC) >= 10 || _forceSync) then {

	GW_LASTSYNC = time;

	if (GW_DEBUG) then { systemchat 'Attempting sync'; };	


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

			if (GW_DEBUG) then { systemChat format['%1 stats updated at %2', _name, time]; } ;
		};

	};	

};

GW_ISLOGGING = false;

true