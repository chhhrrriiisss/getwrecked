//
//      Name: getData
//      Desc: Finds and returns an array of object data from the specified array
//      Return: Array (All found values)
//

private ["_find", "_arr","_foundArr", "_data"];

_find = _this select 0;
_arr = _this select 1;

if (_find == "" || count _arr == 0) exitWith { nil };

_data = [];
{		
	_found = false;

	// CHeck all indexes for a match (same typename)
	for "_f" from 0 to (count _x) step 1 do {
		if (typename (_x select _f) == (typename _find)) then {
			if (_find == (_x select _f)) exitWith { _found = true; };		
		};
	};

	if (_found) exitWith {

		_count = count _x;

		// Spit out all the data
		for "_i" from 0 to _count step 1 do {

			if (!isNil { (_x select _i) }) then {			 
				_data pushBack (_x select _i);
			};

		};		

		false
	};

	false
} count _arr;

// Exit with data
if (count _data > 0) exitWith {
	_data
};

nil