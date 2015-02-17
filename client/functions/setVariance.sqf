//
//      Name: setVariance
//      Desc: Moves a position slightly by the specified ranges
//		Return: Array (New position)
//

_pos = _this select 0;
_rangeX =  if (isNil {_this select 1}) then { 0 } else { (_this select 1) };
_rangeY  =  if (isNil {_this select 2}) then { 0 } else { (_this select 2) };
_rangeZ  = if (isNil {_this select 3}) then { 0 } else { (_this select 3) };

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
