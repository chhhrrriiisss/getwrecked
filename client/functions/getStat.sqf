//
//      Name: getStat
//      Desc:  Store and retrieve vehicle stat values
//      Return: None
//

_stat =  [_this, 0, "", [""]] call filterParam;
_vName = [_this, 1, "", [""]] call filterParam;
_set = [_this, 2, "", [0]] call filterParam;

if (_vName isEqualTo "") exitWith { 0 };

_index = GW_STATS_ORDER find _stat;
if (_index == -1) exitWith { 0 };

_raw = profileNameSpace getVariable[_vName, []]; 
if (count _raw == 0) exitWith { 0 };	

_data = [_raw,0, [], [[]]] call filterParam;
_meta = [_data,6, [], [[]]] call filterParam;
_stats = [_meta,4, [], [[]]] call filterParam;

if (_index > (count _stats)) then {
	_stats resize _index;
	_set = 0;
};

_var = if (isNil { (_stats select _index) }) then { _set = 0; 0 } else { if (typename (_stats select _index) == "ARRAY") exitWith { 0 }; (_stats select _index) };

if (typename _set != "STRING") then {
	_stats set [_index, _set];
	_meta set[4, _stats];
	_data set[6, _meta];
	_raw set[0, _data];
	profileNameSpace setVariable[_vName, _raw]; 
};

_var

