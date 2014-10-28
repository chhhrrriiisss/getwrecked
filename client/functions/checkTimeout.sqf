//
//      Name: checkTimeout
//      Desc: Checks if the module or weapon is currently on timeout (being reloaded)
//      Return: Array [Time Left, State]
//

private ["_type", "_currentTime", "_state", '_timeLeft', "_count"];

_type = [_this,0, "", [""]] call BIS_fnc_param;
_currentTime = [_this,1, 0, [0]] call BIS_fnc_param;

_state = [0, false];

if (_type == "" || _currentTime == 0 || (count GW_WAITLIST == 0)) exitWith { _state };

_timeLeft = 0;
{				
		_source = _x select 0;
		_timeNeeded = _x select 1;

		// If it has a time and tag
		if (!isNil "_timeNeeded" && !isNil "_source") then {

			_timeLeft = _timeNeeded - _currentTime;			

			// There's still time left and its the source requested
			if (_timeLeft > 0 && _source == _type) exitWith {
				_state = [ ceil(_timeLeft), true];
			};
		};		

		// If it should have expired
		if (_timeLeft <= 0) then {
			GW_WAITLIST set [_foreachindex, "x"];					
		};		 			

} ForEach GW_WAITLIST;

// Remove all entries that have expired
GW_WAITLIST = GW_WAITLIST - ["x"];		

_state