//
//
//
//		Client Initialization
//
//
//

if (isDedicated) exitWith {};

// Wait for the server to finish doing its thang
systemchat 'Waiting for server...';
waitUntil {Sleep 0.1; !isNil "serverSetupComplete"};
systemchat 'Ready to go!';


// Check for an existing library
_newPlayer = false;
_lib = profileNamespace getVariable ['GW_LIBRARY', nil];
if (isNil "_lib") then {   

	_newPlayer = true;
	_temp = [tempAreas, ["Car"], 15] call findEmpty;	

	// Generate a default library
	{
		[((_x select 0) select 1), (_x select 0)] call registerVehicle;

	} ForEach [
		[ ["C_Offroad_01_F","FRESH MEAT","","[16969.742188,18061.443359,0]",0,[["Land_Pallet_vertical_F","[-0.0859375,2.541016,-1.470397]",[0.58819,1.76747,0.00813233],["-1","1"]],["Land_Pallet_vertical_F","[-1.226563,2.0195313,-1.468393]",[0.473785,1.77889,309.008],["-1","1"]],["Land_Pallet_vertical_F","[1.0976563,2.00390625,-1.429499]",[1.96258,1.86644,57.097],["-1","1"]],["Land_Portable_generator_F","[0,-1.158203,-0.811329]",[0.453914,1.77213,358.509],["-1",""]],["B_HMG_01_A_F","[-0.175781,2.197266,-0.205445]",[0.226884,1.60292,357.295],["-1","1"]],["B_Mortar_01_F","[-0.00390625,-2.111328,-0.774925]",[0.506545,1.57926,0.019397],["-1","1"]],["Land_WoodenBox_F","[-0.0546875,-2.777344,-0.975389]",[0.491273,1.57592,0.674953],["-1","1"]]],[80,"SLI",1,2,[],[["HORN","0"],["UNFL","0"],["EPLD",""],["LOCK",""],["OILS",""],["DCLK",""]],[]]] ],
		[ ["C_Van_01_transport_F","SPECIAL DELIVERY","","[16969.742188,18061.443359,0]",0,[["Land_Portable_generator_F","[-0.0742188,-1.306641,-0.866945]",[1.4309,1.4751,0.0321974],["-1","1"]],["Land_Sacks_heap_F","[0.222656,-1.851563,-0.923588]",[1.43748,1.46821,0.0324669],["-1","1"]],["Land_Sacks_heap_F","[-0.386719,-2.0214844,-0.829318]",[1.43565,1.47572,0.0327176],["-1","1"]],["Box_IND_Wps_F","[-0.0410156,-0.638672,-0.849981]",[1.43392,1.45615,0.0894442],["-1","1"]],["Land_Sacks_heap_F","[0.269531,-2.298828,-0.80055]",[1.43345,1.42281,26.9694],["-1","1"]],["Land_MetalBarrel_F","[0.578125,-0.548828,-0.766026]",[1.3799,2.58176,21.5532],["-1","1"]],["Land_CncBarrier_stripes_F","[-0.0078125,2.273438,-1.62625]",[1.21871,2.4194,359.059],["-1","1"]],["Land_CncBarrier_stripes_F","[0.0078125,2.257813,-0.839446]",[1.21873,1.0827,359.058],["-1","1"]],["Land_BagFence_Long_F","[0.957031,-1.771484,-1.0472355]",[0.921023,1.13933,90.0183],["-1","1"]],["Land_BagFence_Long_F","[-1.0585938,-1.865234,-1.0080328]",[0.807465,1.06457,90.0126],["-1","1"]],["Land_DischargeStick_01_F","[-0.550781,2.1875,-0.152859]",[1.34994,3.41398,180.096],["-1","1"]]],[80,"SLI",5,2,[],[["HORN","0"],["UNFL","0"],["EPLD",""],["LOCK",""],["OILS",""],["DCLK",""]],[]]] ]
	];

	profileNamespace setVariable ['GW_LIBRARY', ['Fresh Meat', 'Special Delivery']]; saveProfileNamespace;  
};

// Check for a last loaded vehicle
_last = profileNamespace getVariable ['GW_LASTLOAD', nil];
GW_LASTLOAD = if (isNil "_last") then {  profileNamespace setVariable ['GW_LASTLOAD', '']; saveProfileNamespace; '' } else { _last };

// Prepare player, display and key binds
[player] call playerInit;

// Start simulation toggling
[] spawn simulationManager;

Sleep 0.1;

99999 cutText ["","PLAIN", 1];

Sleep 0.5;

if (_newPlayer) then {
	systemChat format['Welcome to Get Wrecked, %1.', GW_PLAYERNAME];
	systemCHat 'A guide is available at getwrecked.info.';
};

