//
//      Name: setVariance
//      Desc: Moves a position slightly by the specified ranges
//		Return: Array (New position)
//

_pos = _this select 0;
_rangeX = [_this,1, 0, [0]] call BIS_fnc_param;
_rangeY  = [_this,2, 0, [0]] call BIS_fnc_param;
_rangeZ  = [_this,3, 0, [0]] call BIS_fnc_param;

_vel = [0,0,0] distance (velocity (vehicle player));

// Velocity influences variance
if (_vel > 10) then {
	_rangeX = _rangeX * (_vel / 10);
	_rangeY = _rangeY * (_vel / 10);
	_rangeZ = _rangeZ * (_vel / 10);
};

// Variation in aim
_rndX = ( (random _rangeX) - (_rangeX/2) );
_rndY = ( (random _rangeY) - (_rangeY/2) );
_rndZ = ( (random _rangeZ) - (_rangeZ/2) );

_pos set[0, (_pos select 0) + _rndX];
_pos set[1, (_pos select 1) + _rndY];
_pos set[2, (_pos select 2) + _rndZ];

_pos

