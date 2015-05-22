//
//      Name: markAsKilledBy
//      Desc: Tags a vehicle as killed by the local player
//      Return: None
//

private ['_v', '_m'];

_v = [_this, 0, objNull, [objNull]] call filterParam;
_m = [_this, 1, "", [""]] call filterParam;

if (isNull _v) exitWith {};
if (!alive _v) exitWith {};

// Don't tag our own vehicle
if (_v == GW_CURRENTVEHICLE) exitWith {};
if !(_v isKindOf "Car") exitWith {};

_v setVariable['killedBy', format['%1', [name player, _m, (GW_CURRENTVEHICLE getVariable ['name', '']), (typeOf GW_CURRENTVEHICLE) ] ], true];	
_driver = driver _v;

if (isNil "GW_LASTTAGGEDMESSAGE") then { GW_LASTTAGGEDMESSAGE = time - 0.3; };
if (GW_DEBUG && (time - GW_LASTTAGGEDMESSAGE > 0.3)) then {
	systemChat format['Tagged %1', _v]; 
};