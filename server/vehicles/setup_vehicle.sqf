//
//      Name: setupVehicle
//      Desc: Initializes a vehicle ready for playing
//      Return: None
//

private ['_data', '_vehicle', '_name', '_respawn', '_recreate', '_defaultAmmo', '_defaultFuel'];

_vehicle = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_name = [_this,1, "Untitled", [""]] call BIS_fnc_param;
_respawn = [_this,2, true] call BIS_fnc_param;
_recreate = [_this,3, false] call BIS_fnc_param;

if (isNull _vehicle) exitWith { diag_log 'Couldnt initialize vehicle.'; };

// Prevent access temporarily
_vehicle lockDriver true;
_vehicle lockCargo true;
_vehicle lockTurret [[0], true];

if (count toArray _name == 0 || _name == " ") then {  _name == 'Untitled'; };

// Custom
_vehicle setVariable["name", _name, true]; 

// Static
_vehicle setVariable["isVehicle", true, true]; 
_vehicle setVariable["killedBy", nil, true]; 
_vehicle setVariable["owner", '', true]; 
_vehicle setVariable["status", [], true]; 

_mass = getMass _vehicle;
if (isNil "_mass") then { _mass = 5000; };

_data = [typeOf _vehicle, GW_VEHICLE_LIST] call getData;
if (isNil "_data") exitWith { false };

_defaultAmmo = if (!isNil "_data") then { ((_data select 2) select 3) } else { 1 };
_defaultFuel = if (!isNil "_data") then { ((_data select 2) select 4) } else { 1 };
_signature = if (!isNil "_data") then { ((_data select 2) select 7) } else { "Low" };
_armor = if (!isNil "_data") then { ((_data select 2) select 6) } else { 1 };

// Defaults used locally when compiled on client
_vehicle setVariable["GW_defaults", [
    
    ['armor', _armor, true],
    ['signature', _signature, true],
    ['health', 100, true],
    ['fuel', 0, false],
    ['ammo', 1, false],
    ['maxAmmo', _defaultAmmo, false],
    ['maxFuel', _defaultFuel, false],
    ['weapons', [], false],
    ['tactical', [], false],
    ['special', [], false],
    ['mass', _mass, false],
    ['lockOns', false, false]

], true];

[_vehicle] call setVehicleHandlers;

clearWeaponCargoGlobal _vehicle;
clearMagazineCargoGlobal _vehicle;
clearItemCargoGlobal _vehicle;

if (_respawn) then {
    [_vehicle, GW_ABANDON_DELAY] spawn setVehicleRespawn;
};


true