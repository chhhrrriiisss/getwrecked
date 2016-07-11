//
//
//
//		Server Function Compile & Configuration
//
//
//

logKill = compile preprocessFile "server\functions\logKill.sqf";

// Zone Functions
initEvents = compile preprocessFile "server\zones\events.sqf";
createSupplyDrop = compile preprocessFile "server\zones\createSupplyDrop.sqf";
createHunterSeeker = compile preprocessFile "server\zones\createHunterSeeker.sqf";
createRace = compile preprocessFile "server\zones\createRace.sqf";
endRace = compile preprocessFile "server\zones\endRace.sqf";
removeFromRace = compile preprocessFile "server\zones\removeFromRace.sqf";

// Zone
buildZoneBoundaryServer = compile preprocessFile "server\zones\buildZoneBoundaryServer.sqf";

// Utility
call compile preprocessFile "server\functions\cleanup.sqf";

// Object
setupObject = compile preprocessFile "server\objects\setup_object.sqf";

// Vehicle
setVehicleRespawn = compile preprocessFile "server\vehicles\vehicle_respawn.sqf";
setupVehicle = compile preprocessFile "server\vehicles\setup_vehicle.sqf";
// loadVehicle = compile preprocessFile "server\functions\loadVehicle.sqf";

// AI
call compile preprocessFile "server\ai\config.sqf";
createAI = compile preprocessFile "server\ai\createAI.sqf";

pubVar_fnc_logDiag = compile preprocessFile "server\functions\pubVar_logDiag.sqf";
"pubVar_logDiag" addPublicVariableEventHandler { (_this select 1) call pubVar_fnc_logDiag };

// Utility
setVisibleAttached = compile preprocessFile "server\functions\setVisibleAttached.sqf";
setObjectSimulation = compile preprocessFile "server\functions\setObjectSimulation.sqf";
setSimulationVisibility =  compile preprocessFile "server\functions\setSimulationVisibility.sqf";
setPosEmpty = compile preprocessFile "server\functions\setPosEmpty.sqf";
setObjectOwner = compile preprocessFile "server\functions\setObjectOwner.sqf";

// Server keeps a cached record of which zones players are in
pubVar_fnc_setZone = {
	
	private ['_unit', '_zone'];

	_unit = _this select 0;
	_zone = _this select 1;
	_id = owner _unit;

	if (isNull _unit) exitWith {};
	if (count toArray _zone == 0) exitWith {};

	_found = false;
	{
		// Use unit ID to track same player unit (vs object which can change on death)
		if ((_x select 2) == _id) exitWith { 

			_found = true; 

			if (_zone == "remove") exitWith {
				GW_ZONE_MANIFEST deleteAt _forEachIndex;
			};

			// Update unit and zone
			_x set [0, _unit]; 
			_x set [1, _zone]; 

		};

	} foreach GW_ZONE_MANIFEST;

	if (!_found) then {
		GW_ZONE_MANIFEST pushback [_unit, _zone, _id];
	};

	if (isNil "GW_LAST_MANIFEST_UPDATE") then { GW_LAST_MANIFEST_UPDATE = time - 1; };
	if (time - GW_LAST_MANIFEST_UPDATE < 1) exitWith {};
	GW_LAST_MANIFEST_UPDATE = time;

	if (GW_DEBUG) then { systemchat format['Manifest updated at %1', time]; };

	publicVariable "GW_ZONE_MANIFEST";
};	

"pubVar_setZone" addPublicVariableEventHandler { (_this select 1) call pubVar_fnc_setZone; };

// Leaderboard
if (GW_LEADERBOARD_ENABLED) then {
	call compile preprocessFile "server\functions\leaderboard.sqf";
};

GW_CURRENTZONE = "workshopZone";
GW_ACTIVE_RACES = [];
GW_ACTIVE_RACE_VEHICLES = [];

serverInit = compile preprocessFile "server\init.sqf";

serverCompileComplete = compileFinal "true";

