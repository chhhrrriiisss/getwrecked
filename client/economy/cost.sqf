//
//      Name: getCost
//      Desc: Returns price of item (including respective discounts)
//      Return: Number (The cost)
//

private ['_item', '_sponsor', '_company', '_building', '_weapons', '_name', '_arr', '_cost', '_class'];

_item = [_this,0, "", [""]] call filterParam;
_sponsor = [_this,1, "", [""]] call filterParam;
_company = [_this,2, "", [""]] call filterParam;

_cost = 0;
_discount = 1;

// Sponsor matches company
if (_sponsor == _company && _sponsor != "" && _company != "") then { _discount = 0.9; }; // 10% for sponsor match

// Loop through all categories to determine company matches
{

	_name = _x select 0;
	_arr = _x select 1;

	{
		_class = (_x select 0);
		if ( _class == _item) exitWith {
			if (_company == _name) then { _discount = _discount - 0.25; }; // 25% for company
			_cost = ((_x select 1) * _discount);
		};
		false
	} count _arr > 0;
	false
} count [	
	["slytech", GW_LOOT_BUILDING],
	["terminal", GW_LOOT_WEAPONS],
	["gastrol", GW_LOOT_PERFORMANCE],
	["cognition", GW_LOOT_DEPLOYABLES],
	["crisp", GW_LOOT_INCENDIARY],
	["tank", GW_LOOT_DEFENCE],
	["veneer", GW_LOOT_EVASION],
	["haywire", GW_LOOT_ELECTRONICS],
	["nocategory", GW_LOOT_VEHICLES],
	["nocategory", GW_LOOT_MELEE]
] > 0;

_cost
