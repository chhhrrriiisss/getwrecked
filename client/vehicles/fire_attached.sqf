//
//      Name: fireAttached
//      Desc: Critical function used to fire weapons from a vehicle
//		Return: None
//

if (GW_WAITFIRE) exitWith { };

GW_WAITFIRE = true;

_type = [_this,0, "", [""]] call BIS_fnc_param;
_vehicle = [_this,1, objNull, [objNull]] call BIS_fnc_param;
_fireMode = [_this,2, "AUTO", [""]] call BIS_fnc_param;

if (isNull _vehicle || _type == "") exitWith { GW_WAITFIRE = false; };

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
	GW_WAITFIRE = false;
};

// Is the specific item currently attached?
_isAttached = false;
{
	if (_type == _x select 0) exitWith {
		_isAttached = true;	
	};

} ForEach _weaponsList;	

if (!_isAttached) exitWith {
	['NOT EQUIPPED! ', 1, warningIcon, colorRed, "warning"] spawn createAlert;
	GW_WAITFIRE = false;
};

// Ok it's there, lets see if we can use it
_currentTime = time;
_state = [_type, _currentTime] call checkTimeout;
_timeLeft = _state select 0;
_found = _state select 1;

// Is the device on timeout?
if (_timeLeft > 0 && _found) exitWith {

		if ( _type == "HMG" || _type == "GMG" || _type == "FLM") then {} else {
			[format['RELOADING (%1s)', round(_timeLeft)], 0.5, warningIcon, nil, "flash"] spawn createAlert;
		};
		GW_WAITFIRE = false;
};	

// Check we have enough ammo
_tagData = [_type] call getTagData;
_reloadTime = _tagData select 0;
_cost = _tagData select 1;

// Do we have enough ammo? Flamethrower is an exception
if (_ammo < _cost && _type != "FLM") exitWith {	
	["NEED AMMO ", 0.3, warningIcon, colorRed, "warning"] spawn createAlert;
	GW_WAITFIRE = false;
};

// Ok we're good to go, lets fire something!
switch (_type) do {

	// HMG
	case "HMG":
	{	
		// Enforce a reload time
		[_type, _reloadTime] call createTimeout;

		_count = 0;
		_found = false;

		{
			if (_type == _x select 0) then {

				_obj = _x select 1;	

				if (_obj in GW_ACTIVE_WEAPONS) then {
					_target = GW_TARGET;
					[_obj, _target, _vehicle] spawn fireHmg;
					_count = _count + 1;
				};						
			};	
		} ForEach _weaponsList;	

		// Multiply cost by the number of guns fired
		_cost = _cost * _count;
	};


	// GMG
	case "GMG":
	{
		_count = 0;
		_found = false;

		{

			if (_type == _x select 0) then {

				_obj = _x select 1;			

				if (_obj in GW_ACTIVE_WEAPONS) then {
					_target = GW_TARGET;		
					[_obj, _target] spawn fireGmg;
					_count = _count + 1;
				};	
			};
		} ForEach _weaponsList;	

		_reloadTime = _reloadTime * _count;
		_cost = _cost * _count;
		[_type, _reloadTime] call createTimeout;
	};

	// RPG
	case "RPG":
	{
		_count = 0;	
		_found = false;		

		{
			if (_type == _x select 0) then {

				_obj = _x select 1;	

				if (_obj in GW_ACTIVE_WEAPONS) then {	
					_target = GW_TARGET;			
					[_obj, _target, _vehicle] spawn fireRpg;	
					_count = _count + 1;
				};	
			};
		} ForEach _weaponsList;	

		_reloadTime = _reloadTime * _count;
		_cost = _cost * _count;
		[_type, _reloadTime] call createTimeout;

	};

	// Guided
	case "GUD":
	{
		_count = 0;			
		[_type, _reloadTime] call createTimeout;

		{
			if (_type == _x select 0) exitWith {
				_obj = _x select 1;	
				_target = GW_TARGET;		
				[_obj, _target, _vehicle] spawn fireGuided;				
			};
		} ForEach _weaponsList;			

	};

	// Lock on
	case "MIS":
	{
		// No locked targets, abort
		if (count GW_LOCKEDTARGETS <= 0) exitWith {
			_reloadTime = 0;
			_cost = 0;
		};	
		
		_count = 0;
		{
			if (_type == _x select 0) then {

				_obj = _x select 1;	

				if (_obj in GW_ACTIVE_WEAPONS) then {	
					[_obj, _vehicle] spawn fireLockOn;
					_count = _count + 1;
				};
			};
		} ForEach _weaponsList;	

		_reloadTime = _reloadTime * _count;
		_cost = _cost * _count;
		[_type, _reloadTime] call createTimeout;
	};

	// MOR
	case "MOR":
	{		
		_count = 0;
		_found = false;

		{
			if (_type == _x select 0) then {
				_obj = _x select 1;	

				if (_obj in GW_ACTIVE_WEAPONS) then {
					_target = GW_SCREEN;	
					[_obj, _target] spawn fireMortar;
					_count = _count + 1;
				};			
			};

		} ForEach _weaponsList;	

		_reloadTime = _reloadTime * _count;
		_cost = _cost * _count;
		[_type, _reloadTime] call createTimeout;
	};


	// Laser
	case "LSR":
	{
		_count = 0;
		_found = false;
		
		{
			if (_type == _x select 0) then {

				_obj = _x select 1;				

				if (_obj in GW_ACTIVE_WEAPONS) then {
					_target = GW_TARGET;		
					[_obj, _target, _vehicle] spawn fireLaser;
					_count = _count + 1;
				};			
			};

			if (_found) exitWith {};

		} ForEach _weaponsList;	

		_reloadTime = _reloadTime * _count;
		_cost = _cost * _count;
		[_type, _reloadTime] call createTimeout;
	};

	// Railgun
	case "RLG":
	{
		_count = 0;			
		{
			if (_type == _x select 0) then {
				_obj = _x select 1;			

				if (_obj in GW_ACTIVE_WEAPONS) then {
					_target = GW_TARGET;			
					[_obj, _target, _vehicle] spawn fireRail;
					_count = _count + 1;
				};
			};
		} ForEach _weaponsList;	

		_reloadTime = _reloadTime * _count;
		_cost = _cost * _count;
		[_type, _reloadTime] call createTimeout;
	};

	// Flamethrower
	case "FLM":
	{
		_count = 0;			
		{
			if (_type == _x select 0) then {
				_obj = _x select 1;			

				if (_obj in GW_ACTIVE_WEAPONS) then {
					_target = GW_TARGET;			
					[_obj, _target, _vehicle] spawn fireFlamethrower;
					_count = _count + 1;
				};
			};
		} ForEach _weaponsList;	

		_reloadTime = _reloadTime * _count;
		_cost = _cost * _count;
		[_type, _reloadTime] call createTimeout;
	};

	default
	{
		['Error!    ', 1, warningIcon, colorRed] spawn createAlert;
	};
};

_newAmmo = _ammo - _cost;
if (_newAmmo < 0) then { _newAmmo = 0; };
_vehicle setVariable["ammo", _newAmmo];

GW_WAITFIRE = false;

