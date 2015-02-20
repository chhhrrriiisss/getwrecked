//
//
//
//		Global Function Compile 
//
//
//

// Icon Compile
call compile preprocessFile 'config.sqf';

// Icon Compile
call compile preprocessFile 'global\icons.sqf';

// Vehicle Data Compile
call compile preprocessFile 'global\vehicles.sqf';

// Object Data Compile
call compile preprocessFile 'global\objects.sqf';

// Supply Data Compile
call compile preprocessFile 'global\supply.sqf';

if (hasInterface) then {

	if (isNil "GW_DEBUG_ARRAY") then {
		GW_DEBUG_ARRAY = [];
	};

	logDebug = {

		// Don't log if debug isn't enabled
		if (!GW_DEBUG || !hasInterface) exitWith {};

		if (isNil "GW_DEBUG_ARRAY") then {
			GW_DEBUG_ARRAY = [];
		};

		_exists = false;
		{
			if ((_x select 0) == ( _this select 0)) exitWith {
				GW_DEBUG_ARRAY set [_forEachIndex, [(_x select 0), (_this select 1)]];
				_exists = true;
				true
			};		
			false
		} foreach GW_DEBUG_ARRAY;

		if (!_exists) then {
			GW_DEBUG_ARRAY pushBack [(_this select 0), (_this select 1)];
		};

		true
	};
};

// Trigger function for a supply box effects
supplyDropEffect = {	
	_crate = _this select 0;
	_id = _this select 1;
	(_this select 0) spawn ((GW_SUPPLY_TYPES select _id) select 3);	
	playsound "upgrade";
};

// Custom outlines for a few select vehicles 
// (Why the stock ones are in perspective when all the others are 2D is pretty odd)
getVehiclePicture = {

	switch (_this select 0) do {
		case "C_Hatchback_01_sport_F": { "client\images\outlines\hatchback_low.paa"	};
		case "C_SUV_01_F":{	"client\images\outlines\suv_low.paa" };
		case "C_Van_01_transport_F": { "client\images\outlines\truck_low.paa"	};
		default	{ (getText(configFile >> "CfgVehicles" >> (_this select 0) >> "picture"))};
	};
	
};

// Returns reload and cost data requested tag [Reload, Cost]
getTagData = {

	switch (_this select 0) do {
		
		case "SMK": {  [15, 0]	};
		case "SHD":	{  [60, 0]	};
		case "NTO":	{  [0.75, 0.04] };
		case "THR":	{  [0.1, 0.05] };
		case "OIL":	{  [15, 0.004]	};
		case "REP":	{  [60, 0]	};
		case "DES":	{  [0, 0]	};
		case "EMP":	{  [45, 0]	};
		case "MIN":	{  [30, 0.2] };
		case "PAR":	{  [10, 0]	};
		case "CLK":	{  [0, 0.08] };
		case "MAG":	{  [45, 0]	};
		case "GRP":	{  [1, 0]	};
		case "CAL":	{  [30, 0.1] };
		case "EPL":	{  [1, 0]	};
		case "JMR":	{  [0, 0]	};

		case "HMG": {  [0.15, 0.002]	};
		case "LMG": {  [0.1, 0.001]	};
		case "GMG":	{  [0.75, 0.03] };
		case "RPG":	{  [3, 0.03] };
		case "GUD":	{  [20, 0.15] };
		case "MIS":	{  [10, 0.15] };	
		case "MOR":	{  [3, 0.05] };
		case "RLG":	{  [20, 0.15] };
		case "LSR":	{  [3, 0.05] };		
		case "FLM":	{  [0.5, 0.03] };	
		case 'HAR': {  [8, 0] };

		default
		{
			[0,0]
		};

	};

};

// Zone Functions
parseZones = compile preprocessFile 'global\functions\parse_zones.sqf';
call compile preprocessFile "client\customization\supply_box.sqf";

// Event Handlers
setVehicleHandlers = compile preprocessFile "server\vehicles\set_handlers.sqf";

handleDamageVehicle = compile preprocessFile 'client\vehicles\handlers\handle_damage.sqf';
handleExplosionVehicle = compile preprocessFile 'client\vehicles\handlers\handle_explosion.sqf';
handleContactVehicle = compile preprocessFile 'client\vehicles\handlers\handle_contact.sqf';
handleHitVehicle = compile preprocessFile 'client\vehicles\handlers\handle_hit.sqf';
handleKilledVehicle = compile preprocessFile 'client\vehicles\handlers\handle_killed.sqf';
handleGetIn = compile preprocessFile 'client\vehicles\handlers\handle_getin.sqf';
handleGetOut = compile preprocessFile 'client\vehicles\handlers\handle_getout.sqf';

// Event Handlers
setObjectHandlers = compile preprocessFile "server\objects\set_handlers.sqf";

