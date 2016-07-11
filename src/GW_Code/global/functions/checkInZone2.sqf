// checkInZone2.sqf

_point = [0,0];

_polygon = [	
	[2,6],
	[10,10],
	[10,3],
	[6,3],
	[4,5]
];

_isInside = false;
_minX = (_polygon select 0) select 0);
_maxX = (_polygon select 0) select 0);
_minY = (_polygon select 0) select 1);
_maxY = (_polygon select 0) select 1);

_polygonLength = (count _polygon);

for "_n" from 0 to _polygonLength step 1 do {
    _q = _polygon select _n;
    _minX = (_q select 0) min _minX;
    _maxX = (_q select 0) max _maxX;
    _minY = (_q select 1) min _minY;
    _maxY = (_q select 1) max _maxY;
};

if ((_point select 0) < _minX || (_point select 0) > _maxX || (_point select 1) < _minY || (_point select 1) > _maxY) exitWith {
	false
};

_polygonLength = (count _polygon);

_i = 0;
_j = _polygonLength - 1;

for [{ _i = 1; _j = 1; },{ _i < _polygonLength },{ _j = _i+1 }] do {

    if ( ((_polygon select _i) select 1) > (_point select 1)) != ((_polygon select _j) select 1) > (_point select 1)) &&
           (_point select 0) < ((_polygon select _j) select 0) - ((_polygon select _i) select 0)) * ((_point select 1) - ((_polygon select _i) select 1)) / ((_polygon select _j) select 1) - ((_polygon select _i) select 1)) + ((_polygon select _i) select 0) ) {
        _isInside = !_isInside;
    };

};

_isInside
