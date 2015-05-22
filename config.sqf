//
//
//
//		Game configuration variables
//
//
//

// Leaderboard stats tracking (default: false)
// Currently non-functional
GW_LEADERBOARD_ENABLED = false;

// Game mode setting (0 = Standard, 1 = Creative)
GW_GAME_MODE = (paramsArray select 0);
GW_ITEM_COST = (paramsArray select 7);

// Spawn timer in seconds (default: 30)
GW_RESPAWN_DELAY = (paramsArray select 1);

// Object respawn settings (default: 3, .5)
GW_OBJECT_ABANDON_DELAY = 3;
GW_OBJECT_DEAD_DELAY = .5;

// How quickly vehicle status indicator for damage should update for each client (higher = better stability in mp)
GW_DAMAGE_UPDATE_INTERVAL = 0.1;

// Enable vehicle armor to balance all vehicles (default: true)
GW_ARMOR_SYSTEM_ENABLED = if ((paramsArray select 5) == 1) then { true } else { false };

// Weapon Damage vs vehicles 
GW_GDS = 0.03; 
WHEEL_COLLISION_DMG_SCALE = 0; 
COLLISION_DMG_SCALE = 0; 
FIRE_DMG_SCALE = 8; 

// Weapon Damage vs objects
GW_GHS = 4;
OBJ_COLLISION_DMG_SCALE = 0;

// Melee Damage Frequency
GW_COLLISION_FREQUENCY = 1;

// Global armor modifier
GW_GAM = 32;

// Lock on properties
GW_MINLOCKRANGE = 100; // (default: 100)
GW_MAXLOCKRANGE = 1700; // (default: 2500)
GW_MINLOCKTIME = 3; // Minimum amount of time to lock onto a target (default: 3)
GW_LOCKON_TOLERANCE = 10; // Difference in angle needed to acquire target (default: 10)

// Deployable items
GW_MAXDEPLOYABLES = (paramsArray select 6); // Per player (default :50)

// Render distance of effects
GW_EFFECTS_RANGE = 1700; // Increasing this may add lag at the workshop (default: 1700)

// % Chance of eject system failing
GW_EJECT_FAILURE = 15;

// Default player start balance
GW_INIT_BALANCE = (paramsArray select 2); // (Default: 5000)

// Value modifier for killed vehicles
GW_KILL_VALUE = ((paramsArray select 4) / 100); // How much of the vehicles value should the killer get? (default: 0.5)
GW_KILL_EMPTY_VALUE = 0.1;

// Money earnt in zone
GW_IN_ZONE_VALUE = (paramsArray select 3);

// Limit for supply boxes
GW_INVENTORY_LIMIT = 100; // (Default: 40)

// Supply Crates
GW_EVENTS_FREQUENCY = [(3 * 60),(2* 60),(60)]; // Frequency to perform checks for events (low/med/high pop) (default: 60, 50, 40)
GW_SUPPLY_ACTIVE = 0; // Dont change this
GW_SUPPLY_MAX = 30; // Maximum number of supply drops active at once (default: 30)
GW_SUPPLY_CLEANUP = (3*60); // Timeout before cleaning up supply drop (default: (3*60) )

// Misc
GW_MAX_DATA_SIZE = 8000; // Max packet size (in characters) that can be loaded (loadVehicle or saveVehicle will not work if this is too large)

// Cleanup timer settings
GW_CLEANUP_RATE = (paramsArray select 8);

/*	
	If you edit below here, I hope you know what you're doing...
*/

GW_MAX_PLAYERS = 12;

// Returns damage of projectile vs vehicle
vehicleDamageData = {
	
	private ['_d'];

	_d = _this call {

		if (_this == "R_PG32V_F" || _this == "RPG") exitWith { ((random 0.075) + 0.05) };
		if (_this == "M_Titan_AT_static" || _this == "RPD") exitWith { ((random 0.05) + 0.01) };			
		if (_this == "M_PG_AT" || _this == "GUD") exitWith { 0 };
		if (_this == "M_Titan_AT" || _this == "MIS") exitWith { 0 };
		if (_this == "M_Titan_AA_static" || _this == "RLG") exitWith { ((random 0.5) + 1.5) };
		if (_this == "B_127x99_Ball_Tracer_Red" || _this == "LSR") exitWith { 0 };
		if (_this == "B_127x99_Ball" || _this == "HMG") exitWith { 0.75 };
		if (_this == "B_127x99_Ball_Tracer_Yellow") exitWith { 0.25 };
		if (_this == "R_TBG32V_F" || _this == "MOR") exitWith { 0.7 };
		if (_this == "G_40mm_HEDP" || _this == "GMG") exitWith { ((random 0.05) + 0.27) };
		if (_this == "Bo_GBU12_LGB" || _this == "EXP") exitWith { 0 };
		if (_this == "M_AT") exitWith { 0 };
		0
	};	
	
	(_d * GW_GDS)
};

