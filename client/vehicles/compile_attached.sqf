//
//      Name: compileAttached
//      Desc: Critical function used to calculate data for a vehicle based off of its attachments
//		Return: None
//

private['_vehicle', '_o', '_obj'];

if (GW_WAITCOMPILE) exitwith {};
GW_WAITCOMPILE = true;

_vehicle = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _vehicle) exitWith { GW_WAITCOMPILE = false; };
if (!alive _vehicle) exitWith { GW_WAITCOMPILE = false; };
	
_attachedObjects = attachedObjects _vehicle;

_vehicle lockDriver true;
_vehicle lockCargo true;

// Gather any previous values on the vehicle
_prevAmmo = _vehicle getVariable ["ammo", nil];
_prevFuel = (fuel _vehicle) + (_vehicle getVariable ["fuel", 0]);	
[_vehicle] call setDefaultData;

_attachedValue = 0;

{
	_obj = _x;

	if (!alive _obj) then {

		deleteVehicle _obj;

	} else {

		[_obj, _vehicle] call calcMass;
		[_obj, _vehicle] call calcFuel;
		[_obj, _vehicle] call calcAmmo;

		_weapons = _obj getVariable ["weapons", nil];

		if (!(isNil "_weapons")) then {
			[_obj, _vehicle, _weapons] call calcWeapons;
		};

		_tactical = _obj getVariable ["tactical", nil];

		if (!(isNil "_tactical")) then {
			[_obj, _vehicle, _tactical] call calcTactical;
		};

		_special = _obj getVariable ["special", nil];

		if (!(isNil "_special")) then {
			[_obj, _vehicle, _special] call calcSpecial;
		};

		_class = if (typeOf _obj == "groundWeaponHolder") then { (_obj getVariable "type") } else { typeOf _obj };
		_value = [_class, "", ""] call getCost;
		_attachedValue = _attachedValue + _value;
	};

	false
	
} count _attachedObjects > 0;

// Calculate and set vehicle value
_vehicleValue = [typeOf _vehicle, "", ""] call getCost;
_totalValue = _attachedValue + _vehicleValue;
_vehicle setVariable ["GW_Value", _totalValue];

// Add actions to the vehicle
[_vehicle] call setVehicleActions;

// Automatically max out fuel/ammo if we're in the workshop
if (GW_CURRENTZONE == "workshopZone") then {

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

if (GW_CURRENTZONE != "workshopZone") then {
	_vehicle lockDriver false;
};

GW_WAITCOMPILE = false;

if (isNil { _vehicle getVariable "firstCompile" }) then {
	_vehicle setVariable ["firstCompile", true];
};

true