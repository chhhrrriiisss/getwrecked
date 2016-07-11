//
//
//
//		Global Function Compile 
//
//
//

if (isNIl "GW_ZONE_MANIFEST") THEN {
	GW_ZONE_MANIFEST = [];
};

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

// Name List
call compile preprocessFile 'global\names.sqf';

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
	
} else {
	logDebug = { true };
};

// Custom checks for object/vehicles
isObject = {
	_tag = _this getVariable ['GW_Tag', ''];
	if (_tag isEqualTo '') exitWith { false };
	true
};

GW_SUPPLY_CLASS = "Land_PaperBox_closed_F";
isSupplyBox = {
	if ((typeOf _this) isEqualTo GW_SUPPLY_CLASS) exitWith  { true };
	false
};

GW_PAINT_CLASS = "Land_Bucket_painted_F";
isPaint = {	
	if ((typeOf _this) isEqualTo GW_PAINT_CLASS) exitWith  { true };
	false	
};

hasMelee = {	
	_melee = false;
	{
		if ( [_x, _this] call hasType >= 0) exitWith { _melee = true; };
	} foreach GW_MELEEWEAPONS;
	_melee
};

isMelee = {
	_tag = _this getVariable ['GW_Tag', ''];
	if (_tag in GW_MELEEWEAPONS) exitWith { true };
	false
};

isWeapon = {
	_tag = _this getVariable ['GW_Tag', ''];
	if (_tag in GW_WEAPONSARRAY) exitWith { true };
	false
};

isModule = {
	_tag = _this getVariable ['GW_Tag', ''];
	if (_tag in GW_TACTICALARRAY) exitWith { true };
	false
};

isSpecial = {
	_tag = _this getVariable ['GW_Tag', ''];
	if (_tag in GW_SPECIALARRAY) exitWith { true };
	false
};

isHolder = {	
	if ((typeof _this) == "GroundWeaponHolder") exitWith { true };
	false
};


// Trigger function for a supply box effects
supplyDropEffect = {	
	params ['_crate', '_id'];
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
		case "C_Van_01_fuel_F": { "client\images\outlines\truck_fuel_low.paa"	};
		case "C_Van_01_box_F": { "client\images\outlines\truck_box_low.paa"	};
		default	{ (getText(configFile >> "CfgVehicles" >> (_this select 0) >> "picture"))};
	};
	
};

// Returns reload and cost data requested tag [Reload, Cost]
getTagData = {
	_data = [(_this select 0), GW_LOOT_LIST] call getData;
	if (isNil "_data") exitWith { [0,0] };
	(_data select 10)
};

// Zone Functions
call compile preprocessFile "client\customization\supply_box.sqf";

// Vehicle Functions 
call compile preprocessFile 'client\vehicles\functions.sqf';

// Function compiler
functionCompiler = compile preprocessFile "global\functions\functionCompiler.sqf";

performanceTest = compile preprocessFile 'global\functions\performanceTest.sqf';

