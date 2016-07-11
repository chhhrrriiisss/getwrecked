//
//
//
//		Game configuration variables
//
//
//

//
//		!
//
//		PLEASE NOTE: Most of these settings are currently non functional. Changing them is very likely to cause issues. A full server-side configuration tool that doesn't require a pbo unpack is in the pipeline and will be implemented in a future version.
//		
//		!
//

// Set to true for enhanced debugging/logging 
GW_DEV_BUILD = false;

// Change this to any other unique identifier if you want player progression (money/vehicles/races) to be unique to this server
// NOTE: this is in no way secure — and easily tampered with but makes a simple adjustement to the location of info stored in profilenamespace
GW_PROFILE_LOCATION = "GW086";

GW_LOCATION_TAG = if (GW_DEV_BUILD) then { 'GWDEV' } else { GW_PROFILE_LOCATION };

// Game mode setting (0 = Standard, 1 = Creative)
GW_GAME_MODE = 0;
GW_ITEM_COST = 1;

// Spawn timer in seconds (default: 120)
GW_RESPAWN_DELAY = 120;

// Object respawn settings (default: 3, .5)
GW_OBJECT_ABANDON_DELAY = 3;
GW_OBJECT_DEAD_DELAY = .5;

// How quickly vehicle status indicator for damage should update for each client (higher = better stability in mp)
GW_DAMAGE_UPDATE_INTERVAL = 0.1;

// Enable vehicle armor to balance all vehicles (default: true)
GW_ARMOR_SYSTEM_ENABLED = true;

// Weapon Damage vs vehicles 
GW_GDS = 0.08; // Damage modifier while in a battle (default: 0.08)
GW_GDS_RACE = 0.16; // Damage modifier while in a race (default: 0.2)

// Weapon Damage vs objects
GW_GHS = 4; // Damage modifier weapons vs items (default: 4)

// Generic damage modifiers
OBJ_COLLISION_DMG_SCALE = 0;
WHEEL_COLLISION_DMG_SCALE = 0; 
COLLISION_DMG_SCALE = 0; 
FIRE_DMG_SCALE = 6; 

// Melee weapon global modifiers
GW_GMM = 2.5;
GW_MELEE_DEGRADATION = 7;


// Melee Damage Frequency (default: 1)
// How often the system checks for intersections (too often means more lag yo)
GW_COLLISION_FREQUENCY = 1;

// Global armor modifier (default: 32)
// This is a multiplier based off of the Offroad vehicle's stock armor
// It is very sensitive and doesn't work the way you think
GW_GAM = 32;

// Lock on properties
GW_MINLOCKRANGE = 100; // (default: 100)
GW_MAXLOCKRANGE = 1700; // (default: 2500)
GW_MINLOCKTIME = 3; // Minimum amount of time to lock onto a target (default: 3)
GW_LOCKON_TOLERANCE = 10; // Difference in angle needed to acquire target (default: 10)

// Deployable items
GW_MAXDEPLOYABLES = 25; // Per player (default :25)

// Render distance of effects 
GW_WORKSHOP_VISUAL_RANGE = 300; // ViewDistance while in workshop (default: 300)
GW_EFFECTS_RANGE = 1000; // Increasing this may add lag at the workshop/airfield (default: 1000)

// Default player start balance
GW_INIT_BALANCE = 10000; // (Default: 5000)

// Value modifier for killed vehicles
GW_KILL_VALUE = 0.5; // How much of the vehicles value should the killer get? (default: 0.5)
GW_KILL_EMPTY_VALUE = 0.1; // Value of killing a vehicle with noone in it

// Money earnt in zone
GW_IN_ZONE_VALUE = 200;

// Limit for supply boxes
GW_INVENTORY_LIMIT = 100; // (Default: 40)

// Supply Crates
GW_EVENTS_FREQUENCY = [(3 * 60),(2* 60),(60)]; // Frequency to perform checks for events (low/med/high pop) (default: 60, 50, 40)
GW_SUPPLY_ACTIVE = 0; // Dont change this
GW_SUPPLY_MAX = 30; // Maximum number of supply drops active at once (default: 30)
GW_SUPPLY_CLEANUP = (3*60); // Timeout before cleaning up supply drop (default: (3*60) )

