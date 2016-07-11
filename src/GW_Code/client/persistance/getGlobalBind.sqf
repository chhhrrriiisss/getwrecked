//
//      Name: getGlobalBind
//      Desc: Set key for a global bind
//      Return: None
//

params ['_tag'];
private ['_tag', '_found', '_globalBinds'];

_globalBinds = [] call listGlobalBinds;
_found = nil;

{
	if (_tag == (_x select 0)) exitWith {
		_found = parseNumber (_x select 1);
	};
} foreach _globalBinds;

if (!isNil "_found") exitWith { _found };

-1
