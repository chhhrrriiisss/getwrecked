//
//      Name: compileAttached
//      Desc: Critical function used to calculate data for a vehicle based off of its attachments
//		Return: None
//

private['_vehicle', '_obj', '_tag'];

if (GW_WAITCOMPILE) exitwith {};
GW_WAITCOMPILE = true;

_vehicle = [_this,0, objNull, [objNull]] call filterParam;

if (isNull _vehicle) exitWith { GW_WAITCOMPILE = false; };
if (!alive _vehicle) exitWith { GW_WAITCOMPILE = false; };
	
_attachedObjects = attachedObjects _vehicle;

_isAi = _vehicle getVariable ['isAI', false];

if (!_isAi) then {
	_vehicle lock true;
	_vehicle lockCargo true;
};

// Gather any previous values on the vehicle
_prevAmmo = _vehicle getVariable ["ammo", nil];
_prevFuel = (fuel _vehicle) + (_vehicle getVariable ["fuel", 0]);	
[_vehicle] call setDefaultData;

// Check for max limits or old items and prune
if (GW_CURRENTZONE == "workshopZone" || isServer) then { _vehicle call cleanAttached; };

_attachedValue = 0;
_maxMass = _vehicle getVariable ['maxMass', 99999];
_defaultMass = _vehicle getVariable ['mass', 1000];
_massModifier = _vehicle getVariable ['massModifier', 1];
_combinedMass = 0;

{
	_obj = _x;
	
	if (!alive _obj || !(_obj call isObject)) then {
		//deleteVehicle _obj;
	} else {

		// Get all the data we need
		[_obj] call setObjectProperties;
		_oData = _obj getVariable ['GW_Data','["Bad data", 0, 0, 0, 0]'];
		_oData = call compile _oData;
		_tag = _obj getVariable ["GW_Tag", ''];

		// Add object mass to vehicle				
		_oMass = (_oData select 1) * _massModifier;
		_combinedMass = _combinedMass + _oMass;

		// Add any fuel to vehicle
		_fuel = (_oData select 3);
		if (_fuel > 0) then { _vehicle setVariable["maxFuel", (_vehicle getVariable "maxFuel") + _fuel]; };

		// Add any ammo to vehicle
		_ammo = (_oData select 2);
		if (_ammo > 0) then { _vehicle setVariable["maxAmmo", (_vehicle getVariable "maxAmmo") + _ammo]; };

		// Add weapon to vehicle reference
		_isWeapon = _obj call isWeapon;
		_isModule = _obj call isModule;
		_isSpecial = _obj call isSpecial;
		_isHolder = _obj call isHolder;

		if (_isWeapon || _isModule || _isSpecial) then { 			

			// Binds only for active modules and weapons
			_bind = if (_isWeapon || _isModule) then {
				_bind = _obj getVariable ['GW_KeyBind', ["-1", "1"]];
				_bind = if (_bind isEqualTo []) then { (_bind select 1) } else { _bind };	
				_bind
			} else { [] };	

			_arrayTarget = if (_isWeapon) then { "weapons" } else {
				if (_isModule) exitWith { "tactical" }; "special"
			};

			// Calculate default direction for weapons
			if (_isWeapon) then {				

				// Calculate the relative angle of the weapon
				_vehDir =  getDir _vehicle;
				_wepDir = getDir _obj;

				// Custom target offsets for different items
				_dirOffset = _tag call {
					if (_this in ["LSR", "FLM"]) exitWith { 180 };
					if (_this in ["RPD"]) exitWith { -90 };
					0		
				};

				if (_isHolder) then { _dirOffset = 90; };

				_actualDir = [_wepDir - _vehDir] call normalizeAngle;
				_defaultDir = [_actualDir + _dirOffset] call normalizeAngle;

				_obj setVariable ['GW_defaultDirection', _defaultDir];

				if (_tag in GW_LOCKONWEAPONS) then { _vehicle setVariable["lockOns", true];	};
			};		

			// Adjust vehicle quick reference arrays
			_array = _vehicle getVariable [_arrayTarget, []];

			if (_isWeapon || _isModule) exitWith {
				_array = _array + [[_tag, _obj, _bind]];
				_vehicle setVariable[_arrayTarget, _array];	
			};

			if (!(_tag in _array)) then {
				_array pushBack _tag;
				_vehicle setVariable[_arrayTarget, _array];	
			};		
	
		};

		_class = if (_isHolder) then {
			(([_tag, GW_LOOT_LIST] call getData) select 0)
		} else { (typeOf _obj) };

		_value = [_class, "", ""] call getCost;
		_attachedValue = _attachedValue + _value;
	
	};

} count _attachedObjects > 0;

// Apply combined mass to vehicle
_isAi = _vehicle getVariable ['isAI', false];
_newMass = if (!_isAi) then { ([_combinedMass, _defaultMass, _maxMass] call limitToRange) } else { _defaultMass };
_vehicle setMass _newMass;

// Calculate and set vehicle value
_vehicleValue = [(typeOf _vehicle), "", ""] call getCost;
_totalValue = _attachedValue + _vehicleValue;
_vehicle setVariable ["GW_Value", _totalValue];

// Add actions to the vehicle
[_vehicle] call setVehicleActions;

// Automatically max out fuel/ammo if we're in the workshop
if (isNil "GW_CURRENTZONE") then { GW_CURRENTZONE == "workshopZone" };
if (GW_CURRENTZONE == "workshopZone" || isServer) then {

	_maxAmmo = _vehicle getVariable ["maxAmmo", 1];
	_vehicle setVariable ["ammo", _maxAmmo];

	_maxFuel = _vehicle getVariable ["maxFuel", 1];
	_vehicle setFuel 1;
	if (_maxFuel > 1) then {
		_vehicle setVariable ["fuel", (_maxFuel -1)];
	} else {
		_vehicle setVariable ["fuel", 0];
	};

} else {

	// Restore previous fuel and ammo
	if (!isNil "_prevAmmo") then {
		_maxAmmo = _vehicle getVariable ["maxAmmo", 1];
		if (_prevAmmo > _maxAmmo) then {_prevAmmo = _maxAmmo; };
		_vehicle setVariable ["ammo", _prevAmmo];
	};

	_maxFuel = _vehicle getVariable ["maxFuel", 1];
	if (_prevFuel > _maxFuel) then {_prevFuel = _maxFuel; };
	if (_prevFuel > 1) then {
		_vehicle setFuel 1;
		_vehicle setVariable ["fuel", (_prevFuel - 1)];		

	} else {
		_vehicle setFuel _prevFuel;
	};
};

if (GW_CURRENTZONE != "workshopZone" && !isDedicated) then {
	_vehicle setVehicleLock "UNLOCKED";
};

GW_WAITCOMPILE = false;

if (isNil { _vehicle getVariable "firstCompile" }) then {
	_vehicle setVariable ["firstCompile", true];
};

true