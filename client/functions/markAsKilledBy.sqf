//
//      Name: markAsKilledBy
//      Desc: Tags a vehicle as killed by the local player
//      Return: None
//

private ['_v'];

_v = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _v) exitWith {};
if (!alive _v) exitWith {};

_v setVariable['killedBy', GW_PLAYERNAME, true];	

_driver = driver _v;

// Oh look! There's a driver
if (!isNil "_driver") then {
	_driver setVariable['killedBy', GW_PLAYERNAME, true];	
};

if (GW_DEBUG) then { systemChat format['Tagged %1', _v]; };