// AI
// [This doesn't do anything special right now]
GW_AI_MAX = 3;
GW_AI_ACTIVE = [];

// Misc
// This limits how big loaded vehicles can be. It's quite important to stop people spawning in tampered vehicles that could break a server.
GW_MAX_DATA_SIZE = 8000; // Max packet size (in characters) that can be loaded (loadVehicle or saveVehicle will not work if this is too large)

//
//	 If you edit below here, this is where shit gets dicey
//	

// Profile library location
GW_LIBRARY_LOCATION = format['%1_LIBRARY', GW_LOCATION_TAG];

// Profile races location
GW_RACES_LOCATION = format['%1_RACES', GW_LOCATION_TAG];
GW_RACES_VERSION_LOCATION = format['%1_RACES_VERSION', GW_LOCATION_TAG];

// Profile unlocks location
GW_UNLOCKED_ITEMS_LOCATION = format['%1_UNLOCKED_ITEMS', GW_LOCATION_TAG];

// Profile binds location
GW_BINDS_LOCATION = format['%1_BINDS', GW_LOCATION_TAG];
GW_BINDS_VERSION_LOCATION = format['%1_BINDS_VERSION', GW_LOCATION_TAG];

// Profile balance location
GW_BALANCE_LOCATION = format['%1_BALANCE', GW_LOCATION_TAG];

// Leaderboard stats tracking (default: false)
GW_LEADERBOARD_ENABLED = false;

// Player global statistics tracking (default: true)
GW_GLOBAL_STATS_ENABLED = false;

// Whether or not zone boundaries should be visible
GW_BOUNDARIES_ENABLED = true;

GW_MAX_PLAYERS = 16;

