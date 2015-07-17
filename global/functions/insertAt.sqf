//
//      Name: insertAt
//      Desc: Add an entry to an array at a specified index
//      Return: Variable (filtered)
//

private ['_arr', '_index', '_contents', '_temp'];

_arr = [_this, 0, [], [[]]] call filterParam;
_index = [_this, 1, 0, [0]] call filterParam;
_contents = _this select 2;

if (count _arr == 0) exitWith {};

_temp = [];

for "_i" from _index to (count _arr) -1 step 1 do {
	_temp pushBack (_arr select _i);
};

_arr resize _index;
_arr pushback _contents;
_arr append _temp;

_arr