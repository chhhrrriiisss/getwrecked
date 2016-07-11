// 0 Class Name, 1 Name, 2 Mass, 3 Health, 4 Ammo, 5 Fuel, 6 Module 7 Description 8 Rarity, 9 Icon, 10 Reload/Cost

GW_LOOT_LIST = [	

	// Building Supplies 

	["Land_CnCBarrier_stripes_F", "Concrete Barrier", 600, 6, 0, 0, 'CBR', "", 0, barrierIcon],
	["Land_BagFence_Short_F", "Sandbag", 200, 10, 0, 0, 'BFS', "", 0, sandbagsIcon],
	["Land_BagFence_Long_F", "Long Sandbag", 400, 11, 0, 0, 'BFL', "", 0, sandbagsIcon],
	["Land_BagFence_Round_F", "Curved Sandbag", 500, 11, 0, 0, 'BFR', "", 1, sandbagsIcon],
	["Land_Wall_Tin_4", "Light Metal Sheet", 150, 6, 0, 0, 'LMS', "", 0.1, metalfenceIcon],
	["Land_Wall_IndCnc_2deco_F", "Large Steel Panel", 1500, 20, 0, 0, 'LSP', "", 1, steelPanelIcon],
	// ["Land_CnCBarrierMedium4_F", "Long Concrete Wall", 8000, 12, 0, 0, '', "", 1, concretebarrierlargeIcon],
	["Land_CnCBarrierMedium_F", "Short Concrete Wall", 2000, 4, 0, 0, 'CNC', "", 0.2, concretebarrierIcon],
	["Land_Shoot_House_Wall_Prone_F", "Plywood Barrier", 50, 0.5, 0, 0, 'PLB', "", 0, plywoodIcon],
	["Land_Shoot_House_Corner_Crouch_F", "Plywood Corner", 50, 0.5, 0, 0, 'PLC', "", 0, plywoodIcon],
	["Land_Shoot_House_Wall_Crouch_F", "Plywood Wall", 50, 1, 0, 0, 'PLW', "", 0, plywoodIcon],
	["Land_Pallets_F", "Wooden Pallets", 50, 2, 0, 0, 'NWP', "", 0, palletsIcon],
	["Land_Pallet_vertical_F", "Vertical Wooden Pallets", 50, 2, 0, 0, 'VWP', "", 0.1, palletsIcon],

	["land_sportground_fence_f", "Chainlink Panel", 200, 7, 0, 0, 'CHL', "", 0.5, caltropsIcon],
	["land_wired_fence_4m_f", "EMP Resistant Fencing", 100, 3, 0, 0, 'EMF', "", 0.8, emfIcon],
	["land_mil_wallbig_4m_f", "Military-Grade Concrete", 2400, 25, 0, 0, 'MCP', "", 0.5, barrierIcon],
	// ["land_wall_indcnc_4_f", "Thick Concrete Wall", 1000, 8, 0, 0, 'TCW', "", 0.5, barrierIcon],

	// Weapons

	["B_HMG_01_A_F", "HMG .50 Cal", 750, 9999, 0, 0, 'HMG', "Heavy machine gun", 0.1, hmgIcon, [0.15, 0.002]],
	["B_GMG_01_A_F", "GMG 20mm HE", 750, 9999, 0, 0, 'GMG', "High explosive grenade launcher", 0.3, gmgIcon, [1,0.025]],
	["B_static_AT_F", "Lock-On Missile Launcher", 750, 9999, 0, 0, 'MIS', "Fires heat seeking missiles", 1, lockonIcon, [10,0.1]],
	["B_Mortar_01_F", "Mk6 Mortar", 750, 9999, 0, 0, 'MOR', "Heat seeking mounted mortar", 0.1, mortarIcon, [3,0.025]],
	["Land_Runway_PAPI", "Tactical Laser", 400, 9999, 0, 0, 'LSR', "High Energy Laser", 0.9, laserIcon, [3,0.05]],
	["launch_NLAW_F", "Guided Missile", 750, 9999, 0, 0, 'GUD', "Guided Missile", 1, guidedIcon, [20,0.15]], 
	["launch_RPG32_F", "Rocket Launcher", 750, 9999, 0, 0, 'RPG', "Rocket Launcher", 0.3, rpgIcon, [3,0.015]],
	["srifle_LRR_LRPS_F", "SR2 Railgun", 750, 9999, 0, 0, 'RLG', "Railgun", 1, railgunIcon, [10,0.15]],
	["Land_DischargeStick_01_F", "Flamethrower", 750, 9999, 0, 0, 'FLM', "Flamethrower", 1, flameIcon, [0.75,0.03]],
	["Land_Pipes_small_F", "Rocket Pods", 750, 9999, 0, 0, 'RPD', "Rocket Pods", 1, rpdIcon, [3,0.05]],
	["srifle_GM6_F", "Harpoon Launcher", 750, 9999, 0, 0, 'HAR', "Harpoon Launcher", 1, harIcon, [10,0]],

	// Melee
	["Land_PalletTrolley_01_khaki_F", "Metal Spikes", 1500, 30, 0, 0, 'FRK', "Medium damage, can capture vehicles", 1, warningIcon, [0,0] ],
	["Land_Obstacle_Saddle_F", "Concrete Pylon", 1200, 20, 0, 0, 'CRR', "Inflicts massive damage", 1, crrIcon, [0,0] ],
	// ["Land_enginecrane_01_f", "Hydraulic Hook", 800, 15, 0, 0, 'HOK', "Light damage, but can snare vehicles", 1, warningIcon, [0,0] ],
	["Land_WoodPile_large_F", "Wooden Battering Ram", 2000, 40, 0, 0, 'WBR', "An improvised smashing thing.", 1, plywoodIcon, [0,0] ],


	// Fuel

	["Land_MetalBarrel_F", "Large Fuel Tank",  1500, 20, 0, 3, 'LFT', "", 0.4, fuelIcon],	
	["Land_CanisterPlastic_F", "Fuel Tank",  500, 12, 0, 1, 'LFM', "", 0.2, fuelIcon],
	["Land_CanisterFuel_F", "Small Fuel Container",  250, 8, 0, 0.5, 'LFS', "", 0.1, fuelIcon],

	// Ammo

	["Box_NATO_Ammo_F", "Small Ammo Box", 500, 20, 1, 0, 'SAC', "", 0.2, ammoIcon],
	["Box_Nato_AmmoVeh_F", "Large Ammo Container",  2000, 30, 4, 0, 'LAC', "", 0.8, ammoIcon],

	// Special

	["Box_East_AmmoOrd_F", "Incendiary Ammo", 500, 8, 0.3, 0, 'IND', "Hit vehicles will be set alight", 1, flameIcon],
	//["Box_IND_Grenades_F", "HE Ammo", 500, 8, 0.3, 0, 'EXP', "Projectiles have a small explosive effect", 1, minesIcon],	

	// Tactical	
	// ["", "Frequency Jammer",  125, 8, 0, 0, 'JMR', "Disables electronics in it's area", 0.5, warningIcon],
	["Land_Portable_generator_F", "Nitro Booster",  125, 8, 0, 0, 'NTO', "Increases vehicle speed temporarily", 0.5, nitroIcon, [0.75, 0.04] ],
	["Land_FireExtinguisher_F", "Smoke Generator",  50, 5, 0, 0, 'SMK', "Generates white smoke", 0.25, smokeIcon, [15,0] ],
	// ["Land_WaterTank_F", "Oil Slick",  500, 10, 0, 1, 'OIL', "", 0.2, oilslickIcon, [15, 0.004]],
	["Land_PowerGenerator_F", "Emergency Repair System",  1000, 10, 0, 0, 'REP', "Instantly repairs the vehicle", 0.6, emergencyRepairIcon, [60,0] ],
	["Land_Device_assembled_F", "Self Destruct System",  400, 30, 0, 0, 'DES', "", 0.8, warningIcon, [0,0] ],
	["Land_BarrelEmpty_grey_F", "Vertical Thruster",  50, 8, 0, 0, 'THR', "Creates a short burst of exceedingly downward force", 0.6, thrusterIcon, [0.1,0.05] ],
	["Land_BarrelEmpty_F", "Cloaking Device",  50, 8, 0, 0, 'CLK', "Temporarily gives the vehicle near-invisibility", 1, cloakIcon, [0,0.08] ],
	["Land_Suitcase_F", "EMP Device",  50, 8, 0, 0, 'EMP', "Deploys a pulse that disables vehicles", 0.7, empIcon, [60,0] ],
	// ["Land_RotorCoversBag_01_F", "Emergency Parachute",  5, 500, 0, 0, 'PAR', "Deploys a parachute", 0.2, ejectIcon, [10,0] ],
	["Land_WoodenBox_F", "Caltrops",  5, 500, 0, 0, 'CAL', "Drops road spikes that disable tyres", 0.25, caltropsIcon, [30,0.1] ],
	["Land_Sacks_heap_F", "Bag of Explosives",  5, 500, 0, 0, 'EPL', "Deploys an especially big bag of explosives", 0.1, warningIcon, [1,0] ],
	["Land_FoodContainer_01_F", "Proximity Mines",  5, 500, 0, 0, 'MIN', "Drops a handful of mines", 0.7, minesIcon, [30,0.2] ],
	["Box_IND_Wps_F", "Shield Generator",  5, 500, 0, 0, 'SHD', "Shield that grants temporary invulnerability", 1, shieldIcon, [60,0] ],
	["Land_Coil_F", "Magnetic Coil",  5, 6000, 0, 0, 'MAG', "Deploys a magnetic pulse that pulls in vehicles", 1, magneticIcon, [45,0] ],
	["Land_Sleeping_bag_folded_F", "Teleportation Pad",  5, 500, 0, 0, 'TPD', "Drops a teleportation pad", 0.9, tpdIcon, [8,0] ],
	["Land_WaterBarrel_F", "Electromagnet",  5, 2000, 0, 0, 'ELM', "Magical distance minimizer", 0.9, elmIcon, [60,0] ],

	["FlexibleTank_01_forest_F", "Napalm Bomb",  5, 2000, 0, 0, 'NPA', "Drops a rather toasty napalm device", 0.1, flameIcon, [1,0] ]
	
	// ["Land_Sleeping_bag_folded_F", "Limpet Mines",  5, 500, 0, 0, 'LPT', "Drops limpet mines", 0.7, minesIcon],
];


