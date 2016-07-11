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

_target = [_this,0, [0,0,0], [objNull, []]] call filterParam;
_loadTarget = if (isNil { (_this select 1) }) then { [] } else { (_this select 1) };
_forceServerLoad = [_this,2, false, [false]] call filterParam;

if (_target isEqualType objNull) then {
    _target = (ASLtoATL getPosASL _target);
};

_data = [];

// If the request actually contains vehicle data, use that rather than checking library
_raw = if ( _loadTarget isEqualType []) then { _loadTarget } else {
    ([_loadTarget] call getVehicleData)  
};

// Check that vehicle name actually exists
if (count _raw <= 0 && !(_loadTarget isEqualType []) ) exitWith {
    loadError = true;
    systemChat 'No vehicle found.';
    GW_WAITLOAD = false;
};

_data = _raw select 0;

// Find an empty temporary location to spawn a new car
_temp = [tempAreas, ["Car"], 8] call findEmpty;

if ( (_temp distance [0,0,0]) <= 200) exitWith {
    systemChat 'Load areas full. Try again in a few seconds.';
    loadError = true;
    GW_WAITLOAD = false;
};

// Optionally make the server spawn it
if (_forceServerLoad) exitWith {

    [
        [player, _target, (_raw select 0)],
        'loadVehicle',
        false,
        false
    ] call bis_fnc_mp;   

    GW_WAITLOAD = false;
    loadError = false;
};  

_done = [player, _target, (_raw select 0)] spawn loadVehicle;

_timeout = time + 15;
waitUntil {    
    ( (scriptDone _done) || (time > _timeout))
};

// Make it easier to spawn this vehicle next time
if ( !(_loadTarget isEqualType []) && time < _timeout) then {
    GW_LASTLOAD = _loadTarget;
    profileNamespace setVariable ['GW_LASTLOAD', GW_LASTLOAD];
    saveProfileNamespace;   
};

if (time > _timeout) then { loadError = true; };
    
GW_WAITLOAD = false;
