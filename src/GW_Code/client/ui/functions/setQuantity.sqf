//
//      Name: setQuantity
//      Desc: Sets the desired quantity of items in a buy menu row via a dialog prompt
//      Return: None
//

private ['_index', '_currentValue', '_currentValue', '_result'];


_index = [_this,1, -1, [0]] call filterParam;
if (_index == -1) exitWith {};

_currentValue = lnbData [97001, [_index, 0]];
_currentValue = if (count toArray _currentValue <= 0) then { '1' } else { _currentValue };
_result = ['ENTER QUANTITY', _currentValue, 'INPUT'] call createMessage;

if (_result isEqualType "") then {

	if (count toArray _result > 0) then {

		// If the quantity is zero, just clear the row
		if (_result == "0") then {

			lnbSetText [97001, [_index, 0], "-"];
			lnbSetData [97001, [_index, 0], ""];

		} else {
			lnbSetText [97001, [_index, 0], format['%1x', _result]];
			lnbSetData [97001, [_index, 0], format['%1', _result]];
		};

	};
};

// Recalculate total cost so we're up to date
_null = [] call calculateTotal;