// Weapons that use the lock-on mechanic
GW_LOCKONWEAPONS = [
	'MIS',
	'MOR'
];

// Weapons that can be used for melee
GW_MELEEWEAPONS = [
	'FRK',
	'CRR',
	'HOK',
	'WBR'
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
	'RLG',
	'FLM',
	'HAR',
	'LMG',
	'RPD'
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
	'THR',
	'MIN',
	'EPL',
	'CLK',
	'MAG',
	'TPD',
	'ELM',
	'NPA'
];

// Modules without an action menu entry, but that still do something
GW_SPECIALARRAY = [
	'IND',
	'EXP',
	'FRK',
	'EMF'
];

// Price List and Categories for all loot

// Building
GW_LOOT_BUILDING = [
	["Land_CnCBarrier_stripes_F", 25],
	["Land_BagFence_Short_F", 20],
	["Land_BagFence_Long_F", 40],
	["Land_BagFence_Round_F", 50],
	["Land_Wall_Tin_4", 50],
	["Land_Wall_IndCnc_2deco_F", 200],
	["Land_CnCBarrierMedium4_F", 100],
	["Land_CnCBarrierMedium_F", 25],
	["Land_Shoot_House_Wall_Prone_F", 10],
	["Land_Shoot_House_Corner_Crouch_F", 10],
	["Land_Shoot_House_Wall_Crouch_F", 10],
	["Land_Pallets_F", 20],
	["Land_Pallet_vertical_F", 20],
	["land_sportground_fence_f", 50],
	["land_mil_wallbig_4m_f", 300],
	["land_wall_indcnc_4_f", 200]

];

