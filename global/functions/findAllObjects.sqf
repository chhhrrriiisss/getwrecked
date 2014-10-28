//
//      Name: findAllObjects
//      Desc: Finds position of all objects with the string stem
//      Return: Array (position data)
//

private ["_stem", "_arr", "_endIf", "_o"];

_stem = [_this,0, "", [""]] call BIS_fnc_param;
_endIf = [_this,1, false, [false]] call BIS_fnc_param;	 

if (_stem == "") exitWith { [] };

_arr = [];

for "_i" from 0 to 100 step 1 do {	

	// Determine if object exists
	_o = call compile format['if (!isNil {%1_%2}) exitWith { %1_%2 }; nil', _stem, _i];

	if (isNil "_o" && _endIf) exitWith {}; // End early if the chain is incomplete
	if (isNil "_o" && !_endIf) then {} else {			
		_arr = _arr + [_o];	
	};

};

_arr 