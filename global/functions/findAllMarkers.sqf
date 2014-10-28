//
//      Name: findAllMarkers
//      Desc: Finds position of all markers with the string stem
//      Return: Array (position data)
//

private ["_stem", "_arr", "_dist", "_point", "_endIf"];

_stem = [_this,0, "", [""]] call BIS_fnc_param;
_endIf = [_this,1, false, [false]] call BIS_fnc_param;	 

if (_stem == "") exitWith { [] };

_arr = [];

// There shouldn't be anymore than 300 markers, really
for "_s" from 0 to 300 step 1 do {	
	
	_point = getMarkerPos (format['%1_%2', _stem, _s]);
	_dist = _point distance [0,0,0];

	if (_dist <= 0 && _endIf) exitWith {}; // End early if the marker chain is incomplete
	if (_dist <= 0 && !_endIf) then {} else {
		_arr  pushBack _point;
	};
};

_arr