// Weapons
GW_LOOT_WEAPONS = [
	["B_HMG_01_A_F", 100],
	["B_GMG_01_A_F", 150],
	["B_static_AT_F", 300],
	["B_Mortar_01_F", 200],
	["Land_Runway_PAPI", 400],
	["launch_NLAW_F", 300],
	["launch_RPG32_F", 200],
	["srifle_LRR_LRPS_F", 600],
	["Land_DischargeStick_01_F", 300],
	["srifle_GM6_F", 300],
	["Land_Pipes_small_F", 300],	
	["srifle_GM6_F", 300]
	
];

// Performance
GW_LOOT_PERFORMANCE = [
	["Land_MetalBarrel_F", 300],
	["Land_CanisterPlastic_F", 150],
	["Land_CanisterFuel_F", 75],
	["Land_Portable_generator_F", 100],
	["Box_NATO_Ammo_F", 150], 
	["Box_Nato_AmmoVeh_F", 300]
];

// Incendiary
GW_LOOT_INCENDIARY = [
	["Land_WaterTank_F", 100],
	["Box_East_AmmoOrd_F", 400],
	["Land_FireExtinguisher_F", 100],
	["Land_Runway_PAPI", 400],
	["Land_DischargeStick_01_F", 300],
	["FlexibleTank_01_forest_F", 100]
];

