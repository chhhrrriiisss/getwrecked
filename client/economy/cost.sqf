//
//      Name: getCost
//      Desc: Returns price of item (including respective discounts)
//      Return: Number (The cost)
//

private ['_item', '_sponsor', '_company', '_building', '_weapons', '_name', '_arr', '_cost', '_class'];

_item = [_this,0, "", [""]] call BIS_fnc_param;
_sponsor = [_this,1, "", [""]] call BIS_fnc_param;
_company = [_this,2, "", [""]] call BIS_fnc_param;

// Building
_building = [
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
	["Land_New_WiredFence_5m_F", 30]
];

// Weapons
_weapons = [
	["B_HMG_01_A_F", 100],
	["B_GMG_01_A_F", 150],
	["B_static_AT_F", 300],
	["B_Mortar_01_F", 200],
	["Land_Runway_PAPI", 400],
	["launch_NLAW_F", 300],
	["launch_RPG32_F", 200],
	["srifle_LRR_LRPS_F", 600]
];

// Performance
_performance = [
	["Land_MetalBarrel_F", 300],
	["Land_CanisterPlastic_F", 150],
	["Land_CanisterFuel_F", 75],
	["Land_Portable_generator_F", 100],
	["Box_NATO_Ammo_F", 150], 
	["Box_Nato_AmmoVeh_F", 300]
];

// Incendiary
_incendiary = [
	["Land_WaterTank_F", 100],
	["Box_East_AmmoOrd_F", 400],
	["Box_IND_Grenades_F", 300],
	["Land_FireExtinguisher_F", 100],
	["Land_Runway_PAPI", 400]
];

// Electronics
_electronics = [
	["Land_BarrelEmpty_F", 400],
	["Land_Suitcase_F", 200],
	["launch_NLAW_F", 300],
	["Land_Coil_F", 1000]
];


// Deployables
_deployables = [
	["Land_Sacks_heap_F", 50],
	["Land_WoodenBox_F", 200],
	["Land_FoodContainer_01_F", 500],
	["Land_WaterTank_F", 100]
];

// Defense
_defense = [
	["Land_PowerGenerator_F", 400],
	["Box_IND_Wps_F", 500],
	["Land_Wall_IndCnc_2deco_F", 200],
	["Land_Device_assembled_F", 250]
];

// Evasion
_evasion = [
	["Land_Portable_generator_F", 100],
	["Land_Sack_F", 100],
	["Land_FireExtinguisher_F", 100],
	["Land_BarrelEmpty_grey_F", 100],
	["Land_Device_assembled_F", 250]
];

_vehicles = [

	// Civilian
	
	["C_Offroad_01_F", 2500],
	["C_SUV_01_F", 5000],
	["C_Van_01_box_F", 2500],
	["C_Hatchback_01_sport_F", 0],	
	["C_Kart_01_F", 5000],
	["C_Quadbike_01_F", 0],

	// Trucks

	["B_Truck_01_mover_F", 7500],
	["B_Truck_01_transport_F", 10000],
	["O_Truck_03_transport_F", 10000],
	["I_Truck_02_transport_F", 12000],

	// Military

	["I_MRAP_03_F", 25000],
	["B_MRAP_01_F", 20000],
	["O_MRAP_02_F", 15000]

];
	
_cost = 0;
_discount = 1;

// Sponsor matches company
if (_sponsor == _company && _sponsor != "" && _company != "") then { _discount = 0.9; }; // 10% for sponsor match

// Loop through all categories to determine company matches
{

	_name = _x select 0;
	_arr = _x select 1;

	{
		_class = (_x select 0);
		if ( _class == _item) exitWith {
			if (_company == _name) then { _discount = _discount - 0.25; }; // 25% for company
			_cost = ((_x select 1) * _discount);
		};

	} ForEach _arr;

} ForEach [	
	["slytech", _building],
	["terminal", _weapons],
	["gastrol", _performance],
	["cognition", _deployables],
	["crisp", _incendiary],
	["tank", _defense],
	["veneer", _evasion],
	["haywire", _electronics],
	["nocategory", _vehicles]
];

_cost
