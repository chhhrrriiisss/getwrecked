//
//      Name: setVariance
//      Desc: Moves a position slightly by the specified ranges
//		Return: Array (New position)
//

params ['_pos'];

_rangeX = [_this, 1, 0, [0]] call filterParam;
_rangeY  = [_this, 2, 0, [0]] call filterParam;
_rangeZ  = [_this, 3, 0, [0]] call filterParam;

_vel = [0,0,0] distance (velocity GW_CURRENTVEHICLE);

// Velocity influences variance
if (_vel > 10) then {
	_rangeX = _rangeX * (_vel / 10);
	_rangeY = _rangeY * (_vel / 10);
	_rangeZ = _rangeZ * (_vel / 10);
};

[
	(_pos select 0) + ( (random _rangeX) - (_rangeX/2) ),
	(_pos select 1) + ( (random _rangeY) - (_rangeY/2) ),
	(_pos select 2) + ( (random _rangeZ) - (_rangeZ/2) )
]