// Electronics
GW_LOOT_ELECTRONICS = [
	["Land_BarrelEmpty_F", 400],
	["Land_Suitcase_F", 200],
	["launch_NLAW_F", 300],
	["Land_Coil_F", 1000],
	["land_wired_fence_4m_f", 350],
	["Land_WaterBarrel_F", 1000]

];

// Deployables
GW_LOOT_DEPLOYABLES = [
	["Land_Sacks_heap_F", 50],
	["Land_WoodenBox_F", 200],
	["Land_FoodContainer_01_F", 500],
	["Land_Sleeping_bag_folded_F", 200],
	["Land_WaterTank_F", 100],
	["FlexibleTank_01_forest_F", 100]
];

// Defense
GW_LOOT_DEFENCE = [
	["Land_PowerGenerator_F", 400],
	["Box_IND_Wps_F", 500],
	["Land_Wall_IndCnc_2deco_F", 200],
	["Land_Device_assembled_F", 250],
	["Land_PalletTrolley_01_khaki_F", 300],
	["land_wired_fence_4m_f", 350],
	["land_mil_wallbig_4m_f", 300]
];

// Evasion
GW_LOOT_EVASION = [
	["Land_Portable_generator_F", 100],
	["Land_RotorCoversBag_01_F", 100],
	["Land_FireExtinguisher_F", 100],
	["Land_BarrelEmpty_grey_F", 100],
	["Land_Device_assembled_F", 250],
	["Land_Sleeping_bag_folded_F", 500]
];

// Melee
GW_LOOT_MELEE = [
	["Land_PalletTrolley_01_khaki_F", 300],
	["Land_Obstacle_Saddle_F", 300],
	["Land_enginecrane_01_f", 500],
	["Land_WoodPile_large_F", 100]
];


GW_LOOT_VEHICLES = [

	// Civilian
	
	["C_Offroad_01_F", 3000],
	["C_SUV_01_F", 5000],
	["C_Van_01_box_F", 1000],
	["C_Hatchback_01_sport_F", 1000],	
	["C_Kart_01_F", 5000],
	["C_Quadbike_01_F", 1000],

	// Trucks
	
	["C_Van_01_box_F", 3000],
	["C_Van_01_fuel_F", 6000],
	["O_truck_02_fuel_f", 14000],
	["O_truck_03_ammo_f", 16000],

	["B_Truck_01_mover_F", 7500],
	["B_Truck_01_transport_F", 10000],
	["O_Truck_03_transport_F", 10000],
	["I_Truck_02_transport_F", 12000],
	["O_Truck_03_repair_F", 20000],

	// Military

	["B_T_LSV_01_unarmed_F", 10000],
	["I_MRAP_03_F", 25000],
	["B_MRAP_01_F", 20000],
	["O_MRAP_02_F", 15000]

];