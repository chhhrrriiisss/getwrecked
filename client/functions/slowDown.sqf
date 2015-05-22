//
//      Name: slowDown
//      Desc: Reduces vehicle speed by the specified factor, used by EMP 
//      Return: None
//

private ['_vehicle', '_speed'];

_vehicle =  [_this, 0, objNull, [objNull]] call filterParam;
_speed = [_this, 1, 0.97, [0]] call filterParam;

if (isNull _vehicle) exitWith {};
if (!alive _vehicle) exitWith {};

_alt = (ASLtoATL (getPosASL _vehicle)) select 2;
_vel = velocity _vehicle;

_min = 3;

// Check we're actually touching the ground
if (_alt < 0.5) then {

	_velX = abs (_vel select 0);
	_velY = abs (_vel select 1);
	_velTotal = _velX + _velY;

	// If it's basically zero, make it zero
	if (_velTotal <	 _min && _speed != 1) exitWith {
		_vehicle setVelocity [0,0,0];
	};
		
	_vehicle setVelocity [(_vel select 0) * _speed,(_vel select 1) * _speed, (_vel select 2)];

};
