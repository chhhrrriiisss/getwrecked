//
//
//
//		Global Function Compile & Configuration
//
//
//

// Spawn timer (in seconds)
GW_RESPAWN_DELAY = 30;

// Vehicle Respawn Settings (in minutes)
GW_ABANDON_DELAY = 10;
GW_DEAD_DELAY = 1;

// Weapon Damage (vs vehicles)
GW_GDS = 0.5;
WHEEL_COLLISION_DMG_SCALE = 0;
COLLISION_DMG_SCALE = 0;
FIRE_DMG_SCALE = 35;
MORTAR_DMG_SCALE = (10 * GW_GDS);
TITAN_AT_DMG_SCALE = (2 * GW_GDS);
RPG_DMG_SCALE = (0.4 * GW_GDS);
GUD_DMG_SCALE = (2 * GW_GDS);
HMG_DMG_SCALE = (4 * GW_GDS);
HMG_HE_DMG_SCALE = (1 * GW_GDS);
HMG_IND_DMG_SCALE = (1 * GW_GDS);
GMG_DMG_SCALE = (4 * GW_GDS);
EXP_DMG_SCALE = (20 * GW_GDS);
LSR_DMG_SCALE = (1 * GW_GDS);
FLM_DMG_SCALE = (0 * GW_GDS);
RLG_DMG_SCALE = 1 * GW_GDS;

// Weapon Damage (vs objects)
GW_GHS = 0.5;
OBJ_COLLISION_DMG_SCALE = 1;
OBJ_MORTAR_DMG_SCALE = (20 * GW_GHS);
OBJ_TITAN_AT_DMG_SCALE = (4 * GW_GHS);
OBJ_RPG_DMG_SCALE = (10 * GW_GHS);
OBJ_GUD_DMG_SCALE = (20 * GW_GHS);
OBJ_HMG_DMG_SCALE = (8 * GW_GHS);
OBJ_HMG_HE_DMG_SCALE = (0.2 * GW_GHS);
OBJ_GMG_DMG_SCALE = (4 * GW_GHS);
OBJ_EXP_DMG_SCALE = (40 * GW_GHS);
OBJ_LSR_DMG_SCALE = (4 * GW_GHS);
OBJ_FLM_DMG_SCALE = (0 * GW_GHS);
OBJ_RLG_DMG_SCALE = 2 * GW_GHS;

// Lock on properties
GW_MINLOCKRANGE = 175;
GW_MAXLOCKRANGE = 2500;
GW_MINLOCKTIME = 3;
GW_LOCKON_TOLERANCE = 10; // Difference in angle needed to acquire target

// Deployable items
GW_MAXDEPLOYABLES = 20;

// Render distance of effects
GW_EFFECTS_RANGE = 3000;

// Value modifier for killed vehicles
GW_KILL_VALUE = 0.5;
GW_KILL_EMPTY_VALUE = 0.1;

// % Chance of eject system failing
GW_EJECT_FAILURE = 15;

// Default start balance
GW_INIT_BALANCE = 500;

// Icon Compile
call compile preprocessFile 'global\icons.sqf';

// Vehicle Data Compile
call compile preprocessFile 'global\vehicles.sqf';

// Object Data Compile
call compile preprocessFile 'global\objects.sqf';

// Available spawn areas
GW_VALID_ZONES = [
	
	'swamp',
	'airfield',
	'downtown',
	'wasteland',
	'saltflat'
];

// Default locked vehicles
GW_LOCKED_ITEMS = [
	
	"I_MRAP_03_F",
	"O_MRAP_02_F",
	"B_MRAP_01_F",

	"B_Truck_01_mover_F",
	"B_Truck_01_transport_F",
	"O_Truck_03_transport_F",
	"I_Truck_02_transport_F",

	"C_Kart_01_F",
	"C_SUV_01_F",
	"C_Van_01_box_F",
	"C_Offroad_01_F"

];

