//
//      Name: requestVehicle
//      Desc: Send a request to the server for a new vehicle
//      Return: None
//

private['_target', '_loadTarget'];

GW_PREVIEW_VEHICLE = nil;

if (GW_SETTINGS_ACTIVE) exitWith {};
    
// Is the server actually ready to receive requests?
if (isNil "serverSetupComplete") exitWith {
    systemChat 'Server busy, try again in a few seconds.';
    GW_WAITLOAD = false;
};

if (GW_WAITLOAD) exitWith {
	systemChat 'Load in progress. Please wait.';
};

GW_WAITLOAD = true;

_target = [_this,0, [0,0,0], [objNull, []]] call BIS_fnc_param;
_loadTarget = [_this,1, [], ["", []]] call BIS_fnc_param;

if (typename _target == 'OBJECT') then {
    _target = (ASLtoATL getPosASL _target);
};

_data = [];
_raw = [];

// If the request actually contains vehicle data, use that rather than checking library
if ( typename _loadTarget == "ARRAY") then { _raw = _loadTarget; } else {
    _raw = profileNamespace getVariable [ _loadTarget, nil];
    if (!isNil "_raw") then { _raw = (_raw select 0); } else {  _raw = []; };
};

// Check that vehicle name actually exists
if (count _raw <= 0 && (typename _loadTarget != "ARRAY")) exitWith {
    loadError = true;
    systemChat 'No vehicle found.';
    GW_WAITLOAD = false;
};

// Find an empty temporary location to spawn a new car
_temp = [tempAreas, ["Car"], 8] call findEmpty;

if ( (_temp distance [0,0,0]) <= 200) exitWith {
    systemChat 'Load areas full. Try again in a few seconds.';
    loadError = true;
    GW_WAITLOAD = false;
};

// Ok, we're good to go, send a request to the server
systemChat 'Sending load request... ';

[       
    [
        player,
        _target,
        _raw
    ],
    "loadVehicle",
    false,
    false 
] call BIS_fnc_MP; 

// Make it easier to spawn this vehicle next time
if (typename _loadTarget != "ARRAY") then {
    GW_LASTLOAD = _loadTarget;
    profileNamespace setVariable ['GW_LASTLOAD', GW_LASTLOAD];
    saveProfileNamespace;   
};

// Start a timeout so we can abort if nothing comes back
_timeout = time + 25;
waitUntil { 
    Sleep 1;
    if ( !GW_WAITLOAD || (time > _timeout) ) exitWith { true };  
    false
};

// If we're still waiting, reset GW_WAITLOAD
if (GW_WAITLOAD) then {
    loadError = true;
    systemChat 'Timeout waiting for load.';
    GW_WAITLOAD = false;
};


