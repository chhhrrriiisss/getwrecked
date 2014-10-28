// 0 Class Name, 1 Name, 2 Mass, 3 Health, 4 Ammo, 5 Fuel, 6 Module 7 Description 8 Rarity

GW_LOOT_LIST = [	

	// Building Supplies 

	["Land_CnCBarrier_stripes_F", "Concrete Barrier", 600, 6, 0, 0, '', "", 0, barrierIcon],
	["Land_BagFence_Short_F", "Sandbag", 200, 4, 0, 0, '', "", 0, sandbagsIcon],
	["Land_BagFence_Long_F", "Long Sandbag", 400, 4, 0, 0, '', "", 0, sandbagsIcon],
	["Land_BagFence_Round_F", "Curved Sandbag", 500, 4, 0, 0, '', "", 1, sandbagsIcon],
	["Land_Wall_Tin_4", "Light Metal Sheet", 150, 4, 0, 0, '', "", 0.1, metalfenceIcon],
	["Land_Wall_IndCnc_2deco_F", "Large Steel Panel", 1500, 20, 0, 0, '', "", 1, steelPanelIcon],
	["Land_CnCBarrierMedium4_F", "Long Concrete Wall", 8000, 12, 0, 0, '', "", 1, concretebarrierlargeIcon],
	["Land_CnCBarrierMedium_F", "Short Concrete Wall", 2000, 4, 0, 0, '', "", 0.2, concretebarrierIcon],
	["Land_Shoot_House_Wall_Prone_F", "Plywood Barrier", 50, 3, 0, 0, '', "", 0, plywoodIcon],
	["Land_Shoot_House_Corner_Crouch_F", "Plywood Corner", 50, 3, 0, 0, '', "", 0, plywoodIcon],
	["Land_Shoot_House_Wall_Crouch_F", "Plywood Wall", 50, 6, 0, 0, '', "", 0, plywoodIcon],
	["Land_Pallets_F", "Wooden Pallets", 50, 2, 0, 0, '', "", 0, palletsIcon],
	["Land_Pallet_vertical_F", "Vertical Wooden Pallets", 50, 2, 0, 0, '', "", 0.1, palletsIcon],
	["Land_New_WiredFence_5m_F", "Wired Fence", 100, 6, 0, 0, '', "", 0.25, wirefenceIcon],

	// Weapons

	["B_HMG_01_A_F", "HMG .50 Cal", 400, 9999, 0, 0, 'HMG', "High calibre machine gun", 0.1, hmgIcon],
	["B_GMG_01_A_F", "GMG 20mm HE", 500, 9999, 0, 0, 'GMG', "High explosive grenade launcher", 0.3, gmgIcon],
	["B_static_AT_F", "Lock-On Missile Launcher", 1000, 9999, 0, 0, 'MIS', "Fires heat seeking missiles", 1, lockonIcon],
	["B_Mortar_01_F", "Mk6 Mortar", 750, 9999, 0, 0, 'MOR', "Heat seeking mounted mortar", 0.1, mortarIcon],
	["Land_Runway_PAPI", "Tactical Laser", 400, 9999, 0, 0, 'LSR', "High Energy Laser", 0.9, laserIcon],
	["launch_NLAW_F", "Guided Missile", 750, 9999, 0, 0, 'GUD', "Guided Missile", 1, guidedIcon], 
	["launch_RPG32_F", "Rocket Launcher", 750, 9999, 0, 0, 'RPG', "Rocket Launcher", 0.3, rpgIcon],
	["srifle_LRR_LRPS_F", "SR2 Railgun", 750, 9999, 0, 0, 'RLG', "Railgun", 1, railgunIcon],

	// Fuel

	["Land_MetalBarrel_F", "Large Fuel Tank",  1500, 8, 0, 3, '', "", 0.4, fuelIcon],	
	["Land_CanisterPlastic_F", "Fuel Tank",  500, 4, 0, 1, '', "", 0.2, fuelIcon],
	["Land_CanisterFuel_F", "Small Fuel Container",  250, 4, 0, 0.5, '', "", 0.1, fuelIcon],

	// Ammo

	["Box_NATO_Ammo_F", "Small Ammo Box", 500, 8, 1, 0, '', "", 0.2, ammoIcon],
	["Box_Nato_AmmoVeh_F", "Large Ammo Container",  2000, 16, 4, 0, '', "", 0.8, ammoIcon],

	// Special

	["Box_East_AmmoOrd_F", "Incendiary Ammo", 500, 8, 0.3, 0, 'IND', "Hit vehicles will be set alight", 1, flameIcon],
	["Box_IND_Grenades_F", "HE Ammo", 500, 8, 0.3, 0, 'EXP', "Projectiles have a small explosive effect", 1, minesIcon],		

	// Tactical	

	["Land_Portable_generator_F", "Nitro Booster",  125, 8, 0, 0, 'NTO', "Increases vehicle speed temporarily", 0.5, nitroIcon],
	["Land_FireExtinguisher_F", "Smoke Generator",  50, 5, 0, 0, 'SMK', "Generates white smoke", 0.25, smokeIcon],
	["Land_WaterTank_F", "Oil Slick",  500, 10, 0, 1, 'OIL', "", 0.2, oilslickIcon],
	["Land_PowerGenerator_F", "Emergency Repair Device",  1000, 10, 0, 0, 'REP', "Instantly repairs the vehicle", 0.6, emergencyRepairIcon],
	["Land_Device_assembled_F", "Self Destruct System",  400, 30, 0, 0, 'DES', "", 0.8, warningIcon],
	["Land_BarrelEmpty_grey_F", "Vertical Thruster",  50, 8, 0, 0, 'THR', "Activates a short burst of downward force", 0.6, thrusterIcon],
	["Land_BarrelEmpty_F", "Cloaking Device",  50, 8, 0, 0, 'CLK', "Temporarily gives the vehicle near-invisibility", 1, cloakIcon],
	["Land_Suitcase_F", "EMP Device",  50, 8, 0, 0, 'EMP', "Deploys a pulse that disables vehicles", 0.7, empIcon],
	["Land_Sack_F", "Eject System",  5, 500, 0, 0, 'PAR', "Ejects the driver and deploys a parachute", 0.2, ejectIcon],
	["Land_WoodenBox_F", "Caltrops",  5, 500, 0, 0, 'CAL', "Drops road spikes that disable tyres", 0.25, caltropsIcon],
	["Land_Sacks_heap_F", "Bag of Explosives",  5, 500, 0, 0, 'EPL', "Deploys an especially large bag of explosives", 0.1, warningIcon],
	["Land_FoodContainer_01_F", "Proximity Mines",  5, 500, 0, 0, 'MIN', "Drops a handful of mines", 0.7, minesIcon],
	["Box_IND_Wps_F", "Shield Generator",  5, 500, 0, 0, 'SHD', "Shield that grants temporary invulnerability", 1, shieldIcon],
	["Land_Coil_F", "Magnetic Coil",  5, 6000, 0, 0, 'MAG', "Deploys a magnetic pulse that pulls in vehicles", 1, magneticIcon]

];