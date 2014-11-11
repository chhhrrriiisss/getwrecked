//
//      Name: generateItemsList
//      Desc: Creates a list of purchaseable items in the buy UI
//      Return: None
//

private ['_list', '_sponsor', '_company'];

disableSerialization;
_list = ((findDisplay 97000) displayCtrl 97001);

ctrlShow[97001, true];

// Before clearing, loop through and get existing quantities of any
_listLength = [(lnbSize 97001),0, -1, [0]] call BIS_fnc_param;
	
if (isNil "GW_BUY_CART") then {
	GW_BUY_CART = [];
} else {

	for "_i" from 0 to _listLength step 1 do {

		_value = parseNumber(lnbData [97001, [_i, 0]]);
		_class = lnbData [97001, [_i, 3]];
		_cost = lnbData [97001, [_i, 4]];

		if (!isNil "_value") then {

			if (_value > 0) then {
				GW_BUY_CART pushBack [_class, _value, _cost];
			};
		};

	};

};

lnbClear _list;

_sponsor = player getVariable ["GW_Sponsor", ""];
_company = (_this select 0) getVariable ['company', ''];

_category = lbCurSel 97012;
_filterBy = if (_category > 0) then { 
	
	((GW_CATEGORY_INDEX select _category) select 1)

} else { nil };

{
	
	_class = (_x select 0);	
	_name = (_x select 1);
	_description = (_x select 7);
	_icon = (_x select 9);

	// If the filter list is active, check the class is valid
	_valid = if (!isNil "_filterBy") then {

		_exists = false;
		{	
			if (_class == (_x select 0)) exitWith { _exists = true; };  	
		} ForEach _filterBy;


		_exists

	} else {

		true

	};

	if (!_valid) then {} else {

		_discountCost = [_class, _sponsor, _company] call getCost; // Cost with discounts
		_rawCost = [_class, "", ""] call getCost; // Cost with no discounts
		_difCost = ((_rawCost - _discountCost) / _rawCost);

		_colour = [1,1,1,0.5];

		// Change colour depending on significance of discount
		_colour = if (_difCost == 0) then { 
			[1,1,1,0.5] 
		} else { 
		
			if (_difCost <= 0.1) then {
				[1,1,1,1]
			} else {
				colorOrange
			};	
		};

		_cost = if (_discountCost > 0) then { format['$%1', ([_discountCost] call numberToCurrency)] } else { '' };

		_quantity = 0;
		{
			if (_x select 0 == _class) exitWith { _quantity = _x select 1; };
			false
		} count GW_BUY_CART > 0;

		_quantityString = if (_quantity > 0) then { format['%1x', _quantity] } else { "-" };

		_list lnbAddRow[_quantityString, "", _name, "", _cost];		

		lnbSetData [97001, [((((lnbSize 97001) select 0)) -1), 0], _quantity]; // Quantity
		lnbSetData [97001, [((((lnbSize 97001) select 0)) -1), 4], format['%1', _discountCost]]; // Cost
		lnbSetData [97001, [((((lnbSize 97001) select 0)) -1), 3], _class];		 // Class

		// Set the colour if it's discounted
		lnbSetColor [97001, [((((lnbSize 97001) select 0)) -1), 4], _colour];
		
		// Include an icon if we're fancy like that
		if (!isNil "_icon") then {
			_list lnbSetPicture[[((((lnbSize 97001) select 0)) -1), 1], _icon];
		};
	};

	false

} count GW_LOOT_LIST > 0;

_list lnbSetCurSelRow 0;
