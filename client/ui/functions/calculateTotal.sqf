//
//      Name: calculateTotal
//      Desc: Runs through every item in the purchase list and calculates cost
//      Return: Array (Total Cost, Number of Items, List of Items)
//

private ['_total', '_size', '_value', '_cost', '_subtotal', '_total'];

_total = 0;
_size = [(lnbSize 97001),0, -1, [0]] call BIS_fnc_param;
_itemCount = 0;
_inventory = [];

if (_size == -1) exitWith { [0,0,0] };
	
for "_i" from 0 to _size step 1 do {

	_value = lnbData [97001, [_i, 0]];

	// If it's actually got a quantity
	if (count toArray _value > 0) then {

		_cost = lnbData [97001, [_i, 4]];
		_class = lnbData [97001, [_i, 3]];

		_subtotal = (parseNumber _value) * (parseNumber _cost);
		
		_total = _total + _subtotal;		
		_itemCount = _itemCount + (parseNumber _value);
		_inventory set [count _inventory, [(parseNumber _value), _class] ];
	};
};

disableSerialization;
_text = ((findDisplay 97000) displayCtrl 97005);
_text ctrlSetText format['TOTAL: $%1', ([_total] call numberToCurrency)];
_text ctrlCommit 0;

[_total, _itemCount, _inventory]

