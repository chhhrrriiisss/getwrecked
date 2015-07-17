//
//
//
//		Server Initialization
//
//
//

_startTime = time;

[] call GWS_fnc_initObjects;
[] call GWS_fnc_initSupplyAndPaint;
[] call GWS_fnc_initBoundary;
[] call GWS_fnc_initNitro;
[] spawn initEvents;

// Prevent cleanup on mission.sqm placed items
{
	_x setVariable ['GW_CU_IGNORE', true];
	false
} count (nearestObjects [(getmarkerpos "workshopZone_camera"), [], 200]) > 0;

// Make AI attack civlian players
west setFriend [civilian, 0];
east setFriend [civilian, 0];

//[] spawn initCleanup;

serverSetupComplete = compileFinal "true";
publicVariable "serverSetupComplete";

_endTime = time;
_str =  format['Server setup completed in %1s.', (_endTime - _startTime)];
diag_log _str;
systemchat _str;

