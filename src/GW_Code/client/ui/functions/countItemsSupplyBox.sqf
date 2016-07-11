//
//      Name: countItemsSupplyBox
//      Desc: Counts the number of items in a supply box
//      Return: Number of items
//

private ['_box', '_inv'];
params ['_box'];

_inv = _box getVariable ["GW_INVENTORY", []];
_total = 0;

if (count _inv <= 0) exitWith { _total };

{
	_total = _total + (_x select 0);
	false
} count _inv > 0;

_total
