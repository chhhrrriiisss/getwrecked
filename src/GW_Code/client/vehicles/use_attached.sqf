//
//      Name: useAttached
//      Desc: Main function used to trigger tactical module effects
//      Return: None
//

private ["_type", "_vehicle", "_reloadTime"];

if (GW_WAITUSE) exitWith {};
GW_WAITUSE = true;

_type = [_this,0, "", [""]] call filterParam;
_vehicle = [_this,1, objNull, [objNull]] call filterParam;
_module = [_this,2, objNull, [objNull]] call filterParam;

if (isNull _vehicle || _type == "") exitWith { GW_WAITUSE = false; };

// If an object has been specified, set manual mode
_manual = if (isNull _module) then { false } else { true  };

// Do we actually have anything attached?
_tacticalList = _vehicle getVariable ["tactical", []];
if (count _tacticalList == 0) exitWith { GW_WAITUSE = false; };

// Check we're not emp'd or anything
_status = _vehicle getVariable ['status', []];

if ('emp' in _status || 'cloak' in _status || 'jammed' in _status || (GW_CURRENTZONE == 'workshopZone' && !GW_DEBUG)) exitWith {
	['DISABLED!  ', 0.5, warningIcon, colorRed, "flash"] spawn createAlert;
	GW_WAITUSE = false;	
};

// Is the specific item currently attached?
_isAttached = if ( ([_type, _vehicle] call hasType) > 0) then { true } else { false };

if (!_isAttached) exitWith {
	['NOT EQUIPPED!  ', 1, warningIcon, colorRed, "warning"] spawn createAlert;
	GW_WAITUSE = false;
};

// Ok it's there, lets see if we can use it
_currentTime = time;
_state = if (_manual) then { ([str _module, _currentTime] call checkTimeout) } else { ([_type, _currentTime] call checkTimeout) };
_timeLeft = _state select 0;
_found = _state select 1;

// Is the device on timeout?
if (_timeLeft > 0 && _found) exitWith {
	if (_timeLeft > 1) then {
		[format['PLEASE WAIT (%1s)', round(_timeLeft)], 0.5, warningIcon, nil, "flash"] spawn createAlert;
	};
	GW_WAITUSE = false;
};	

// Defaults
_tagData = [_type] call getTagData;
_reloadTime = (_tagData) select 0;
_reloadTime = if ("overcharge" in _status) then { (_reloadTime * 0.1) } else { _reloadTime };
_cost = (_tagData) select 1;
_ammo = _vehicle getVariable ["ammo", 0];

// Only some module types are dependent on ammo
_usesAmmo = (_type in ["MIN", "CAL", "CLK"]);

// Check we're not out of ammo (and this is a type that uses it)
if (_cost > 0 && _ammo <= 0 && _usesAmmo) exitWith {
	["OUT OF AMMO ", 0.3, warningIcon, colorRed, "warning"] spawn createAlert;
	GW_WAITUSE = false;
};

// Check we have enough for at least one use (and this is a type that uses it)
if (_ammo < _cost && _usesAmmo) exitWith {	
	["NEED AMMO ", 0.3, warningIcon, colorRed, "warning"] spawn createAlert;
	GW_WAITUSE = false;
};

_obj = nil;

_obj = if (_manual) then {	

	_module

} else {

	{
		if (_type == _x select 0) exitWith { (_x select 1) };
	} Foreach _tacticalList;
};

// If we found an object, loop through and get the appropriate function for the tag
_success = if (!isNil "_obj") then {

	_command = switch (_type) do {
		
		case "SMK": { smokeBomb };
		case "SHD": { shieldGenerator };
		case "NTO": { nitroBoost };
		case "THR": { verticalThruster };
		case "OIL": { oilSlick };
		case "REP": { emergencyRepair };
		case "DES": { selfDestruct };
		case "EMP": { empDevice };
		case "CAL": { dropCaltrops };
		case "MIN": { dropMines };
		case "PAR": { emergencyParachute };
		case "EPL": { dropExplosives };
		case "NPA": { dropNapalm };
		case "TPD": { dropTeleport };
		case "CLK": { cloakingDevice };
		case "MAG": { magneticCoil };
		case "JMR": { dropJammer };
		case "LPT": { dropLimpets };
		case "ELM": { activateElectromagnet };
	};

	([_obj, _vehicle] call _command)

} else {
	false
};

// Only if the call was successful put the item on timeout
if (_success) then {
	_reference = if (_manual) then { [_type, str _module] } else { _type };
	[_reference, _reloadTime] call createTimeout;	
};

// Reload appropriately
if (_reloadTime > 1) then {	
	playSound3D ["a3\sounds_f\weapons\Reloads\missile_reload.wss", _vehicle, false, getPos _vehicle, 3, 1, 100];
};

GW_WAITUSE = false;