// Returns damage of projectile vs object
objectDamageData = {
	
	private ['_d'];

	_d = _this call {

		if (_this == "R_PG32V_F" || _this == "RPG") exitWith { 10 };
		if (_this == "M_PG_AT" || _this == "RPD") exitWith { 8 };
		if (_this == "M_Titan_AT" || _this == "GUD" || _this == "MIS") exitWith { 20 };
		if (_this == "M_Titan_AA_static" || _this == "RLG") exitWith { 20 };
		if (_this == "B_127x99_Ball_Tracer_Red" || _this == "LSR") exitWith { 4 };
		if (_this == "B_127x99_Ball" || _this == "HMG") exitWith { 6 };
		if (_this == "B_127x99_Ball_Tracer_Yellow") exitWith { 1 };
		if (_this == "R_TBG32V_F" || _this == "MOR") exitWith { 40 };
		if (_this == "G_40mm_HEDP" || _this == "GMG") exitWith { 15 };
		if (_this == "Bo_GBU12_LGB" || _this == "EXP") exitWith { 40 };
		if (_this == "M_AT") exitWith { 0 };
		0
	};	
	
	(_d * GW_GHS)
};

// Available arenas and game type
GW_VALID_ZONES = [
	
	['swamp', 'battle', 'Swamp'],
	['airfield', 'battle', 'Airfield'],
	['downtown', 'battle', 'Downtown'],
	['wasteland', 'battle', 'Wasteland'],
	['drylake', 'battle', 'Dry Lake'],
	// ['highway', 'race'], 
	['workshop', 'safe', 'Workshop']
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

// Texture selection config for specific vehicles
GW_TEXTURES_SPECIAL = [	
	['C_SUV_01_F', [""]],
	['B_Truck_01_mover_F', ["B_Truck_01_mover_F", "default"] ],
	['B_Truck_01_transport_F', ["B_Truck_01_mover_F", "default"] ],
	["I_Truck_02_transport_F", ["default", "default"] ],
	['C_Hatchback_01_sport_F', [""] ],
	['C_Van_01_transport_F', ["", "default"] ],
	['C_Van_01_box_F', ["C_Van_01_transport_F", "default"] ],
	['C_Van_01_fuel_F', ["C_Van_01_transport_F", "default"] ],
	['O_truck_02_fuel_f', ["default", "default"] ]
	
];

GW_SPECIAL_TEXTURES_LIST = [
	'shield',
	'armor',
	'jammer',
	'speed'
];

// Available textures
GW_TEXTURES_LIST = [
	'Blue',
	'Digital',
	'Fire',
	'Leafy',
	'Red',
	'Safari',
	'White',
	'Yellow',
	'Camo',
	'Pink'
];

// Available taunts
GW_TAUNTS_LIST = [
	'toot',
	'horn',
	'squirrel',
	'surprise',
	'batman',
	'hax',
	'headshot',
	'herewego',
	'mlg',
	'party',
	'sparta'
];

// Specific map configs
switch (worldName) do {
	
	case "Stratis":
	{

		// Cleanup unwanted buildings from workshop
		if (isServer) then {

			_objectsToClear = ['Land_Cargo_House_V1_F', 'Land_Cargo_Patrol_V1_F', 'Land_MilOffices_V1_F', 'Land_Shed_Big_F']; 
			_objects = (getMarkerPos "workshopZone_camera") nearObjects 200;    

			{   
				_cui = _x getVariable ['GW_CU_IGNORE', false];   
				if ((typeof _x in _objectsToClear) && !_cui) then { hideObjectGlobal _x; };    
				false
			} count _objects; 

			_objectsToClear = nil;
		};

		// Render distance of effects
		GW_EFFECTS_RANGE = 3500; // Increasing this may add lag at the workshop (default: 1700)

		// Available arenas and game type
		GW_VALID_ZONES = [
			['airbase', 'battle', 'Airbase'],
			['peninsula', 'battle', 'Peninsula'],
			['beach', 'battle', 'Beach'],
			['workshop', 'safe', 'Workshop']
		];

	};

	default {};
};

