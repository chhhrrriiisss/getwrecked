//
//      Name: getData
//      Desc: Finds and returns an array of object data from the specified array
//      Return: Array (All found values)
//

private ["_find", "_arr","_foundArr", "_data"];
params ['_find', '_arr'];

if ((count toArray _find == 0) || count _arr == 0) exitWith { nil };

_data = [];
{		
	_entry = _x;
	if ({  
		if (typename _x isEqualTo typename _find) then { 
			if (_find == _x) exitWith { _data = _entry; };
		};
		false
	} count _entry isEqualTo 1) exitWith {};

	false
} count _arr;

// Exit with data
if (count _data > 0) exitWith {
	_data
};

nil