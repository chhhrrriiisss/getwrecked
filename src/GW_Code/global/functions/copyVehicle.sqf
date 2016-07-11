_data = [_this, 0, [], [[]]] call filterParam;
_sender = [_this, 1, "", [""]] call filterParam;

if (count _data == 0) exitWith {};
if (_sender == name player) exitWith {};

_vName = (_data select 0) select 1;

systemchat format['%1 shared %2, type !accept %2 to copy.', ([_sender, 10] call cropString), _vName];

if (isNil "GW_SHARED_ARRAY") then { GW_SHARED_ARRAY = []; };
GW_SHARED_ARRAY pushBack (_data select 0);