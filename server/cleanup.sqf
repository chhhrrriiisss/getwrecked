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

_checkDeadTimeout = compileFinal '	
	if (typename (_this select 0) != "OBJECT") exitWith { false };
	_cT = (_this select 0) getVariable ["GW_CU", nil];
	if (isNil "_cT") exitWith {	(_this select 0) setVariable ["GW_CU", time]; };
	if (time > (_cT + (_this select 1))) exitWIth { true };
	false
';

// Items to check / Timeout for item
_itemsToClean = [
	[{ 
		_a = [];
		{ 
			_ignore = _x getVariable ['GW_CU_IGNORE', false];
			if (isNull (attachedTo _x) && !_ignore) then { _a pushBack _x; };
			false
		} count (nearestObjects [(getmarkerpos "workshopZone_camera"), [], 150]);
		_a
	}, 30],
	[{ 
		_a = [];
		{ 
			_vS = (ASLtoATL getPosASL _x) nearEntities [["Man"], 25];
			_crew = false;
			{ if (alive _X) exitWith { _crew = true; }; false } foreach (crew _x);
			if (_vS isEqualTo [] && !_crew) then { _a pushBack _x; } else { _x setVariable ["GW_CU", nil]; };	
			false
		} count (allMissionObjects "Car");
		_a
	}, 30],
	[{ (allMissionObjects "#destructioneffects") }, 10],
	[{ (allMissionObjects "#smokesource") }, 10],
	[{ (allMissionObjects "Default") }, 10],
	[{ (allMissionObjects "EmptyDetector") }, 10],
	[{ (allMissionObjects "CraterLong") }, 10],
	[{ (allMissionObjects "Ruins") }, 10],
	[{ (allDead) }, 30]
];

_cleanupTick = 10; 
_maxCleanupCheck = 4 * 60;
_minCleanupCheck = 30;

GW_CLEANUP_ACTIVE = TRUE;
GW_CLEANUP_TIMEOUT = time;
diag_log format['Cleanup script initialized at %1', time];

for "_i" from 0 to 1 step 0 do {
	
	if (!GW_CLEANUP_ACTIVE) exitWith {};

	if (time < GW_CLEANUP_TIMEOUT) then {} else {

		GW_CLEANUP_TIMEOUT = time + ([(_maxCleanupCheck - ( (count allUnits) * 30 )), _minCleanupCheck, _maxCleanupCheck] call limitToRange);	
		diag_log format['Running cleanup script at %1', time];

		{
			_arr = call (_x select 0);
			_timeout = _x select 1;

			{
				_ignore = _x getVariable ['GW_CU_IGNORE', false];
				if ( ([_x, _timeout] call _checkDeadTimeout) && !_ignore ) then {
					diag_log format['Deleted %1 at %2', typeof _x, time];
					{ deleteVehicle _x; false } count (attachedObjects _x) > 0;
					deleteVehicle _x;
				};
			} count _arr > 0;	

		} count _itemsToClean;
		
			
		diag_log format['Cleanup sleeping until %1s', GW_CLEANUP_TIMEOUT];
	};

	Sleep _cleanupTick;
};

diag_log format['Cleanup script stopped at %1', time];
GW_CLEANUP_ACTIVE = nil;