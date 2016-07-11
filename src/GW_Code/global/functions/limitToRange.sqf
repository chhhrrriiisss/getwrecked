//
//      Name: limitToRange
//      Desc: Ensures a number is between the given values, optionally loops the values if they escape the range
//      Return: Number (Corrected to be inside range)
//

private ['_v', '_nV', '_r1', '_r2', '_c'];

_v = [_this, 0, 0, [0]] call filterParam;
_r1 = [_this, 1, 0, [0]] call filterParam;
_r2 = [_this, 2, 0, [0]] call filterParam;
_c = [_this, 3, false, [false]] call filterParam;

_rng = abs (_r2 - _r1);

if (_v < _r1) exitWith { 
	_nV = if (_c) then {
		(_r2 + (_v % _rng))
	} else {_r1};
	_nV
};

if (_v > _r2) exitWith { 
	_nV = if (_c) then {
		(_r1 + (_v % _rng))
	} else {_r2};

	_nV
};

_v