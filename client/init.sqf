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
systemchat 'Server is ready to go!';

// Launch the black screen so it clears even with script errors below
[] spawn {
	_timeout = time + 30;
	waitUntil {Sleep 1; ((time > _timeout) || (!isNil "clientLoadComplete"))};	
	99999 cutText ["","PLAIN", 0.6];
};

// Check for an existing library
_newPlayer = false;
_lib = profileNamespace getVariable ['GW_LIBRARY', nil];
if (isNil "_lib") then {   
	_newPlayer = true;
	[] call createDefaultLibrary;	
};

// Check for a last loaded vehicle
_last = profileNamespace getVariable ['GW_LASTLOAD', nil];
GW_LASTLOAD = if (isNil "_last") then {  profileNamespace setVariable ['GW_LASTLOAD', '']; saveProfileNamespace; '' } else { _last };

// Check for custom races
_races = profileNamespace getVariable ['GW_RACES', nil];
if (isNil "_races") then {   
	[] call createDefaultRaces;		
};


// Prepare player, display and key binds
[player] call playerInit;

// Start simulation toggling
[] spawn simulationManager;

if (_newPlayer) then {
	player globalChat localize "str_gw_welcome";
	player globalChat localize "str_gw_welcome_guide";
};


