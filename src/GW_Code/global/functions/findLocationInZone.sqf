//
//      Name: findLocationInZone
//      Desc: Find an empty location inside zone boundary, that's flat and away from houses
//      Return: None
//

private ['_c', '_z'];

_z = _this;
_r = 2000;
_c = getMarkerPos format['%1_camera', _z];

_c set [0, (_c select 0) + ((random _r) - (_r / 2))];
_c set [1, (_c select 1) + ((random _r) - (_r / 2))];

_inZone = [_c, _z] call checkInZone;
_normal = [0,0,1] distance (surfaceNormal _c);
_nearby = nearestObjects [_c, ["House"],10];

_c = if (!_inZone || _normal >= 0.2 || (count _nearby > 0)) then {
	(_z call findLocationInZone)
} else {
	_c
};

_c

