//
//
//
//		Server Function Compile & Configuration
//
//
//

// Object
setObjectData = compile preprocessFile "server\objects\object_data.sqf";
setObjectHandlers = compile preprocessFile "server\objects\object_handlers.sqf";
setObjectRespawn = compile preprocessFile "server\objects\object_respawn.sqf";
spawnObjects = compile preprocessFile "server\objects\spawn_objects.sqf";

// Vehicle
setVehicleRespawn = compile preprocessFile "server\vehicles\vehicle_respawn.sqf";
setVehicleHandlers = compile preprocessFile "server\vehicles\vehicle_handlers.sqf";
loadVehicle = compile preprocessFile "server\vehicles\load_vehicle.sqf";
setupVehicle = compile preprocessFile "server\vehicles\setup_vehicle.sqf";

// Zone
call compile preprocessFile "server\zones\explosive_barrels.sqf";
generateBoundary = compile preprocessFile "server\zones\generate_boundary.sqf";
initPaint = compile preprocessFile "client\customization\paint_bucket.sqf";

// MP Functions
pubVar_fnc_spawnObject = compile preprocessFile "server\functions\pubVar_spawnObject.sqf";
"pubVar_spawnObject" addPublicVariableEventHandler { (_this select 1) call pubVar_fnc_spawnObject };

logKill = compile preprocessFile "server\functions\logKill.sqf";
serverLoadVehicle = compile preprocessFile "server\functions\serverLoadVehicle.sqf";

// Utility
setVisibleAttached = compile preprocessFile "server\functions\setVisibleAttached.sqf";
setObjectSimulation = compile preprocessFile "server\functions\setObjectSimulation.sqf";
setObjectProperties = compile preprocessFile "server\functions\setObjectProperties.sqf";