// Objects that cant be cleared by clearPad
GW_UNCLEARABLE_ITEMS = [

    'Land_spp_Transformer_F',
    'Land_HelipadSquare_F',
    'Land_File1_F',
    'Camera',
    'HouseFly',
    'Mosquito',
    'HoneyBee',
    '#mark',
    '#track',
    'Land_Bucket_painted_F',
    'UserTexture1m_F',
    'SignAd_Sponsor_ARMEX_F',
    'Land_Tyres_F'

];

GW_PROTECTED_ITEMS = [

	'Land_PaperBox_closed_F'
	
];

// Objects that cant be tilted (due to various bugs)
GW_TILT_EXCLUSIONS = [
	"Land_New_WiredFence_5m_F",
	"B_HMG_01_A_F",
	"B_GMG_01_A_F",
	"B_static_AT_F",
	"B_Mortar_01_F",
	"Land_Runway_PAPI",
	"launch_NLAW_F",
	"launch_RPG32_F",
	"srifle_LRR_LRPS_F",
	"Land_WaterTank_F"
];

// Weapons that use the lock-on mechanic
GW_LOCKONWEAPONS = [
	'MIS',
	'MOR'
];

// Weapons reference
GW_WEAPONSARRAY = [
	'HMG',
	'GMG',	
	'MOR',
	'RPG',
	'MIS',
	'GUD',
	'LSR',
	'RLG'
];

// Weapons that use groundWeaponsHolder 
GW_HOLDERARRAY = [
	'launch_NLAW_F',
	'launch_RPG32_F',
	"srifle_LRR_LRPS_F",
	"srifle_GM6_F"
];

// Modules with an action menu ability
GW_TACTICALARRAY = [
	'SMK',
	'NTO',
	'OIL',
	'REP',
	'DES',
	'EMP',
	'PAR',
	'CAL',
	'SHD',
	'FLM',	
	'THR',
	'MIN',
	'EPL',
	'CLK',
	'MAG',
	'GRP'
];

// Modules without an action menu, but that still do something
GW_SPECIALARRAY = [
	'IND',
	'EXP'
];

// Texture selection config for specific vehicles
GW_TEXTURES_SPECIAL = [
	
	['C_SUV_01_F', [""]],
	['B_Truck_01_mover_F', ["B_Truck_01_mover_F", "default"] ],
	['B_Truck_01_transport_F', ["B_Truck_01_mover_F", "default"] ],
	["I_Truck_02_transport_F", ["default", "default"] ],
	['C_Hatchback_01_sport_F', [""]],
	['C_Van_01_transport_F', ["", "default"]]
];

// Available textures
GW_TEXTURES_LIST = [
	'Blue',
	'Digital',
	'Fire',
	'Green',
	'Leafy',
	'Red',
	'Safari',
	'White',
	'Yellow'
];

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

// Returns reload and cost data requested tag
getTagData = {

	switch (_this select 0) do {
		
		// Tactical
		case "SMK": {  [15, 0]	};
		case "SHD":	{  [60, 0]	};
		case "NTO":	{  [0.75, 0.04] };
		case "THR":	{  [0.1, 0.05] };
		case "OIL":	{  [15, 0.004]	};
		case "REP":	{  [60, 0]	};
		case "DES":	{  [0, 0]	};
		case "EMP":	{  [30, 0]	};
		case "MIN":	{  [30, 0.2] };
		case "PAR":	{  [10, 0]	};
		case "CLK":	{  [0, 0.08] };
		case "MAG":	{  [60, 0]	};
		case "GRP":	{  [1, 0]	};
		case "CAL":	{  [30, 0.1] };
		case "EPL":	{  [0, 0]	};

		// Weapons
		case "HMG": {  [0.1, 0.001]	};
		case "GMG":	{  [1.5, 0.06] };
		case "RPG":	{  [3, 0.03] };
		case "GUD":	{  [20, 0.2] };
		case "MIS":	{  [10, 0.2] };	
		case "MOR":	{  [2.5, 0.05] };
		case "RLG":	{  [15, 0.25] };
		case "LSR":	{  [3, 0.05] };		

		default
		{
			[0,0]
		};

	};

};


