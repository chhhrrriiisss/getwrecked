//
//      Name: requestSupplyBox
//      Desc: Create a new supply box and populate it with items
//      Return: None
//

private ['_inventory', '_objs'];

_inventory = [_this,0, [], [[]]] call filterParam;
if (count _inventory <= 0) exitWith {};

// Is there an existing box nearby?
_objs = nearestObjects [getPos player, [], 8];

GW_NEW_SUPPLY_BOX = nil;
{
	_isSupply = (_x call isSupplyBox);
	_isOwner = [_x, player, false] call checkOwner;

	if (_isSupply && _isOwner) exitWith {
		GW_NEW_SUPPLY_BOX = _x;
	};
	false
} count _objs > 0;

// If there's no nearby box then make one
if (isNil { GW_NEW_SUPPLY_BOX }) then {
	GW_NEW_SUPPLY_BOX = nil;		
	GW_NEW_SUPPLY_BOX = [(player modelToWorld [1,0,0])] call createSupplyBox;
};	

// Fill the new box with goodies
if (!isNil "GW_NEW_SUPPLY_BOX" ) then {
	GW_NEW_SUPPLY_BOX setPos (player modelToWorld [1.5,0,0]);
	_contents = GW_NEW_SUPPLY_BOX getVariable ["GW_Inventory", []];

	_count = [GW_NEW_SUPPLY_BOX] call countItemsSupplyBox;
	if (_count < GW_INVENTORY_LIMIT) then { _contents = _contents + _inventory; } else {
		systemChat 'Supply box full, some items may have been lost.'
	};	

	GW_NEW_SUPPLY_BOX setVariable ["GW_Inventory", _contents, true];
	GW_NEW_SUPPLY_BOX setVariable ["GW_Owner", name player, true];		
	GW_NEW_SUPPLY_BOX setVariable ["GW_CU_IGNORE", false, true];	

	GW_NEW_SUPPLY_BOX spawn newItemsSupplyBox;

} else {
	systemChat 'Error creating supply box';
};