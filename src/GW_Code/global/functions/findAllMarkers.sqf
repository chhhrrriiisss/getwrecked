//
//      Name: findAllMarkers
//      Desc: Finds position of all markers with the string stem
//      Return: Array [position]
//

private ["_stem", "_arr", "_dist", "_point", "_endIf"];

_stem = [_this, 0, "", [""]] call filterParam;
_endIf = [_this, 1, false, [false]] call filterParam;
_max =  [_this, 2, (count allMapMarkers), [0]] call filterParam; 

_arr = [];

for "_s" from 0 to _max step 1 do {	
	
	_point = getMarkerPos (format['%1_%2', _stem, _s]);
	_invalid = _point isEqualTo [0,0,0];

	if (_invalid && _endIf) exitWith {}; // End early if the marker chain is incomplete
	if (!_invalid && !_endIf) then { _arr pushBack _point;	};

};

_arr
