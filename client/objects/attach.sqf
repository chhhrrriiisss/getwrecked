//
//      Name: attachObj
//      Desc: Attach an object to a nearby vehicle
//      Return: Bool (Success)
//

private ["_obj", "_unit","_orig", "_id", "_veh"];

_unit = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_orig = [_this,1, objNull, [objNull]] call BIS_fnc_param;
_forceAttach = [_this,2, false, [false]] call BIS_fnc_param; // Used by the server to bypass notifications

if (isNull _unit || isNull _orig) exitWith { false };
if (!alive _unit || !alive _orig) exitWith { false };

// Check there's actually a vehicle within range
_position = (ASLtoATL getPosASL _orig);
_nearby = _position nearEntities [["car"], 8];

if (_forceAttach) then {
	waitUntil{ count _nearby > 0};
};

if (count _nearby <= 0) exitWith {
	["NO VEHICLE FOUND!", 1.5, warningIcon, colorRed] spawn createAlert;
	false
};

// Find the closest vehicle (that we own)
_closest = _nearby select 0;  
_closestDist = _closest distance _unit;

{
    _isVehicle = _x getVariable ['isVehicle', false];    
    _d = _x distance _unit;

    _isOwner = false;
    
    // Take ownership if the vehicle is unowned 
    if (!_forceAttach) then {
    	_isOwner = [_x, _unit, true] call checkOwner; 
    };

    if ( _isVehicle && (_d < _closestDist) && _isOwner) exitWith {
        _closest = _x;
    };

} ForEach _nearby;
_veh = _closest;

// Check it's a valid vehicle
_allowUpgrade = _veh getVariable ['isVehicle', false];

if (!_allowUpgrade && !_forceAttach) exitWith {
	["CANT ATTACH!", 1.5, warningIcon, colorRed] spawn createAlert;
	false
};

// Precompile to prevent errors
if (_forceAttach) then {} else {
	[_veh] call compileAttached;
};

// Check for limits to weapon/modules and abort if thats the case
_data = [typeOf _veh, GW_VEHICLE_LIST] call getData;
if (isNil "_data") exitWith { false };
_maxWeapons = (_data select 2) select 1;
_maxModules = (_data select 2) select 2;

_currentWeapons = count (_veh getVariable ["weapons", []]);
_currentModules = count (_veh getVariable ["tactical", []]);

if (!isNil { _orig getVariable "weapons" } && _currentWeapons >= _maxWeapons) exitWith {
	["TOO MANY WEAPONS!", 1.5, warningIcon, colorRed] spawn createAlert;
	false
};

if (!isNil { _orig getVariable "tactical" } && _currentModules >= _maxModules) exitWith {
	["TOO MANY MODULES!", 1.5, warningIcon, colorRed] spawn createAlert;
	false
};

// Do we own this vehicle?
_isOwner = [_veh, player, false] call checkOwner;
if (!_isOwner && !_forceAttach) exitWith {
	["PERMISSION ERROR!", 1.5, warningIcon, colorRed] spawn createAlert;    	
	false
};

// If there's something already attached.
if ( !isNull attachedTo _orig ) then {  detach _orig; };

_obj = _orig;
if (_forceAttach) then {} else { GW_EDITING = false; };

// Obtain vector/angle information for the object
_pitchBank = _obj call BIS_fnc_getPitchBank;
_dir = getDir _obj;
_vehDir = getDir _veh;
_tarDir = (_dir - _vehDir);
_tarDir = [_tarDir] call normalizeAngle;

_vehPitchBank = _veh call BIS_fnc_getPitchBank;
_tarPitch = [((_pitchBank select 0) - (_vehPitchBank select 0))] call normalizeAngle;
_tarBank = [((_pitchBank select 1) - (_vehPitchBank select 1))] call normalizeAngle;

// Attach it
_obj attachTo [_veh];

// Wait for it to be attached
waitUntil { !isNull attachedTo _obj };	

// If its being force added ignore message
if (_forceAttach) then {} else {
	["OBJECT ATTACHED!", 1, successIcon, nil, "slideDown"] spawn createAlert;	
};

// Set the object angle using the information we gathered before
[_obj, [_tarPitch,_tarBank,_tarDir]] call setPitchBankYaw;

// Re-compile vehicle information
if (_forceAttach) then {} else {
	[_veh] call compileAttached;
};

// Add detach actions
[_obj] call setDetachAction;

// Remove all actions from player
removeAllActions player;

true





