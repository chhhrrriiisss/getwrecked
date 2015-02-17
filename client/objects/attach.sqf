//
//      Name: attachObj
//      Desc: Attach an object to a nearby vehicle
//      Return: Bool (Success)
//

private ["_obj", "_unit","_orig", "_id", "_veh"];

_unit = if (isNil {_this select 0}) then { objNull } else { (_this select 0) };
_orig = if (isNil {_this select 1}) then { objNull } else { (_this select 1) };
_forceAttach = if (isNil {_this select 2}) then { false } else { (_this select 2) };

if (isNull _unit || isNull _orig) exitWith { false };
if (!alive _unit || !alive _orig) exitWith { false };

// Dont attach supply boxes
_isSupply = _orig getVariable ["isSupply", false];
if (_isSupply) exitWith { false };

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

// Is the vehicle overloaded?
_vMass = getMass _veh;
_oMass = getMass _orig;
_modifier = if (!isNil "_data") then { (((_data select 2) select 0) select 0) } else { 1 };
_maxMass = if (!isNil "_data") then { (((_data select 2) select 0) select 1) } else { 99999 };

if (_vMass + (_oMass * _modifier) > _maxMass) exitWith {
	["TOO HEAVY!", 1.5, warningIcon, colorRed] spawn createAlert;
	false
};

// If there's something already attached.
if ( !isNull attachedTo _orig ) then {  detach _orig; };

_obj = _orig;
if (_forceAttach) then {} else { GW_EDITING = false; };

_wasSimulated = (simulationEnabled _veh);

// Disable simulation
[		
	[
		[_obj, _veh],
		false
	],
	"setObjectSimulation",
	false,
	false 
] call BIS_fnc_MP;

_timeout = time + 3;
waitUntil{
	Sleep 0.1;
	( (time > _timeout) || ( !(simulationEnabled _veh) && !(simulationEnabled _obj)  )  )
};

_vect = [_obj, _veh] call getVectorDirAndUpRelative;
_obj attachTo [_veh];
_obj setVectorDirAndUp _vect;

// Wait for it to be attached
waitUntil { !isNull attachedTo _obj };	

// If its being force added ignore message
if (_forceAttach) then {} else {
	["OBJECT ATTACHED!", 1, successIcon, nil, "slideDown"] spawn createAlert;	
};


if (_wasSimulated) then {
	// Update the direction by re-enabling simulation on the vehicle
	[		
		[
			_veh,
			true
		],
		"setObjectSimulation",
		false,
		false 
	] call BIS_fnc_MP;

};

// If it wasn't simulated, briefly toggle simulation so we see the upate
if (!_wasSimulated) then {
	_veh enableSimulation true;
	_prevPos = (ASLtoATL visiblePositionASL _veh);
	_timeout = time + 5;
	waitUntil { Sleep 0.05; (simulationEnabled _veh || time > _timeout) };
	Sleep 0.1;
	_veh enableSimulation false;
	_veh setPos _prevPos;
};

// Re-compile vehicle information
if (_forceAttach) then {} else {
	[_veh] call compileAttached;
};

// Add detach actions
[_obj] call setDetachAction;

// Remove all actions from player
removeAllActions player;
player spawn setPlayerActions;

true