// Zone Functions
parseZones = compile preprocessFile 'client\zones\parse_zones.sqf';
call compile preprocessFile "client\customization\supply_box.sqf";

// Event Handlers
handleDamageVehicle = compile preprocessFile 'client\vehicles\handlers\handle_damage.sqf';
handleExplosionVehicle = compile preprocessFile 'client\vehicles\handlers\handle_explosion.sqf';
handleContactVehicle = compile preprocessFile 'client\vehicles\handlers\handle_contact.sqf';
handleHitVehicle = compile preprocessFile 'client\vehicles\handlers\handle_hit.sqf';
handleKilledVehicle = compile preprocessFile 'client\vehicles\handlers\handle_killed.sqf';
handleGetIn = compile preprocessFile 'client\vehicles\handlers\handle_getin.sqf';
handleGetOut = compile preprocessFile 'client\vehicles\handlers\handle_getout.sqf';

// Object Functions
destroyObj = compile preprocessFile "client\objects\destroy.sqf";
createObject = compile preprocessFile "server\objects\create_object.sqf";
setPitchBankYaw = compile preprocessFile 'global\functions\setPitchBankYaw.sqf';

// Event Handlers
handleDamageObject = compile preprocessFile 'client\objects\handlers\handle_damage.sqf';
handleExplosionObject = compile preprocessFile 'client\objects\handlers\handle_explosion.sqf';
handleContactObject = compile preprocessFile 'client\objects\handlers\handle_contact.sqf';
handleHitObject = compile preprocessFile 'client\objects\handlers\handle_hit.sqf';
handleKilledObject = compile preprocessFile 'client\objects\handlers\handle_killed.sqf';
handleTakeObject = compile preprocessFile 'client\objects\handlers\handle_take.sqf';
handleDisassembledObject = compile preprocessFile 'client\objects\handlers\handle_disassembled.sqf';

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

// Utility
limitToRange = compile preprocessFile 'global\functions\limitToRange.sqf';
getHitPoints = compile preprocessFile 'global\functions\getHitPoints.sqf';
hasType = compile preprocessFile 'global\functions\hasType.sqf';
positionToString = compile preprocessFile 'global\functions\positionToString.sqf';
checkOwner = compile preprocessFile 'global\functions\checkOwner.sqf';
shareVehicle = compile preprocessFile 'global\functions\shareVehicle.sqf';

// Numerical
flipDir = compile preprocessFile 'global\functions\flipDir.sqf';
normalizeAngle = compile preprocessFile 'global\functions\normalizeAngle.sqf';
flattenAngle = compile preprocessFile 'global\functions\flattenAngle.sqf';
padZeros = compile preprocessFile 'global\functions\padZeros.sqf';

// Vehicle Functions 
call compile preprocessFile 'client\vehicles\functions.sqf';
compileAttached = compile preprocessFile "client\vehicles\compile_attached.sqf";
setVehicleTexture = compile preprocessFile 'client\vehicles\set_vehicle_texture.sqf';
removeVehicleStatus = compile preprocessFile "global\functions\removeVehicleStatus.sqf";
addVehicleStatus = compile preprocessFile "global\functions\addVehicleStatus.sqf";
checkTyres = compile preprocessFile 'global\functions\checkTyres.sqf';
checkEject = compile preprocessFile 'global\functions\checkEject.sqf';

// Pre-compile location arrays
reloadAreas = ['reloadArea'] call findAllObjects;
repairAreas = ['repairArea'] call findAllObjects;
refuelAreas = ['refuelArea'] call findAllObjects;
saveAreas = ['saveArea'] call findAllObjects;
tempAreas = ['tempArea'] call findAllObjects;
spawnAreas = ['spawnArea'] call findAllObjects;
buySigns = ['buySign'] call findAllObjects;
vehicleTerminals = ['vehicleTerminal'] call findAllObjects;