/*

	Checks if point is inside zone from point data
	
*/

private ['_distance', '_cl', '_playerDir', '_angleDif', '_dif'];

_distance = 99999;
_cl = [0,0,0];
{
	_d = (_x select 0) distance ( _this select 0 );
	_distance = if (_d < _distance) then { _cl = _x; _d } else { _distance };
	false
} count (_this select 1) > 0;

_playerDir = [(_cl select 0), ( _this select 0 )] call BIS_fnc_dirTo;
_angleDif = [(_cl select 1) - _playerDir] call normalizeAngle;
_dif = _cl select 2;

if ((_angleDif > _dif || _angleDif < 0) && _dif <= 180) exitWith {
	false
};

if ((_angleDif > _dif) && _dif >= 180) exitWith {
	false
};

true