// Returns damage of projectile vs vehicle
vehicleDamageData = {
	
	private ['_d'];

	_d = _this call {
		if (_this == "B_65x39_Caseless") exitWith { ((random 0.25) + 0.75) };
		if (_this == "B_35mm_AA_Tracer_Yellow" ||
			_this == "B_35mm_AA_Tracer_Red" ||
			_this == "B_35mm_AA_Tracer_Green" || 
			_this == "B_35mm_AA") exitWith { ((random 0.25) + 0.75) };
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
	
	_globalDamage = if (GW_CURRENTZONE == "globalZone") then { GW_GDS_RACE } else { GW_GDS };
	(_d * _globalDamage)
};

// Returns damage of projectile vs object
objectDamageData = {
	
	private ['_d'];

	_d = _this call {
		if (_this == "B_65x39_Caseless") exitWith { ((random 5) + 5) };
		if (_this == "680Rnd_35mm_AA_shells_Tracer_Yellow") exitWith { ((random 5) + 5) };
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

GW_AREAS = {	
	private ['_allZones'];
	_allZones = +GW_VALID_ZONES;
	_allZones append GW_ACTIVE_RACES;
	_allZones
};

// Available arenas and game type
GW_VALID_ZONES = [
	
	['swamp', 'battle', 'Swamp'],
	['airfield', 'battle', 'Airfield'],
	['downtown', 'battle', 'Downtown'],
	['wasteland', 'battle', 'Wasteland'],
	['saltflat', 'battle', 'Salt Flat'],
	['workshop', 'safe', 'Workshop']
];

// Active races and race hosts
GW_ACTIVE_RACES = [

];

// Objects that cant be cleared by clearPad
GW_UNCLEARABLE_ITEMS = [
    'Land_spp_Transformer_F',
    'Land_HelipadSquare_F',
    'Land_File1_F',
    'Intel_File1_F',
    'Camera',
    'HouseFly',
    'Mosquito',
    'HoneyBee',
    '#mark',
    '#track',
    'Land_Bucket_painted_F',
    'UserTexture1m_F',
    'SignAd_Sponsor_ARMEX_F',    
    'Land_Tyres_F',
    ''
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
	['O_truck_02_fuel_f', ["default", "default"] ],
	['B_APC_Tracked_01_AA_F', ["default", "default", "default"] ]
	
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
	'sparta',
	'china',
	'leeroy',
	'banana'
];

// Specific map configs
switch (worldName) do {
	
	case "Altis":
	{
		// Render distance of effects
		GW_EFFECTS_RANGE = 1000; 

		if (isServer) then {

			// Cleanup lag inducing clusterfuck of houses in Kavala
			_objects = (getMarkerPos "downtownZone_camera") nearObjects 1500;  
			_objectsToHide = [
				"Land_WIP_F",
				"Land_Offices_01_V1_F",
				"Land_i_Barracks_V2_F",
				"Land_Unfinished_Building_01_F",
				"Land_i_House_Small_02_V2_F", 
				"Land_u_Shop_02_V1_F", 
				"Land_i_Shop_02_V1_F",
				"Land_i_Shop_01_V1_F",
				"Land_Chapel_V1_F",
				"Land_i_House_Big_02_V1_F",
				"Land_i_House_Big_02_V2_F",
				"Land_i_House_Big_01_V2_F",
				"Land_i_Addon_02_V1_F"
			];

			_c = 0;
			{      
				if (typeof _x in _objectsToHide) then {
					_x hideObjectGlobal true; 					
					_c = _c + 1;
				};
				_x enableSimulationGlobal false; 
				false
			} count _objects; 
		};
	};


	case "Stratis":
	{

		// Render distance of effects
		GW_EFFECTS_RANGE = 1000; 

		// Available arenas and game type
		GW_VALID_ZONES = [
			['airbase', 'battle', 'Airbase'],
			['peninsula', 'battle', 'Peninsula'],
			['beach', 'battle', 'Beach'],
			['workshop', 'safe', 'Workshop']
		];

		// Cleanup unwanted buildings from workshop
		if (isServer) then {

			_objectsToClear = ['Land_Cargo_House_V1_F', 'Land_Cargo_Patrol_V1_F', 'Land_MilOffices_V1_F']; 
			_objects = (getMarkerPos "workshopZone_camera") nearObjects 200;    

			{   
				_cui = _x getVariable ['GW_CU_IGNORE', false];   
				if ((typeof _x in _objectsToClear) && !_cui) then { hideObjectGlobal _x; };    
				false
			} count _objects; 

			_objectsToClear = nil;
		};

		

	};


	case "Tanoa":
	{
		// Render distance of effects
		GW_EFFECTS_RANGE = 1000; 

		// Available arenas and game type
		GW_VALID_ZONES = [			
			['terminal', 'battle', 'Terminal'],
			['city', 'battle', 'City'],
			['port', 'battle', 'Port'],
			['quarry', 'battle', 'Quarry'],
			// ['crater', 'battle', 'Crater'],
			['plantation', 'battle', 'Plantation'],
			['workshop', 'safe', 'Workshop']
		];

		if (isServer) then {

			// Cleanup lag inducing clusterfuck of houses in Kavala
			_objects = (getMarkerPos "cityZone_camera") nearObjects 2000;  
			_workshopObjects = (getMarkerPos "workshopZone_camera") nearObjects 500; 
			_objects append _workshopObjects;

			_objectsToHide = [
				"Land_PowerLine_01_wire_50m_F",
				"Land_PowerLine_01_wire_50m_main_F",
				"Land_PowerLine_01_pole_tall_F",
				"Land_LampShabby_F",
				"Land_SignCommand_01_stop_F",
				"Land_PowerLine_01_pole_small_F",
				"Land_Sign_01_sharpBend_left_F",
				"Land_Sign_01_sharpBend_right_F",
				"Land_QuayConcrete_01_20m_F",
				"Land_SignCommand_01_priority_F",
				"Land_Shed_02_F",
				"Land_Slum_03_F",
				"Land_Shed_04_F",
				"Land_Shed_05_F",
				"Land_Slum_04_F",
				"Land_House_Small_02_F",
				"Land_LampStreet_small_F",
				"Land_LampStreet_F",
				"Land_Cathedral_01_F",
				"Land_FireEscape_01_tall_F",
				"Land_dp_transformer_F",
				"Land_dpp_01_transformer_F",
				"Land_dpp_01_waterCooler_F",
				"Land_DPP_01_smallFactory_F"
			];			

			_c = 0;
			{      
				if (typeof _x in _objectsToHide) then {
					_x hideObjectGlobal true; 					
					_c = _c + 1;
				};
				_x enableSimulationGlobal false; 
				false
			} count _objects; 
		};


		

	};

	default {};
};

