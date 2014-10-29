//
//      Name: useAttached
//      Desc: Main function used to trigger tactical module effects
//      Return: None
//

private ["_type", "_vehicle", "_reloadTime"];

if (GW_WAITUSE) exitWith {};
GW_WAITUSE = true;

_type = [_this,0, "", [""]] call BIS_fnc_param;
_vehicle = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _vehicle || _type == "") exitWith { GW_WAITUSE = false; };

// Do we actually have anything attached?
_tacticalList = _vehicle getVariable ["tactical", []];
if (count _tacticalList == 0) exitWith { GW_WAITUSE = false; };

// Check we're not emp'd or anything
_status = _vehicle getVariable ['status', []];

if ('emp' in _status || 'cloak' in _status || GW_CURRENTZONE == 'workshopZone' ) exitWith {
	['DISABLED!  ', 0.5, warningIcon, colorRed, "flash"] spawn createAlert;
	GW_WAITUSE = false;	
};

// Is the specific item currently attached?
_isAttached = false;
{
	if (_type == _x select 0) exitWith { _isAttached = true; };
} ForEach _tacticalList;	

if (!_isAttached) exitWith {
	['NOT EQUIPPED!  ', 1, warningIcon, colorRed, "warning"] spawn createAlert;
	GW_WAITUSE = false;
};

// Ok it's there, lets see if we can use it
_currentTime = time;
_state = [_type, _currentTime] call checkTimeout;
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
_obj = _vehicle;
_tagData = [_type] call getTagData;
_reloadTime = (_tagData) select 0;
_cost = (_tagData) select 1;
_ammo = _vehicle getVariable ["ammo", 0];

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

// Ok we're good to go, lets launch this!
switch (_type) do {


	// Smoke
	case "SMK":
	{
		[_type, _reloadTime] call createTimeout;
		{
			if (_type == _x select 0) exitWith {
					_obj = _x select 1;				
					[_obj] call smokeBomb;
			};
		} ForEach _tacticalList;	
	};

	// Laser
	case "SHD":
	{
		[_type, _reloadTime] call createTimeout;
		{
			if (_type == _x select 0) exitWith {
				_obj = _x select 1;			
				[_obj, _vehicle] call shieldGenerator;
			};
		} ForEach _tacticalList;	
	};

	// Nitro
	case "NTO":
	{
		[_type, _reloadTime] call createTimeout;
		{
			if (_type == _x select 0) then {
				_obj = _x select 1;				
				[_vehicle, _obj] call nitroBoost;
			};
		} ForEach _tacticalList;				
	};

	// Vertical Thruster
	case "THR":
	{
		[_type, _reloadTime] call createTimeout;
		{
			if (_type == _x select 0) then {
				_obj = _x select 1;	
				[_obj, _vehicle] call verticalThruster;
			};
		} ForEach _tacticalList;	
	};

	// Oil slick
	case "OIL":
	{
		[_type, _reloadTime] call createTimeout;
		{
			if (_type == _x select 0) exitWith {
				_obj = _x select 1;	
				[_obj, _vehicle] spawn oilSlick;		
			};
		} ForEach _tacticalList;	
	};

	// Emergency repair module
	case "REP":
	{			
		{
			if (_type == _x select 0) exitWith {
				_obj = _x select 1;	

				_success = [_vehicle, _obj] call emergencyRepair;

				// Only if we're successful put the item on timeout
				if (_success) then {
					[_type, _reloadTime] call createTimeout;
				};
			};

		} ForEach _tacticalList;	
	};

	// Self Destruct
	case "DES":
	{
		[_type, _reloadTime] call createTimeout;
		[_vehicle] spawn selfDestruct;

		// Allow other devices to be used right away, like mebbe the eject system?
		GW_WAITUSE = false; 
	};

	// Emp
	case "EMP":
	{
		[_type, _reloadTime] call createTimeout;
		{
			if (_type == _x select 0) exitWith {
				_obj = _x select 1;	
				[_obj, _vehicle] call empDevice;
			};
		} ForEach _tacticalList;	
	};

	// Caltrops
	case "CAL":
	{
		[_type, _reloadTime] call createTimeout;
		{
			if (_type == _x select 0) exitWith {
				_obj = _x select 1;		
				[_obj, _vehicle] call dropCaltrops;					
			};
		} ForEach _tacticalList;	
	};


	// Caltrops
	case "MIN":
	{
		[_type, _reloadTime] call createTimeout;
		{
			if (_type == _x select 0) exitWith {
				_obj = _x select 1;		
				[_obj, _vehicle] call dropMines;					
			};
		} ForEach _tacticalList;	
	};

	// Eject System
	case "PAR":
	{
		[_type, _reloadTime] call createTimeout;
		{
			if (_type == _x select 0) exitWith {
				[_vehicle, (driver _vehicle)] call ejectSystem;
			};
		} ForEach _tacticalList;
	};

	// Explosives
	case "EPL":
	{
		[_type, _reloadTime] call createTimeout;
		{
			if (_type == _x select 0) exitWith {
				_obj = _x select 1;		
				[_obj, _vehicle] spawn dropExplosives;						
			};
		} ForEach _tacticalList;	
	};

	// Cloak
	case "CLK":
	{
		[_type, _reloadTime] call createTimeout;
		{
			if (_type == _x select 0) exitWith {
				_obj = _x select 1;		
				[_vehicle] spawn cloakingDevice;
			};
		} ForEach _tacticalList;	
	};

	// Magnet
	case "MAG":
	{
		[_type, _reloadTime] call createTimeout;
		{
			if (_type == _x select 0) exitWith {
				_obj = _x select 1;		
				[_vehicle] spawn magneticCoil;
			};
		} ForEach _tacticalList;	
	};
};

// Reload appropriately
if (_reloadTime > 1) then {	
	playSound3D ["a3\sounds_f\weapons\Reloads\missile_reload.wss", _vehicle, false, getPos _vehicle, 3, 1, 100];
};

GW_WAITUSE = false;


