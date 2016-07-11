//
//      Name: getVehicleLibrary
//      Desc: Returns vehicle library and creates default incase it has been reset or does not exist
//      Return: Array (Library)
//

// Get list of all vehicles
_lib = profileNamespace getVariable [GW_LIBRARY_LOCATION, nil];

// Check the library isn't corrupted and exists
_isCorrupted = if (!isNil "_lib") then { 
	if !(_lib isEqualType []) exitWith { true };
	if (count _lib == 0) exitWith { true };
	false
} else {
	true 
};

if (!_isCorrupted) exitWith { _lib };

['LIBRARY RESET!', 2, warningIcon, colorRed, "slideDown"] spawn createAlert; 

// Generate a default library
profileNamespace setVariable ['GW_Fresh Meat', [

	[
	// Info
	"C_Offroad_01_F","FRESH MEAT","",[],0,
	// Attachments
	[["Land_Pallet_vertical_F","[-1.129883,2.0527344,-0.945724]",[-0.162112,0.164314,309.062],["-1","1"]],["Land_Pallet_vertical_F","[0.0244141,2.640625,-0.941437]",[-0.248156,-0.0242036,0.0571053],["-1","1"]],["Land_Pallet_vertical_F","[1.137695,2.0625,-0.949272]",[-0.122883,-0.237427,57.1486],["-1","1"]],["Land_Portable_generator_F","[-0.0488281,-2.566406,-0.415092]",[-0.284084,-0.019934,358.547],["16",""]],["launch_RPG32_F","[0.635742,0.304688,1.0535126]",[-0.0286803,0.300263,270.001],["19","0"]],["B_HMG_01_A_F","[-0.250977,1.503906,0.87738]",[-0.31642,-0.0302041,0.00147558],["-1","1"]],["Land_FireExtinguisher_F","[0.660156,-3.0546875,-0.401917]",[-0.331944,-0.0316825,0.00154992],["33",""]],["Land_Suitcase_F","[-0.481445,-3.0703125,-0.350143]",[-0.346835,-0.0331501,0.00162169],["18",""]]],
	// Meta
	[
		GW_VERSION,"SLI",1,2,[],
		[["HORN","57"],["UNFL","35"],["EPLD",""],["LOCK",""],["OILS",""],["DCLK",""],["PARC",""],["TELP",""]],
		"batman"
	]
	]
	]
]; 

profileNamespace setVariable ['GW_Special Delivery', [ ["C_Van_01_transport_F","SPECIAL DELIVERY","","[]",0,[["Land_Portable_generator_F","[-0.0742188,-1.306641,-0.866945]",[1.4309,1.4751,0.0321974],["-1","1"]],["Land_Sacks_heap_F","[0.222656,-1.851563,-0.923588]",[1.43748,1.46821,0.0324669],["-1","1"]],["Land_Sacks_heap_F","[-0.386719,-2.0214844,-0.829318]",[1.43565,1.47572,0.0327176],["-1","1"]],["Box_IND_Wps_F","[-0.0410156,-0.638672,-0.849981]",[1.43392,1.45615,0.0894442],["-1","1"]],["Land_Sacks_heap_F","[0.269531,-2.298828,-0.80055]",[1.43345,1.42281,26.9694],["-1","1"]],["Land_MetalBarrel_F","[0.578125,-0.548828,-0.766026]",[1.3799,2.58176,21.5532],["-1","1"]],["Land_CncBarrier_stripes_F","[-0.0078125,2.273438,-1.62625]",[1.21871,2.4194,359.059],["-1","1"]],["Land_CncBarrier_stripes_F","[0.0078125,2.257813,-0.839446]",[1.21873,1.0827,359.058],["-1","1"]],["Land_BagFence_Long_F","[0.957031,-1.771484,-1.0472355]",[0.921023,1.13933,90.0183],["-1","1"]],["Land_BagFence_Long_F","[-1.0585938,-1.865234,-1.0080328]",[0.807465,1.06457,90.0126],["-1","1"]],["Land_DischargeStick_01_F","[-0.550781,2.1875,-0.152859]",[1.34994,3.41398,180.096],["-1","1"]]],[GW_VERSION,"SLI",5,2,[],[["HORN","0"],["UNFL","0"],["EPLD",""],["LOCK",""],["OILS",""],["DCLK",""]],[]]] ]]; 

_defaults = ['Fresh Meat', 'Special Delivery'];
profileNamespace setVariable [GW_LIBRARY_LOCATION, _defaults]; 
saveProfileNamespace;  

_defaults