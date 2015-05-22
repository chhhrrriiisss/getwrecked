//
//      Name: findAllObjects
//      Desc: Finds position of all objects with the string stem
//      Return: Array (position data)
//

private ["_stem", "_arr", "_endIf", "_o"];

_stem = [_this,0, "", [""]] call filterParam;
_endIf = [_this,1, false, [false]] call filterParam;	 

if (_stem == "") exitWith { [] };

_arr = [];

for "_i" from 0 to 50 step 1 do {	

	// Determine if object exists
	_o = call compile format['if (!isNil {%1_%2}) exitWith { %1_%2 }; nil', _stem, _i];
	_isObject = if (isNil "_o") then { false } else { true };

	if (!_isObject && _endIf) exitWith {}; // End early if the chain is incomplete
	if (!_isObject && !_endIf) then {} else {			
		_arr pushback _o;	
	};

};

_arr 