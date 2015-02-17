//
//      Name: fireAttached
//      Desc: Critical function used to fire weapons from a vehicle
//		Return: None
//

if (GW_WAITFIRE) exitWith { };

GW_WAITFIRE = true;

_type = [_this,0, "", [""]] call BIS_fnc_param;
_vehicle = [_this,1, objNull, [objNull]] call BIS_fnc_param;
_module = [_this,2, objNull, [objNull]] call BIS_fnc_param;
_indirect = [_this,3, false, [false]] call BIS_fnc_param;

if (isNull _vehicle || _type == "") exitWith { GW_WAITFIRE = false; };

// If an object has been specified, set manual mode
_manual = if (isNull _module) then { false } else { true };

_weaponsList = _vehicle getVariable ["weapons", []];

// Check we're not emp'd or anything
_status = _vehicle getVariable ['status', []];
if ('emp' in _status || (GW_CURRENTZONE == 'workshopZone' && !GW_DEBUG)) exitWith {
	['DISABLED!    ', 0.5, warningIcon, colorRed, "flash"] spawn createAlert;
	GW_WAITFIRE = false;
};

// Check we have weapons
if (count _weaponsList == 0) exitWith {
	GW_WAITFIRE = false;
};

// Check we're not out of ammo
_ammo = _vehicle getVariable ["ammo", 0];
if (_ammo <= 0 && _type != "FLM") exitWith {
	["OUT OF AMMO ", 0.3, warningIcon, colorRed, "warning"] spawn createAlert;
	
	[       
	    [
	        _vehicle,
	        "['noammo']",
	        3
	    ],
	    "addVehicleStatus",
	    _vehicle,
	    false 
	] call BIS_fnc_MP;  

	GW_WAITFIRE = false;
};

// Is the specific item currently attached?
_isAttached = if ( ([_type, _vehicle] call hasType) > 0) then { true } else { false };

if (!_isAttached) exitWith {
	['NOT EQUIPPED! ', 1, warningIcon, colorRed, "warning"] spawn createAlert;
	GW_WAITFIRE = false;
};

// Ok it's there, lets see if we can use it
_currentTime = time;
_state = if (_manual) then { ([str _module, _currentTime] call checkTimeout) } else { ([_type, _currentTime] call checkTimeout) };
_timeLeft = _state select 0;
_found = _state select 1;

// Is the device on timeout?
if (_timeLeft > 0 && _found) exitWith {
	if ( _type == "HMG" || _type == "GMG" || _type == "FLM" || _type == "LMG") then {} else {
		[format['PLEASE WAIT (%1s)', round(_timeLeft)], 0.5, warningIcon, nil, "flash"] spawn createAlert;
	};
		GW_WAITFIRE = false;
};	

// Check we have enough ammo
_tagData = [_type] call getTagData;
_reloadTime = _tagData select 0;
_reloadTime = if ('jammed' in _status) then { (_reloadTime * 10) } else { _reloadTime };

_cost = _tagData select 1;

// Do we have enough ammo? Flamethrower is an exception
if (_ammo < _cost && _type != "FLM") exitWith {	
	["NEED AMMO ", 0.3, warningIcon, colorRed, "warning"] spawn createAlert;

	[       
	    [
	        _vehicle,
	        "['noammo']",
	        3
	    ],
	    "addVehicleStatus",
	    _vehicle,
	    false 
	] call BIS_fnc_MP;  

	GW_WAITFIRE = false;
};


_obj = nil;

// If it's just a specific module we're firing
_obj = if (_manual) then {	

	_module

} else {

	{
		if (_type == _x select 0) exitWith { (_x select 1) };
	} Foreach _weaponsList;
};

// Can we use the mouse cursor to aim or are we firing indirectly?
_target = if (_indirect) then { 
	_p = switch (_type) do {
		case "FLM": { (_obj modelToWorldVisual [0, -5, 0]) };
		case "LSR": { (_obj modelToWorldVisual [0, -100, 1]) };
		case "RLG": { (_obj modelToWorldVisual [200, 0, 0.2]) };
		case "RPG": { (_obj modelToWorldVisual [200, 0, 0.2]) };
		default	{ (_obj modelToWorldVisual [0, 30, -1]) };
	};	
	_p
} else { GW_TARGET };

// If we found an object, loop through and get the appropriate function for the tag
_success = if (!isNil "_obj") then {
	
	_avail = true;
	_lock = false;
	
	_command = switch (_type) do {
		
		case "HMG": {  fireHmg };
		case "GMG": {  fireGmg };
		case "RPG": {  fireRpg };
		case "GUD": {  fireGuided };
		case "MIS": {  _lock = true; fireLockOn };
		case "MOR": {  fireMortar };
		case "LSR": {  fireLaser };
		case "RLG": {  fireRail };
		case "FLM": {  fireFlamethrower };
		case "HAR": {  fireHarpoon };
		case "LMG": {  fireLmg };

	};

	if (_lock && (count GW_LOCKEDTARGETS == 0)) exitWith { false };

	[_obj, _target, _vehicle] call _command;
	
	true

} else {
	false
};

// Only if the call was successful put the item on timeout
if (_success) then {
	_reference = if (_manual) then { [_type, str _module] } else { _type };
	[_reference, _reloadTime] call createTimeout;	
};

if (_success) then {

	// Reload appropriately
	if (_reloadTime > 1) then {	
		playSound3D ["a3\sounds_f\weapons\Reloads\missile_reload.wss", _vehicle, false, getPos _vehicle, 3, 1, 100];
	};

	_newAmmo = _ammo - _cost;
	if (_newAmmo < 0) then { _newAmmo = 0; };
	_vehicle setVariable["ammo", _newAmmo];
};

GW_WAITUSE = false;
GW_WAITFIRE = false;