GW_globalFunctions = [
	
	// Vehicle event handlers
	['setVehicleHandlers', 'server\vehicles\'],	
	['handleDamageVehicle', 'client\vehicles\handlers\'],
	['handleExplosionVehicle', 'client\vehicles\handlers\'],
	['handleContactVehicle', 'client\vehicles\handlers\'],
	['handleContactStartVehicle', 'client\vehicles\handlers\'],
	['handleHitVehicle', 'client\vehicles\handlers\'],
	['handleKilledVehicle', 'client\vehicles\handlers\'],
	['handleGetIn', 'client\vehicles\handlers\'],
	['handleGetOut', 'client\vehicles\handlers\'],

	// Object event handlers
	['setObjectHandlers', nil],
	['setObjectProperties', nil],
	['handleDamageObject', 'client\objects\handlers\'],	
	['handleContactObject', 'client\objects\handlers\'],
	['handleHitObject', 'client\objects\handlers\'],
	['handleKilledObject', 'client\objects\handlers\'],
	['handleTakeObject', 'client\objects\handlers\'],
	['handleDisassembledObject', 'client\objects\handlers\'],
	['handleExplosionObject', 'client\objects\handlers\'],


	// Vehicle utility functions
	['setVehicleDamage', nil],
	['getHitPoints', nil],
	['updateVehicleDamage', nil],
	['sendVehicleHit', nil],

	// Vehicle specific functions
	['loadVehicle', nil],
	['shareVehicle', nil],
	['copyVehicle', nil],

	// Object utility functions
	['destroyObj', 'client\objects\'],
	['createObject', nil],
	['setPitchBankYaw', nil],
	['setDirTo', nil],
	['setVectorDirAndUpTo', nil],	
	['clearPad', 'client\persistance\'],

	// Finders
	['findCurrentZone', nil],
	['findAllInZone', nil],
	['findAllObjects', nil],
	['findAllMarkers', nil],
	['findClosest', nil],
	['findEmpty', nil],
	['findUnit', nil],
	['findVehicle', nil],
	['getBoundingBox', nil],
	['getData', nil],
	['snapToPad', nil],

	// Utility
	['getVectorDirAndUpRelative', nil],
	['limitToRange', nil],
	['hasType', nil],
	['positionToString', nil],
	['checkOwner', nil],
	['findLocationInZone', nil],
	['arrayToJson', nil],
	['dirTo', nil],
	['relPos', nil],
	['filterParam', nil],
	['insertAt', nil],

	// Numerical Utility
	['flipDir', nil],
	['normalizeAngle', nil],
	['flattenAngle', nil],
	['padZeros', nil],
	['dirToVector', nil],
	['roundTo', nil],
	['formatTimeStamp', nil],
	['getMax', nil],

	// Module functions
	['smokeBomb', 'client\vehicles\attachments\'],
	['verticalThruster', 'client\vehicles\attachments\'],
	['nitroBoost', 'client\vehicles\attachments\'],
	['emergencyRepair', 'client\vehicles\attachments\'],
	['empDevice', 'client\vehicles\attachments\'],
	['selfDestruct', 'client\vehicles\attachments\'],
	['emergencyParachute', 'client\vehicles\attachments\'],
	['oilSlick', 'client\vehicles\attachments\'],
	['dropCaltrops', 'client\vehicles\attachments\'],
	['dropMines', 'client\vehicles\attachments\'],
	['dropExplosives', 'client\vehicles\attachments\'],	
	['dropNapalm', 'client\vehicles\attachments\'],
	['dropTeleport', 'client\vehicles\attachments\'],
	['dropJammer', 'client\vehicles\attachments\'],
	['shieldGenerator', 'client\vehicles\attachments\'],
	['cloakingDevice', 'client\vehicles\attachments\'],
	['magneticCoil', 'client\vehicles\attachments\'],
	['dropLimpets', 'client\vehicles\attachments\'],
	['activateElectromagnet', 'client\vehicles\attachments\'],

	// Vehicle functions
	['compileAttached', 'client\vehicles\'],
	['cleanAttached', 'client\vehicles\'],
	['swapVehicleTexture', 'client\functions\'],
	['setVehicleTexture', 'client\vehicles\'],
	['setVehicleLocked', 'client\vehicles\'],

	['removeVehicleStatus', nil],
	['addVehicleStatus', nil],

	['triggerVehicleStatus', 'client\vehicles\'],
	['checkTyres', nil],
	['checkEject',  nil],

	['checkInZone', nil],
	['checkRaceStatus', nil],
	['getRaceID', nil],

	['gw_fnc_mp', 'global\functions\network\'],
	['gw_fnc_mpexec', 'global\functions\network\']



];

// Batch compile all functions
[GW_globalFunctions, 'global\functions\', GW_DEV_BUILD] call functionCompiler;

// Pre-compile location arrays
reloadAreas = ['reloadArea', false, true] call findAllObjects;
repairAreas = ['repairArea', false, true] call findAllObjects;
refuelAreas = ['refuelArea', false, true] call findAllObjects;
saveAreas = ['saveArea'] call findAllObjects;
tempAreas = ['tempArea', false] call findAllMarkers;
spawnAreas = ['spawnArea', false] call findAllMarkers;
buySigns = ['buySign'] call findAllObjects;
vehicleTerminals = ['vehicleTerminal'] call findAllObjects;
nitroPads = ['nitroPad', false, true] call findAllObjects;
flamePads = ['flamePad', false, true] call findAllObjects;

// Get General point data regarding boundary
call compile preprocessFile "global\functions\getZoneBoundaryPoints.sqf";
