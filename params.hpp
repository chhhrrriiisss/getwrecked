// 
//
//		Permission is granted to edit these configuration values to suit your own need.
//		To set any values permanently, edit default = #; to any value in values[] = {#, #, #};
//
//		Incorrect or bad values may cause the mission to not work properly - edit at your own risk.
//
//

class Params
{
	// 0
	class GameMode // Placeholder for future game mode types
	{
		title = "Game Mode"; 
		values[] = {0}; 
		texts[] = {"Competitive [Default Zones]"}; 
		default = 0; 
	};

	// 1
	class RespawnTimer // How long to wait in the death camera for returning to workshop
	{
		title = "Respawn Timer"; 
		values[] = {2,5,10,15,30,45,60}; 
		texts[] = {"2s","5s","10s", "15s", "30s", "45s", "60s"}; 
		default = 30; 
	};

	// 2
	class StartingMoney // Money given to new players on first spawn
	{
		title = "Starting Money"; 
		values[] = {100, 500, 1000, 2500, 5000, 7500, 10000, 12500, 15000, 17500, 20000, 25000, 30000, 40000, 60000, 100000}; 
		texts[] = {"$100","$500", "$1000", "$2500", "$5000", "$7500", "$10000", "$12500", "$15000", "$17500", "$20000", "$25000", "$30000", "$40000", "$60000", "$100000"}; 
		default = 5000; 
	};

	// 3
	class ZoneMoney // Starting money given while player is in zone (not including wanted-rating bonus)
	{
		title = "In-Zone Money"; 
		values[] = {50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000}; 
		texts[] = {"$50","$100", "$200", "$300", "$400", "$500", "$600", "$700", "$800", "$900", "$1000"};
		default = 200; 
	};

	// 4
	class BountyMoney // Percentage value of vehicle received from killed vehicles
	{
		title = "Bounty Money"; 
		values[] = {0, 25, 50, 75, 100}; 
		texts[] = {"0%","25%", "50%", "75%", "100%"}; 
		default = 50; 
	};

	// 5
	class ArmorSystem // Armor system prolongs engagements and better balances all vehicles
	{
		title = "Armor Balance System";
		values[] = {1,0}; 
		texts[] = {"Enabled","Disabled"}; 
		default = 1; 
	};	

	// 6
	class MaxDeployables // Maximum number of deployed items (mines etc) per player before cleanup
	{
		title = "Max Deployable Items"; 
		values[] = {10, 20, 30, 40, 50, 100}; 
		texts[] = {"10", "20", "30", "40", "50", "100"}; 
		default = 50; 
	};

	// 7
	class ItemCost // Maximum number of deployed items (mines etc) per player before cleanup
	{
		title = "Item Cost"; 
		values[] = {0, 0.5, 1, 2, 10}; 
		texts[] = {"Free", "0.5x", "Default", "2x", "10x"}; 
		default = 1; 
	};

	// 8
	class CleanupTime // Maximum number of deployed items (mines etc) per player before cleanup
	{
		title = "Cleanup Time"; 
		values[] = {0, 1, 2, 3, 4, 5}; 
		texts[] = {"Off", "Low", "Medium", "Default", "High", "Very High"}; 
		default = 3; 
	};

	// 9
	class Blank // Maximum number of deployed items (mines etc) per player before cleanup
	{
		title = ""; 
		values[] = {0}; 
		texts[] = {""}; 
		default = 0; 
	};

	class Note // Maximum number of deployed items (mines etc) per player before cleanup
	{
		title = "Note: These values apply only to the current game session. To set parameters permanently, you need to edit params.hpp in the mission folder."; 
		values[] = {0}; 
		texts[] = {""}; 
		default = 0; 
	};

};