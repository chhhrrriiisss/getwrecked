//
//
//		Leaderboard functions
//
//

if (!isServer || !GW_LEADERBOARD_ENABLED) exitWith {};

GW_LEADERBOARD = profileNamespace getVariable ['GW_LEADERBOARD', nil];

if (isNil "GW_LEADERBOARD") then {
	GW_LEADERBOARD = [];
	profileNamespace setVariable ['GW_LEADERBOARD', []];
	saveProfileNamespace;
};

// [ Name, Vehicle [ Kill, deaths, money earned, distance ] ]

addToLeaderboard = {
	
	_uid = [_this,0, "", [""]] call filterParam;
	_name = [_this,1, "", [""]] call filterParam;
	_vehicle = [_this,2, "", [""]] call filterParam;
	_vehicleType = [_this,3, "", [""]] call filterParam;
	_stats = [_this,4, [], [[]]] call filterParam;
	_exists = false;

	GW_LEADERBOARD = profileNamespace getVariable ['GW_LEADERBOARD', []];

	

	{
		if ((_x select 0) == _uid && (_x select 1) == _name && (_x select 2) == _vehicle) then {

			_exists = true;
			_data = (_x select 4);		

			if (count _data != count _stats) then {
				_data resize (count _stats);
			};

			for "_i" from 0 to ((count _stats) -1) step 1 do {

				_v = [_data, _i, 0, [0]] call filterParam;
				_data set [_i, (_v + (_stats select _i))];

			};
		};

		false

	} count GW_LEADERBOARD > 0;


	if (!_exists) then {
		GW_LEADERBOARD pushback [ _uid, _name, _vehicle, _vehicleType, _stats ];
	};

	diag_log format['Updated leaderboard with %1, %2, %3, %4, %5.', _uid, _name, _vehicle, _vehicleType, _stats];
	
	profileNamespace setVariable ['GW_LEADERBOARD', GW_LEADERBOARD];
	saveProfileNamespace;

};

removeFromLeaderboard = {
	
	_name = [_this,0, "", [""]] call filterParam;

	{
		if ((_x select 1) == _name || (_x select 2) == _name) then {
			GW_LEADERBOARD deleteAt _forEachIndex;
		};
	} Foreach GW_LEADERBOARD;

	profileNamespace setVariable ['GW_LEADERBOARD', GW_LEADERBOARD];
	saveProfileNamespace;

	diag_log format['Entry %1 removed from leaderboard.'];

};