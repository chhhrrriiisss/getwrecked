//
//      Name: generateStatsList
//      Desc: Creates a list of information about a vehicle in the specified control
//      Return: None
//

private ['_display', '_control', '_v', '_vehicleStats', '_dist', '_stats'];

_control = [_this,0, [], [[]]] call BIS_fnc_param;
_v = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (count _control == 0 || isNull _v) exitWith {};

// Get the control and clear it
disableSerialization;
_statsList = (findDisplay (_control select 0)) displayCtrl (_control select 1);

lnbClear _statsList;

// Collect all stats
_dist = (_v getVariable ["mileage", 0]);
_dist = if (_dist > 5000) then { format['%1km', _dist / 1000] } else { format['%1m', _dist ]};
_seconds = (_v getVariable ["timeAlive", 0]);
_hoursAlive = floor(_seconds / 3600);
_minsAlive = floor((_seconds - (_hoursAlive*3600)) / 60);
_secsAlive = floor(_seconds % 60);
_timeAlive = format['%1h : %2m : %3s', ([_hoursAlive, 2] call padZeros), ([_minsAlive, 2] call padZeros), ([_secsAlive, 2] call padZeros)];
_raw = [typeOf _v, GW_VEHICLE_LIST] call getData;
if (isNil "_raw") exitWith {};	
_data = _raw select 2;
_maxWeapons = (_data select 1);
_maxModules = (_data select 2);

// Array formatting the stats into rows/columns
_stats = [
	['', '', ''],
	['', 'Health', format['%1%2', round ((1-(getDammage _v)) * 100), '%']],
	['', 'Mass', format['%1kg', round ( (getMass _v) / 10), '%']],
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
		format['%1', (_v getVariable ["kills", 0])]
	],
	['', 'Deaths', 
		format['%1', (_v getVariable ["deaths", 0])]
	],
	['', 'Destroyed', 
		format['%1', (_v getVariable ["destroyed", 0])]
	],
	['', 'Deploys', 
		format['%1', (_v getVariable ["deploys", 0])]
	],
	['', 'Mileage', _dist],
	['', 'Money Earned', format['$%1', [(_v getVariable ["moneyEarned", 0])] call numberToCurrency] ],
	['', 'Time Alive',_timeAlive],
	['', 'Creator', 
		(_v getVariable ["creator", ""])
	],
	['', '', '']
];

{
	_statsList lnbAddRow['', (_x select 1), (_x select 2)];
} ForEach _stats;