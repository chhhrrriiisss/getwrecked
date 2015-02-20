//
//      Name: filterParam
//      Desc: Indentical usage to bis_fnc_param, but faster
//      Return: Variable (filtered)
//

private ['_val', '_var'];

if (isNil { (_this select 0) select (_this select 1) }) exitWith { (_this select 2) };

_var = (_this select 0) select (_this select 1);
_val = (_this select 2);

{
	if (typename _x == typename _var) exitWith { _val = _var; false };
	false
} count (_this select 3);

_val