//
//      Name: attachObj
//      Desc: Attach an object to a nearby vehicle
//      Return: Bool (Success)
//

private ["_obj", "_unit","_orig", "_id", "_veh"];

_unit = [_this, 0, objNull, [objNull]] call filterParam;
_orig = [_this, 1, objNull, [objNull]] call filterParam;
_forceAttach = [_this, 2, false, [false]] call filterParam;

if (isNull _unit || isNull _orig) exitWith { false };
if (!alive _unit || !alive _orig) exitWith { false };

// Dont attach supply boxes
_isSupply = _orig getVariable ["isSupply", false];
if (_isSupply) exitWith { false };

// Check there's actually a vehicle within range
_position = (ASLtoATL getPosASL _orig);
_nearby = _position nearEntities [["Car", "Tank"], 8];

if (_forceAttach) then {
	waitUntil{ count _nearby > 0};
};

if (count _nearby <= 0) exitWith {
	[localize "str_gw_no_vehicle_found", 1.5, warningIcon, colorRed] spawn createAlert;
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
	[localize "str_gw_cannot_attach", 1.5, warningIcon, colorRed] spawn createAlert;
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

_currentWeapons = 0; 
_currentModules = 0;

{
	if (_x call isWeapon) then { _currentWeapons = _currentWeapons + 1; };
	if (_x call isModule) then { _currentModules = _currentModules + 1; };
} count (attachedObjects _veh) > 0;

if (_orig call isWeapon && _currentWeapons >= _maxWeapons) exitWith {
	[localize "str_gw_too_many_weapons", 1.5, warningIcon, colorRed, "default", "beep_warning"] spawn createAlert;
	false
};

if  (_orig call isModule && _currentModules >= _maxModules) exitWith {
	[localize "str_gw_too_many_modules", 1.5, warningIcon, colorRed, "default", "beep_warning"] spawn createAlert;
	false
};

// Do we own this vehicle?
_isOwner = [_veh, player, false] call checkOwner;
if (!_isOwner && !_forceAttach) exitWith {
	[localize "str_gw_permission_error", 1.5, warningIcon, colorRed, "default", "beep_warning"] spawn createAlert;    	
	false
};

// Is the vehicle overloaded?
_vMass = getMass _veh;
_oMass = getMass _orig;
_modifier = if (!isNil "_data") then { (((_data select 2) select 0) select 0) } else { 1 };
_maxMass = if (!isNil "_data") then { (((_data select 2) select 0) select 1) } else { 99999 };

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
] call bis_fnc_mp;

_timeout = time + 3;
waitUntil{
	Sleep 0.1;
	( (time > _timeout) || ( !(simulationEnabled _veh) && !(simulationEnabled _obj)  )  )
};

_vect = [_obj, _veh] call getVectorDirAndUpRelative;
_obj attachTo [_veh];

_snd = if (_obj call isWeapon || _obj call isModule) then { 
	(format['wrench%1', ceil(random 5)])
} else { 
	(format['hit%1', (ceil(random 4)) + 1])
};

[		
	[
		_obj,
		_snd,
		60
	],
	"playSoundAll",
	true,
	false
] call bis_fnc_mp;

_timeout = time + 3;
waitUntil {
	
	_attached = if (!isNull attachedTo _obj) then { if ((attachedTo _obj) isEqualTo _veh) exitWith { true }; false } else { false };
	(_attached || (time > _timeout))
};

_obj setVectorDirAndUp _vect;
_obj setVectorUp [0,0,1];

// Set ownership to prevent non-owner detachment
_obj setVariable ['GW_Owner', name player, true];

// If its being force added ignore message
if (_forceAttach) then {} else {
	[localize "str_gw_object_attached", 1, successIcon, nil, "slideDown", ""] spawn createAlert;	
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
	] call bis_fnc_mp;

};

// If it wasn't simulated, briefly toggle simulation so we see the update
if (!_wasSimulated) then {	
	_veh enableSimulation true;
	_timeout = time + 5;
	waitUntil { (simulationEnabled _veh || time > _timeout) };
	_prevPos = ASLtoATL visiblePositionASL _veh;
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

_isHidden = _veh getVariable ['GW_HIDDEN', false];
if (_isHidden) then {
	pubVar_setHidden = [_veh, true];
	publicVariable "pubVar_setHidden";	
	[_veh, false] call pubVar_fnc_setHidden;	
};

// Remove all actions from player
removeAllActions player;
player spawn setPlayerActions;

[_veh] call snapToPad;

true





