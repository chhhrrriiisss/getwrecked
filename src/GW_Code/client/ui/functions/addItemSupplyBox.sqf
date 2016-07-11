//
//      Name: addItemSupplyBox
//      Desc: Adds an item to the inventory in a supply box
//      Return: None
//

private ['_box', '_item', '_class', '_contents', '_data'];
params ['_box', '_item'];

_tag = _item getVariable ['GW_Tag', ''];
_data = [_tag, GW_LOOT_LIST] call getData;
if (isNil "_data") exitWith {};
_class = _data select 0;

_box setVariable ["GW_CU_IGNORE", false, true];
_contents = _box getVariable ["GW_INVENTORY", []];
_count = [_box] call countItemsSupplyBox;

if (_count >= GW_INVENTORY_LIMIT) exitWith { systemChat 'Supply box full.'; };

deleteVehicle _item;

_exists = false;
{
	_q = _x select 0;
	_c = _x select 1;

	if (_c == _class) exitWith {
		_exists = true;
		_q = _q + 1;
		_contents set[_foreachindex, [_q, _class]];		
	};

} ForEach _contents;

if (!_exists) then {
	_contents set [count _contents, [1, _class]];
};

_box setVariable ["GW_INVENTORY", _contents, true];	
_box spawn newItemsSupplyBox;

