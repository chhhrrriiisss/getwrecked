//
//      Name: findAllMarkers
//      Desc: Finds position of all markers with the string stem
//      Return: Array [position]
//

private ["_stem", "_arr", "_dist", "_point", "_endIf"];

_stem = if (isNil { _this select 0 }) then { "" } else { (_this select 0) };
_endIf = if (isNil { _this select 1 }) then { false } else { (_this select 1) };

if (_stem == "") exitWith { [] };

_arr = [];

// There shouldn't be anymore than 50 markers, really
for "_s" from 0 to 50 step 1 do {	
	
	_point = getMarkerPos (format['%1_%2', _stem, _s]);
	_dist = _point distance [0,0,0];

	if (_dist <= 0 && _endIf) exitWith {}; // End early if the marker chain is incomplete
	if (_dist <= 0 && !_endIf) then {} else {
		_arr pushBack _point;
	};
};

_arr
