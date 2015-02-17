//
//      Name: dirToVector
//      Desc: Converts a decimal degree to a vector heading
//      Return: Array (Vector)
//

_dir = _this select 0;
_angle = _this select 1;
_pitch = _this select 2;

_vecdx = sin(_dir) * cos(_angle);
_vecdy = cos(_dir) * cos(_angle);
_vecdz = sin(_angle);

_vecux = cos(_dir) * cos(_angle) * sin(_pitch);
_vecuy = sin(_dir) * cos(_angle) * sin(_pitch);
_vecuz = cos(_angle) * cos(_pitch);

[_vecdx, _vecdy, _vecdz]
