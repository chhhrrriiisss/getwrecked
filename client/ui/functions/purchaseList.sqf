//
//      Name: purchaseList
//      Desc: Try and purchase selected items in the buy menu
//      Return: None
//

private ['_final', '_totalCost', '_totalItems', '_inventory'];
	
disableSerialization;
_list = (findDisplay 97000 displayCtrl 97001);
_button = (findDisplay 97000 displayCtrl 97003);

_final = [] call calculateTotal;
_totalCost = [_final,0, 0, [0]] call BIS_fnc_param;
_totalItems = [_final,1, 0, [0]] call BIS_fnc_param;

if (_totalItems == 0 || _totalCost == 0) exitWith {};

_inventory = _final select 2;

_index = lnbcurselrow _list;

// Is there actually anything selected?
if (_totalItems <= 0 && isNil "_index") exitWith {	['NO ITEMS'] spawn showPurchaseMessage;	};

// Is just one item selected, just buy that
if (_totalItems <= 0 && !isNil "_index") then {

	_cost = lnbData [97001, [_index, 4]];
	_class = lnbData [97001, [_index, 3]];

	systemchat format['%1 / %2', _class, time];

	_totalCost = parseNumber( _cost );
	_inventory = [[1, _class]];
	_totalItems = 1;
};

// Is there actually anything selected?
if (_totalItems > GW_INVENTORY_LIMIT) exitWith {	['TOO MANY ITEMS'] spawn showPurchaseMessage;	};

// Do we have enough moolah for this?
if (GW_BALANCE - _totalCost < 0) exitWith {	['INSUFFICIENT FUNDS'] spawn showPurchaseMessage; };

_totalItemsString = if (_totalItems > 1) then { (format['%1 items', _totalItems]) } else { (format['%1 item', _totalItems]) };
_result = ['CONFIRM PURCHASE', format[' $%1 (%2)', ([_totalCost] call numberToCurrency), _totalItemsString], 'CONFIRM'] call createMessage;

if (_result) then {
	
	_success = -_totalCost call changeBalance;

	// Display a message depending on result of transaction
	if (_success) then {
		['PURCHASE COMPLETE!', 2, successIcon, nil, "slideDown"] spawn createAlert; 
	} else {
		['ERROR!', 2, warningIcon, colorRed, "slideDown"] spawn createAlert; 
		_result = false;
	};
};

if (!_result) exitWith {};

// If we're buying one item, just spawn it nearby, otherwise make a supply box
if (_totalItems > 1) then {
	[_inventory] spawn requestSupplyBox;	
} else {

	_type = ((_inventory select 0) select 1);
	_relPos = player modelToWorld [0.25,0,0];

	pubVar_spawnObject = [_type, _relPos, true];
	publicVariableServer "pubVar_spawnObject"; 	
};

closeDialog 0;