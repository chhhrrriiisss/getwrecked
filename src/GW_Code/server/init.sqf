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
[] call GWS_fnc_initNitroAndFlame;
[] spawn initEvents;

// Wait for zone boundary compilation
waitUntil {
	SLEEP 0.1;
	!isNIl "GW_ZONE_BOUNDARIES_COMPILED"
};

[] call buildZoneBoundaryServer;

// Prevent cleanup on mission.sqm placed items
{
	_x setVariable ['GW_CU_IGNORE', true];
	false
} count (nearestObjects [(getmarkerpos "workshopZone_camera"), [], 200]) > 0;

// Make AI attack civlian players
west setFriend [civilian, 0];
east setFriend [civilian, 0];

// Wait for boundaries to complete for confirming server ready
waitUntil {	
	SLEEP 0.1;
	!isNIl "GW_BOUNDARY_BUILT"
};

serverSetupComplete = compileFinal "true";
publicVariable "serverSetupComplete";

_endTime = time;
_str =  format['Server setup completed in %1s.', (_endTime - _startTime)];
diag_log _str;
systemchat _str;

