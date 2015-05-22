//
//      Name: removeItemSupplyBox
//      Desc: Remove an item from a supply box and spawn it nearby
//      Return: None
//

private ['_list', '_index', '_class', '_relPos', '_contents'];

disableSerialization;
_list = ((findDisplay 98000) displayCtrl 98001);
_index = lnbCurSelRow _list;

_class = _list lnbData [_index, 0]; 
_relPos = GW_INVENTORY_BOX modelToWorldVisual [0,3,0];
_relPos set [2, 0];

_ind = 0;

_contents = GW_INVENTORY_BOX getVariable ["GW_INVENTORY", []];
if (count _contents == 0) exitWith {};

{
	
	_q = [_x, 0, 1, [0]] call filterParam;
	_c = [_x, 1, "", [""]] call filterParam;

	if (_c == _class) exitWith {

		if (_q == 1) then {
			_ind = _ind - 1;
			_contents set[_foreachindex, 'x'];
			_contents = _contents - ['x'];
		} else {
			_ind = _foreachindex;
			_q = _q - 1;
			_contents set[_foreachindex, [_q, _c]];
		};
	};

} Foreach _contents;

// Update the inventory
GW_INVENTORY_BOX setVariable ["GW_INVENTORY", _contents, true];
_ind = if (_ind < 0) then { 0 } else { _ind };
[GW_INVENTORY_BOX, _ind] spawn generateInventoryList;

[_relPos, _class] call createObject;