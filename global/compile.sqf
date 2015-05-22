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
parseZones = compile preprocessFile 'global\functions\parse_zones.sqf';
call compile preprocessFile "client\customization\supply_box.sqf";

// Event Handlers
setVehicleHandlers = compile preprocessFile "server\vehicles\set_handlers.sqf";
loadVehicle = compile preprocessFile  'global\functions\loadVehicle.sqf';

handleDamageVehicle = compile preprocessFile 'client\vehicles\handlers\handle_damage.sqf';
handleExplosionVehicle = compile preprocessFile 'client\vehicles\handlers\handle_explosion.sqf';
handleContactVehicle = compile preprocessFile 'client\vehicles\handlers\handle_contact.sqf';
handleContactStartVehicle = compile preprocessFile 'client\vehicles\handlers\handle_contact_start.sqf';
handleHitVehicle = compile preprocessFile 'client\vehicles\handlers\handle_hit.sqf';
handleKilledVehicle = compile preprocessFile 'client\vehicles\handlers\handle_killed.sqf';
handleGetIn = compile preprocessFile 'client\vehicles\handlers\handle_getin.sqf';
handleGetOut = compile preprocessFile 'client\vehicles\handlers\handle_getout.sqf';

// Event Handlers
setObjectHandlers = compile preprocessFile "global\functions\setObjectHandlers.sqf";
setObjectProperties = compile preprocessFile "global\functions\setObjectProperties.sqf";

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
createObject = compile preprocessFile "global\functions\createObject.sqf";
setPitchBankYaw = compile preprocessFile 'global\functions\setPitchBankYaw.sqf';
setDirTo = compile preprocessFile 'global\functions\setDirTo.sqf';
setVectorDirAndUpTo = compile preprocessFile 'global\functions\setVectorDirAndUpTo.sqf';

// Vehicle utility
clearPad = compile preprocessFile  'client\persistance\clear.sqf';

// Data finders
findAllInZone = compile preprocessFile 'global\functions\findAllinZone.sqf';
findAllObjects = compile preprocessFile 'global\functions\findAllObjects.sqf';
findAllMarkers = compile preprocessFile 'global\functions\findAllMarkers.sqf';
findClosest = compile preprocessFile 'global\functions\findClosest.sqf';
findEmpty = compile preprocessFile 'global\functions\findEmpty.sqf';
findUnit = compile preprocessFile 'global\functions\findUnit.sqf';
findVehicle = compile preprocessFile 'global\functions\findVehicle.sqf';
allPlayers = compile preprocessFile 'global\functions\allPlayers.sqf';
getBoundingBox = compile preprocessFile 'global\functions\getBoundingBox.sqf';
getData = compile preprocessFile 'global\functions\getData.sqf';
snapToPad = compile preprocessFile 'global\functions\snapToPad.sqf';

// Utility
getVectorDirAndUpRelative = compile preprocessFile 'global\functions\getVectorDirAndUpRelative.sqf';
limitToRange = compile preprocessFile 'global\functions\limitToRange.sqf';
hasType = compile preprocessFile 'global\functions\hasType.sqf';
positionToString = compile preprocessFile 'global\functions\positionToString.sqf';
checkOwner = compile preprocessFile 'global\functions\checkOwner.sqf';
findLocationInZone = compile preprocessFile "global\functions\findLocationInZone.sqf";
arrayToJson = compile preprocessFile 'global\functions\arrayToJson.sqf';
dirTo = compile preprocessFile 'global\functions\dirTo.sqf';
filterParam = compile preprocessFile 'global\functions\filterParam.sqf';

shareVehicle = compile preprocessFile 'global\functions\shareVehicle.sqf';
copyVehicle = compile preprocessFile 'global\functions\copyVehicle.sqf';

// Numerical
flipDir = compile preprocessFile 'global\functions\flipDir.sqf';
normalizeAngle = compile preprocessFile 'global\functions\normalizeAngle.sqf';
flattenAngle = compile preprocessFile 'global\functions\flattenAngle.sqf';
padZeros = compile preprocessFile 'global\functions\padZeros.sqf';
dirToVector = compile preprocessFile 'global\functions\dirToVector.sqf';
roundTo = compile preprocessFile 'global\functions\roundTo.sqf';

// Vehicle Functions 
call compile preprocessFile 'client\vehicles\functions.sqf';
compileAttached = compile preprocessFile "client\vehicles\compile_attached.sqf";
cleanAttached = compile preprocessFile "client\vehicles\clean_attached.sqf";
swapVehicleTexture = compile preprocessFile 'client\functions\swapVehicleTexture.sqf';
setVehicleTexture = compile preprocessFile 'client\vehicles\set_vehicle_texture.sqf';
setVehicleLocked = compile preprocessFile 'client\vehicles\set_vehicle_locked.sqf';
removeVehicleStatus = compile preprocessFile "global\functions\removeVehicleStatus.sqf";
addVehicleStatus = compile preprocessFile "global\functions\addVehicleStatus.sqf";
triggerVehicleStatus = compile preprocessFile "client\vehicles\status_effects.sqf";
checkTyres = compile preprocessFile 'global\functions\checkTyres.sqf';
checkEject = compile preprocessFile 'global\functions\checkEject.sqf';

// Zone Functions
checkInZone = compile preprocessFile 'global\functions\checkInZone.sqf';

// Network Functions
gw_fnc_mp = compileFinal preprocessFile 'global\functions\network\fn_mp.sqf';
gw_fnc_mpexec = compileFinal preprocessFile 'global\functions\network\fn_mpexec.sqf';

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
