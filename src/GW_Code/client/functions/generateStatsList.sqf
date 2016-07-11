//
//      Name: generateStatsList
//      Desc: Creates a list of information about a vehicle in the specified control
//      Return: None
//

private ['_display', '_control', '_v', '_vehicleStats', '_dist', '_stats'];

_control = [_this,0, [], [[]]] call filterParam;
_v = [_this,1, objNull, [objNull]] call filterParam;
_tO = [_this,2, time + 3, [0]] call filterParam;
_this set [2, _tO];


if (count _control == 0 || isNull _v) exitWith {};

// Get the control and clear it
disableSerialization;
_statsList = (findDisplay (_control select 0)) displayCtrl (_control select 1);

lnbClear _statsList;

// If not ready to parse stats, call again in 0.5 seconds 
_isSetup = _v getVariable ['isSetup', false];
if (!_isSetup && time <= _tO) exitWith {
	_statsList lnbAddRow['', ''];
	_statsList lnbAddRow['', 'Loading...'];
	_this spawn { Sleep 1; _this call generateStatsList; };
};

// Collect all stats
_name = _v getVariable ['name', ''];

_dist = ["mileage", _name] call getStat;
_dist = if (_dist isEqualType []) then { 0 } else { if (_dist isEqualType "") exitWith { parseNumber _dist }; _dist };
_dist = if (_dist > 5000) then { format['%1km', [_dist / 1000, 1] call roundTo ] } else { format['%1m', [_dist, 1] call roundTo ]};
_seconds = ["timeAlive", _name] call getStat;
_seconds = if !(_seconds isEqualType 0) then { 0 } else { _seconds };
_hoursAlive = floor(_seconds / 3600);
_minsAlive = floor((_seconds - (_hoursAlive*3600)) / 60);
_secsAlive = floor(_seconds % 60);
_timeAlive = format['%1h : %2m : %3s', ([_hoursAlive, 2] call padZeros), ([_minsAlive, 2] call padZeros), ([_secsAlive, 2] call padZeros)];

_v call updateVehicleDamage;
_health = (_v getVariable ['GW_Health', 100]);

_massModifier = _v getVariable ['massModifier', 1];
_maxMass = _v getVariable ['maxMass', 99999];
_defaultMass = _v getVariable ['mass', 1000];
_actualMass = [ round ( (getMass _v) / _massModifier), _defaultMass, _maxMass] call limitToRange;

_maxWeapons = _v getVariable ['maxWeapons', 0];
_maxModules = _v getVariable ['maxModules', 0];

// Array formatting the stats into rows/columns
_stats = [
	['', '', ''],
	['', 'Health', format['%1%2', _health, '%']],
	['', 'Mass', format['%1kg',  _actualMass]],
	['', 'Ammo Capacity', format['%1%2', round( (_v getVariable ["maxAmmo", 1]) * 100), '%']],
	['', 'Fuel Tank', format['%1L', round( (_v getVariable ["maxFuel", 1]) * 100), '%']],
	['', 'Weapons', 
		format['%1 / %2', count (_v getVariable ["weapons", []]), _maxWeapons]
	],
	['', 'Modules',  
		format['%1 / %2', count (_v getVariable ["tactical", []]), _maxModules]
	],
	['', '', ''],
	['', 'Kills', 
		format['%1', ["kill", _name] call getStat]
	],
	['', 'Deaths', 
		format['%1', ["death", _name] call getStat]
	],
	['', 'Deploys', 
		format['%1', ["deploy", _name] call getStat]
	],
	['', 'Race Wins', 
		format['%1', ["racewin", _name] call getStat]
	],
	['', 'Immobilized', 
		format['%1', ["disabled", _name] call getStat]
	],
	['', 'Out of Bounds', 
		format['%1', ["outofbounds", _name] call getStat]
	],
	['', 'Mileage', _dist],
	['', 'Money Earned', format['$%1', [(["moneyEarned", _name] call getStat)] call numberToCurrency] ],
	['', 'Time Alive',_timeAlive],
	['', 'Creator', 
		(_v getVariable ["creator", "Unknown"])
	],
	['', '', '']
];

{
	_statsList lnbAddRow['', (_x select 1), (_x select 2)];
	false
} count _stats > 0;