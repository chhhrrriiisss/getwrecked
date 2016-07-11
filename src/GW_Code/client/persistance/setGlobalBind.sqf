//
//      Name: setGlobalBind
//      Desc: Set key for a global bind
//      Return: None
//

params ['_tag', '_key'];
private ['_tag', '_key'];

_globalBinds = [] call listGlobalBinds;
_found = false;

{
	if (_tag == (_x select 0)) exitWith {
		_x set [1, _key];
		_found = true;
	};
} foreach _globalBinds;

if (!_found) exitWith {};

profileNamespace setVariable [GW_BINDS_LOCATION, _globalBinds]; 
// saveProfileNamespace;  
