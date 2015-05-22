//
//    
//		Vehicle Configuration
//      // [0] Class  [1] Display Name [2] (0) 0 Mass Modifier  1 Mass Limit  (1) Max Weapons  (2) Max Modules (3) Max Ammo  (4) Max Fuel  (5) Armor Rating (6) Armor Modifier (7) Radar Signature (8) ? [3] Description
//

GW_VEHICLE_LIST = [	
	
	// Civilian

	["C_Quadbike_01_F", "Quadbike", [ [0.05, 850], 3, 3, 1, 1, 2, 1.1, 'Tiny', 1000 ], 'The quadbike is ideal for fast and stealthy surprise attacks.' ],
	["C_Hatchback_01_sport_F", "Hatchback Sport", [ [0.1, 3000], 3, 4, 1, 2, 3, 1.05, 'Low', 1000 ], 'Although very lightly armoured, this vehicle is fast and difficult to catch.' ],
	["C_Offroad_01_F", "Civilian Offroad", [ [0.2, 99999], 3, 5, 2, 1, 5, 1, 'Low', 1000 ],  'The offroad is an agile, versatile albeit lightly armored utility vehicle.' ],
	["C_SUV_01_F", "SUV", [ [0.1, 3000] , 3, 4, 1, 2, 4, 0.95, 'Low', 1000 ], 'A capable and reliable vehicle with a low radar signature.' ],
	["C_Van_01_transport_F", "Civilian Truck", [ [0.5, 99999], 2, 7, 2, 2, 5, 1, 'Medium', 1000 ], 'Ample storage, fuel and ammo capacity, a great workhorse.' ],	
	["C_Van_01_box_F", "Box Truck", [ [0.5, 99999], 2, 10, 1, 3, 5, 1, 'Large', 1000 ], 'An excellent choice for an especially special delivery.' ],		
	["C_Kart_01_F", "Kart", [ [0.03, 350], 2, 3, 1, 1, 1, 1.1, 'Tiny', 1000 ], 'Extremely quick and hard to hit which makes it quite unpredictable.' ],	

	// Trucks

	["C_Van_01_fuel_F", "Civilian Fuel Truck", [ [0.5, 99999], 2, 4, 1, 10, 4, 1.1, 'Small', 1000 ], 'Surprisingly sturdy unit with extra fuel capacity.' ],
	["O_truck_02_fuel_f", "Zamak Tanker", [ [0.1, 99999], 4, 5, 0.5, 18, 8, 1.1, 'Medium', 1000 ], 'A fuel tank with additional wheels.' ],
	["O_truck_03_ammo_f", "Tempest Ammo", [ [0.1, 99999], 6, 4, 22, 2, 8, 1.15, 'Large', 1000 ], 'For those in need of a fair few bullets.' ],

	["B_Truck_01_mover_F", "HEMTT Mover", [ [0.1, 99999], 3, 7, 3, 3, 8, 1, 'Medium', 1000 ], 'A tough rig that can withstand quite a few hits.' ],
	["B_Truck_01_transport_F", "HEMTT Transport", [ [0.1, 99999], 3, 9, 5, 3, 8, 1, 'Large', 1000 ], 'A slightly tougher HEMTT with upgraded storage.' ],
	["I_Truck_02_transport_F", "Zamak Truck", [ [0.1, 99999], 3, 8, 4, 2, 7, 1, 'Large', 1000 ], 'Smartly built, this clever rig presents lots of opportunities.' ],
	// ["O_Truck_03_repair_F", "Tempest Transport", [ [0.1, 99999], 2, 12, 6, 3, 8, (0.25 * GW_GAM), 'Large', 1000 ], 'A behemoth that features excess storage and additional swag.' ],

	// Military

	["I_MRAP_03_F", "Strider", [ [2.25, 99999], 5, 3, 2, 0.5, 9, 1.22, 'Medium', 4000 ], 'A fast, heavily armoured amphibious assault vehicle.' ],
	["B_MRAP_01_F", "Hunter", [ [1.75, 99999], 4, 4, 2, 1, 8, 1.09, 'Medium', 3500 ], 'An armoured jack of all trades.' ],
	["O_MRAP_02_F", "Ifrit", [ [1.5, 99999], 5, 3, 2, 0.75, 7, 1.13, 'Large', 1000 ], 'Trades speed for upgraded armor and marginally better looks.' ]	
	
];

// Default locked vehicles
GW_LOCKED_ITEMS = [
	
	"I_MRAP_03_F",
	"O_MRAP_02_F",
	"B_MRAP_01_F",

	"C_Van_01_box_F",
	"C_Van_01_fuel_F",
	"O_truck_02_fuel_f",
	"O_truck_03_ammo_f",
	
	"B_Truck_01_mover_F",
	"B_Truck_01_transport_F",
	"O_Truck_03_transport_F",
	"I_Truck_02_transport_F",
	// "O_Truck_03_repair_F",

	"C_Kart_01_F",
	"C_SUV_01_F",
	"C_Van_01_box_F",
	"C_Offroad_01_F"

];