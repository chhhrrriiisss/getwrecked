//
//      Name: markAsKilledBy
//      Desc: Tags a vehicle as killed by the local player
//      Return: None
//

private ['_v', '_m'];

_v = _this select 0;
_m = if (isNil {_this select 1}) then { "" } else { _this select 1; };

if (isNull _v) exitWith {};
if (!alive _v) exitWith {};

// Don't tag our own vehicle
if (_v == GW_CURRENTVEHICLE) exitWith {};

_v setVariable['killedBy', [GW_PLAYERNAME, _m, (GW_CURRENTVEHICLE getVariable ['name', '']), (typeOf GW_CURRENTVEHICLE) ], true];	

_driver = driver _v;

// Oh look! There's a driver
if (!isNil "_driver") then {
	_driver setVariable['killedBy', [GW_PLAYERNAME, _m, (GW_CURRENTVEHICLE getVariable ['name', '']), (typeOf GW_CURRENTVEHICLE) ], true];	
};

if (GW_DEBUG) then { systemChat format['Tagged %1', _v]; };