//
//      Name: cleanup
//      Desc: Custom cleanup function for Get Wrecked 
//		Author: Sli
//      Return: None
//

if (isNil { GW_CLEANUP_ACTIVE }) then {
	GW_CLEANUP_ACTIVE = false;
};

if (GW_CLEANUP_ACTIVE) then {
	GW_CLEANUP_ACTIVE = false;
	WaitUntil{ Sleep 1; (isNil { GW_CLEANUP_ACTIVE }) };
};

// Items to check / Timeout for item
cleanUpCommands = [
	[{ 
		_a = [];
		{ 
			_ignore = _x getVariable ['GW_CU_IGNORE', false];
			if (isNull (attachedTo _x) && !_ignore) then { 
				if (_x call isSupplyBox) then {
					_inv = _x getVariable ['GW_Inventory', []];
					if (count _inv > 0) exitWith {};				
					_a pushBack _x; 
				} else {
					_a pushBack _x; 
				};
			};
			false
		} count (nearestObjects [(getmarkerpos "workshopZone_camera"), [], 300]);
		_a
	}, 240],
	[{ 
		_a = [];
		_workshop = (getmarkerpos "workshopZone_camera");
		{ 
			_minDist = if ((_x distance _workshop) < 300) then { 75 } else { 10 };
			_vS = (ASLtoATL getPosASL _x) nearEntities [["Man"], _minDist];
			_crew = false;
			{ if (alive _X) exitWith { _crew = true; }; false } count (crew _x);
			if (_vS isEqualTo [] && !_crew) then { _a pushBack _x; } else { _x setVariable ["GW_CU", nil]; };	
			false
		} count (allMissionObjects "Car");
		_a
	}, 60],
	[{ (allMissionObjects "#destructioneffects") }, 10],
	[{ (allMissionObjects "#smokesource") }, 10],
	[{ (allMissionObjects "Default") }, 10],
	[{ (allMissionObjects "EmptyDetector") }, 10],
	[{ (allMissionObjects "CraterLong") }, 10],
	[{ (allMissionObjects "Ruins") }, 10],
	[{ (allDead) }, 60]
];

checkDeadTimeout = compileFinal '	
	if (typename (_this select 0) != "OBJECT") exitWith { false };
	_cT = (_this select 0) getVariable ["GW_CU", nil];
	if (isNil "_cT") exitWith {	(_this select 0) setVariable ["GW_CU", time]; };
	if (time > (_cT + (_this select 1))) exitWIth { true };
	false
';

executeCleanUp = {
		
	{
		_arr = call (_x select 0);
		_timeout = _x select 1;

		{
			_ignore = _x getVariable ['GW_CU_IGNORE', false];
			if ( ([_x, _timeout] call checkDeadTimeout) && !_ignore ) then {
				diag_log format['Deleted %1 at %2', typeof _x, time];
				{ deleteVehicle _x; } foreach (attachedObjects _x);
				deleteVehicle _x;
			};
		} count _arr > 0;	

	} count cleanUpCommands;

	if (isNil { _this select 0 }) exitWith { true };

	_source = owner (_this select 0);

	_str = "Cleanup script successfully run.";
	systemchat _str;
	pubVar_systemChat = _str;	
	_source publicVariableClient "pubVar_systemChat";
	systemchat format['Cleanup script executed manually at %1', time];

	true

};

if (GW_CLEANUP_RATE == 0) exitWith {
	diag_log 'Cleanup aborted as user specified MANUAL mode';
	GW_CLEANUP_ACTIVE = false;
};

_rate = GW_CLEANUP_RATE call {
	if (_this == 0) exitWith { [0,0,0] }; // Off	
	if (_this == 5) exitWith { [60, 45, 30] }; // V.High
	if (_this == 4) exitWith { [3*60, 2*60, 60] }; // High		
	if (_this == 2) exitWith { [6*60, 5*60, 4*60] }; // Med
	if (_this == 1) exitWith { [10*60, 8*60, 6*60] }; // Low
	[5*60, 3*60, 2*60] // Default (3)
};

GW_CLEANUP_RATE_LOW = _rate select 0; // < 50%
GW_CLEANUP_RATE_MED = _rate select 1; // >= 50%
GW_CLEANUP_RATE_HIGH = _rate select 2; // >= 75%

_cleanupTick = 10; 

GW_CLEANUP_ACTIVE = true;
GW_CLEANUP_TIMEOUT = time;

diag_log format['Cleanup script initialized at %1', time];

for "_i" from 0 to 1 step 0 do {
	
	if (!GW_CLEANUP_ACTIVE) exitWith {};

	if (time < GW_CLEANUP_TIMEOUT) then {} else {

		_rate = ((count allUnits) / GW_MAX_PLAYERS) call {
			_this = [_this, 0, 1] call limitToRange;
			if (_this >= 0.75) exitWith { GW_CLEANUP_RATE_HIGH };
			if (_this >= 0.5) exitWith { GW_CLEANUP_RATE_MED };
			GW_CLEANUP_RATE_LOW
		};

		GW_CLEANUP_TIMEOUT = time + _rate;
		diag_log format['Running cleanup script at %1', time];

		[] call executeCleanUp;
			
		diag_log format['Cleanup sleeping until %1s', GW_CLEANUP_TIMEOUT];
	};

	Sleep _cleanupTick;
};

diag_log format['Cleanup script stopped at %1', time];
GW_CLEANUP_ACTIVE = nil;