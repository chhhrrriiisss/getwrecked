//
//		checkRaceStatus
//

_r = [_this, 0, "", [""]] call filterParam;
_s = [_this, 1, -2, [0]] call filterParam;

private ['_r', '_s'];

if (count toArray _r == 0) exitWith { -1 };

// Just querying current status
if (_s == -2) exitWith {

	_s = -1;
	{			
		if (_r == ((_X select 0) select 0)) exitWith { _s = [_x, 3, -1, [0]] call filterParam; false };
		false
	} count GW_ACTIVE_RACES;

	_s

};

// Setting the race to the current status
{
	if (_r == ((_X select 0) select 0)) exitWith { _x set [3, _s]; false };
	false
} count GW_ACTIVE_RACES;

// Update that value
publicVariable "GW_ACTIVE_RACES";

_s