//
//      Name: checkTimeout
//      Desc: Checks if the module or weapon is currently on timeout (being reloaded)
//      Return: Array [Time Left, State]
//

private ["_type", "_currentTime", "_state", '_timeLeft', "_count"];

params ['_type', '_currentTime'];

_state = [0, false, 0];

if (_currentTime == 0 || (count GW_WAITLIST == 0)) exitWith { _state };

_numberOfType = 0;
_timeLeft = 0;
_count = 0;
{	
	_timeLeft = 0;
	_error = false;
	if (!isNil "_x") then {			
		_source = _x select 0;
		_timeNeeded = _x select 1;

		if (isNil "_timeNeeded" || isNil "_source") exitWith {};

		_timeLeft = _timeNeeded - _currentTime;			
		_applyTimeout = false;

		_applyTimeout = if (_timeLeft > 0) then {

			if (_timeLeft > 0 && { typename _source == "ARRAY" } && { (_source select 0) == _type || (_source select 1) == _type }) exitWith { true };
			if (_timeLeft > 0 && { typename _source == "STRING" } && { _source == _type }) exitWith { true };
			false

		} else {
			false
		};

		if (_applyTimeout) then {
			_state set[0, (_state select 0) + ceil(_timeLeft)];
			_state set[1, true];
			_numberOfType = _numberOfType + 1;
		};	
		
	} elsE {
		_error = true;
	};	

	// If it should have expired
	if (_timeLeft <= 0 || _error) then {
		GW_WAITLIST deleteAt _count;				
	};		

	_count = _count + 1;

} count GW_WAITLIST > 0;

_state set[2, _numberOfType];


_state