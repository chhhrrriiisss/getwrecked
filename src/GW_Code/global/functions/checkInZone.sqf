//
//      Name: checkInZone
//      Desc: Checks if a position is inside selected zone
//      Return: Bool
//

private ['_distance', '_cl', '_playerDir', '_angleDif', '_dif'];


// If zone is specified, instead of raw data, find it
_data = if ((_this select 1) isEqualType "") then {
	
	// Find the respective data for the zone
	_d = [];	
	{
		if ((_x select 0) == (_this select 1)) exitWith {
			_d = (_x select 1);
		};
		false
	} count GW_ZONES > 0;

	_d

} else {
	(_this select 1)
};

if ((count _data) isEqualTo 0) exitWith { false };

_distance = 99999;
_cl = [0,0,0];
{
	_d = (_x select 0) distance ( _this select 0 );
	_distance = if (_d < _distance) then { _cl = _x; _d } else { _distance };
	false
} count _data > 0;

_playerDir = [(_cl select 0), ( _this select 0 )] call dirTo;
_angleDif = [(_cl select 1) - _playerDir] call normalizeAngle;
_dif = _cl select 2;

if ((_angleDif > _dif || _angleDif < 0) && _dif <= 180) exitWith {
	false
};

if ((_angleDif > _dif) && _dif >= 180) exitWith {
	false
};

true