// Event Handlers
handleDamageObject = compile preprocessFile 'client\objects\handlers\handle_damage.sqf';
handleExplosionObject = compile preprocessFile 'client\objects\handlers\handle_explosion.sqf';
handleContactObject = compile preprocessFile 'client\objects\handlers\handle_contact.sqf';
handleHitObject = compile preprocessFile 'client\objects\handlers\handle_hit.sqf';
handleKilledObject = compile preprocessFile 'client\objects\handlers\handle_killed.sqf';
handleTakeObject = compile preprocessFile 'client\objects\handlers\handle_take.sqf';
handleDisassembledObject = compile preprocessFile 'client\objects\handlers\handle_disassembled.sqf';
setVehicleDamage = compile preprocessFile 'global\functions\setVehicleDamage.sqf';
getHitPoints = compile preprocessFile 'global\functions\getHitPoints.sqf';
updateVehicleDamage = compile preprocessFile 'global\functions\updateVehicleDamage.sqf';
sendVehicleHit = compile preprocessFile 'global\functions\sendVehicleHit.sqf';

// Object Functions
destroyObj = compile preprocessFile "client\objects\destroy.sqf";
createObject = compile preprocessFile "server\objects\create_object.sqf";
setPitchBankYaw = compile preprocessFile 'global\functions\setPitchBankYaw.sqf';

// Vehicle utility
clearPad = compile preprocessFile  'client\persistance\clear.sqf';

// Data finders
findAllInZone = compile preprocessFile 'global\functions\findAllinZone.sqf';
findAllObjects = compile preprocessFile 'global\functions\findAllObjects.sqf';
findAllMarkers = compile preprocessFile 'global\functions\findAllMarkers.sqf';
findClosest = compile preprocessFile 'global\functions\findClosest.sqf';
findEmpty = compile preprocessFile 'global\functions\findEmpty.sqf';
findUnit = compile preprocessFile 'global\functions\findUnit.sqf';
allPlayers = compile preprocessFile 'global\functions\allPlayers.sqf';
getBoundingBox = compile preprocessFile 'global\functions\getBoundingBox.sqf';
getData = compile preprocessFile 'global\functions\getData.sqf';
filterParam = compile preprocessFile 'global\functions\filterParam.sqf';

// Utility
getVectorDirAndUpRelative = compile preprocessFile 'global\functions\getVectorDirAndUpRelative.sqf';
limitToRange = compile preprocessFile 'global\functions\limitToRange.sqf';
hasType = compile preprocessFile 'global\functions\hasType.sqf';
positionToString = compile preprocessFile 'global\functions\positionToString.sqf';
checkOwner = compile preprocessFile 'global\functions\checkOwner.sqf';
shareVehicle = compile preprocessFile 'global\functions\shareVehicle.sqf';
findLocationInZone = compile preprocessFile "global\functions\findLocationInZone.sqf";
arrayToJson = compile preprocessFile 'global\functions\arrayToJson.sqf';
dirTo = compile preprocessFile 'global\functions\dirTo.sqf';

// Numerical
flipDir = compile preprocessFile 'global\functions\flipDir.sqf';
normalizeAngle = compile preprocessFile 'global\functions\normalizeAngle.sqf';
flattenAngle = compile preprocessFile 'global\functions\flattenAngle.sqf';
padZeros = compile preprocessFile 'global\functions\padZeros.sqf';
dirToVector = compile preprocessFile 'global\functions\dirToVector.sqf';

// Vehicle Functions 
call compile preprocessFile 'client\vehicles\functions.sqf';
compileAttached = compile preprocessFile "client\vehicles\compile_attached.sqf";
swapVehicleTexture = compile preprocessFile 'client\functions\swapVehicleTexture.sqf';
setVehicleTexture = compile preprocessFile 'client\vehicles\set_vehicle_texture.sqf';
setVehicleLocked = compile preprocessFile 'client\vehicles\set_vehicle_locked.sqf';
removeVehicleStatus = compile preprocessFile "global\functions\removeVehicleStatus.sqf";
addVehicleStatus = compile preprocessFile "global\functions\addVehicleStatus.sqf";
checkTyres = compile preprocessFile 'global\functions\checkTyres.sqf';
checkEject = compile preprocessFile 'global\functions\checkEject.sqf';

// Zone Functions
checkInZone = compile preprocessFile 'global\functions\checkInZone.sqf';

// Pre-compile location arrays
reloadAreas = ['reloadArea'] call findAllObjects;
repairAreas = ['repairArea'] call findAllObjects;
refuelAreas = ['refuelArea'] call findAllObjects;
saveAreas = ['saveArea'] call findAllObjects;
tempAreas = ['tempArea'] call findAllObjects;
spawnAreas = ['spawnArea'] call findAllObjects;
buySigns = ['buySign'] call findAllObjects;
vehicleTerminals = ['vehicleTerminal'] call findAllObjects;
nitroPads = ['nitroPad'] call findAllObjects;
