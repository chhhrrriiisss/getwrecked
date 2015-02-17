//
//      Name: limitToRange
//      Desc: Ensures a number is between the given values, optionally loops the values if they escape the range
//      Return: Number (Corrected to be inside range)
//

private ['_v', '_nV', '_r1', '_r2', '_c'];

_v = _this select 0;
_r1 = _this select 1;
_r2 = _this select 2;
_c = if (isNil { _this select 3 }) then { false } else { (_this select 3) };

if (_v < _r1) exitWith { 
	_nV = if (_c) then {_r2} else {_r1};
	_nV
};

if (_v > _r2) exitWith { 
	_nV = if (_c) then {_r1} else {_r2};
	_nV
};

_v