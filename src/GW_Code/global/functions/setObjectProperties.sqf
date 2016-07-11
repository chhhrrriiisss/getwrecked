//
//      Name: setObjectProperties
//      Desc: Set handlers and object variables for items
//      Return: None
//

private["_obj"];

_obj = [_this,0, objNull, [objNull]] call filterParam;

if (isNull _obj) exitWith {};
if (!alive _obj) exitWith {};

_type = _obj getVariable ["GW_Tag", ''];
_existingData = _obj getVariable ["GW_Data", nil];

if (!isNil "_existingData") exitWith {};

_data = [_type, GW_LOOT_LIST] call getData;
if (isNil "_data") exitWith { _obj setVariable ['GW_Data', "['Bad data', 0, 0, 0, '']"]; };

// 0 Name, 1 mass, 2 ammo, 3 fuel, 4 tag, 5 default health
_packet = format['%1', [(_data select 1), (_data select 2), (_data select 4), (_data select 5), (_data select 6), (_data select 3)] ];

_obj setVariable ['GW_Data', _packet];

true

