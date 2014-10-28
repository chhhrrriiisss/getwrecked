//
//
//
//		Client Initialization
//
//
//

if (isDedicated) exitWith {};

// Wait for the server to finish doing its thang
waitUntil {!isNil "serverSetupComplete"};

// Check for an existing library
_lib = profileNamespace getVariable ['GW_LIBRARY', nil];
if (isNil "_lib") then {   

	_temp = [tempAreas, ["Car"], 15] call findEmpty;	

	// Generate a default library
	{
		[((_x select 0) select 1), (_x select 0)] call registerVehicle;

	} ForEach [
		[ ["C_Quadbike_01_F",'Quadbike','', (ASLtoATL getPosASL _temp), 0, []] ],
		[ ["C_Hatchback_01_sport_F",'Hatchback','', (ASLtoATL getPosASL _temp), 0, []] ]
	];

	profileNamespace setVariable ['GW_LIBRARY', ['Quadbike', 'Hatchback']]; saveProfileNamespace;  
};

// Check for a last loaded vehicle
_last = profileNamespace getVariable ['GW_LASTLOAD', nil];
GW_LASTLOAD = if (isNil "_last") then {  profileNamespace setVariable ['GW_LASTLOAD', '']; saveProfileNamespace; '' } else { _last };

// Prepare player, display and key binds
[player] call playerInit;

Sleep 0.1;

99999 cutText ["","PLAIN", 1];
