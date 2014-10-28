//
//      Name: generateItemsList
//      Desc: Creates a list of purchaseable items in the buy UI
//      Return: None
//

private ['_list', '_sponsor', '_company'];

disableSerialization;
_list = ((findDisplay 97000) displayCtrl 97001);

ctrlShow[97001, true];

lnbClear _list;

_sponsor = player getVariable ["GW_Sponsor", ""];
_company = (_this select 0) getVariable ['company', ''];

{
	
	_class = (_x select 0);	
	_name = (_x select 1);
	_description = (_x select 7);
	_icon = (_x select 9);

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
	_list lnbAddRow["-", "", _name, "", _cost];
	lnbSetData [97001, [((((lnbSize 97001) select 0)) -1), 4], format['%1', _discountCost]];
	lnbSetData [97001, [((((lnbSize 97001) select 0)) -1), 3], _class];		

	// Set the colour if it's discounted
	lnbSetColor [97001, [((((lnbSize 97001) select 0)) -1), 4], _colour];
	
	// Include an icon if we're fancy like that
	if (!isNil "_icon") then {
		_list lnbSetPicture[[((((lnbSize 97001) select 0)) -1), 1], _icon];
	};

	false

} count GW_LOOT_LIST > 0;

_list lnbSetCurSelRow 0;