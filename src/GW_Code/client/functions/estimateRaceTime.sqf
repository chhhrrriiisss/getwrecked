//
//      Name: estimateRaceTime
//      Desc: Estimate how long it might take to race. Fairly simple right now but will be improved later.	  
//      Return: (optional) Return as formatted string or number
//

params ['_array', '_returnAsString'];
private ['_array', '_returnAsString', "_distance"];

if (isNil "_returnAsString") then { _returnAsString = true; };

_estimate = 0;

_distance = [_array, false] call calculateTotalDistance;

_minSpeed = 10; // In metres/s
_maxSpeed = 35; // In metres/s

_checkpoints = count _array; // Checkpoints increase time to complete

// Total amount of variation between checkpoints
_directionVariation = 0;
_prevDir = 0;
{
	if (_forEachIndex >= (count _array -1)) exitWith {};

	_dirNext = [_x, (_array select (_forEachIndex + 1))] call dirTo;

	_prevDir = if (_forEachIndex == 0) then { _dirNext } else { _prevDir };
	_dirDif = abs ([_dirNext - _prevDir] call flattenAngle);

	_directionVariation = _directionVariation + _dirDif;
	_prevDir = _dirNext;

} foreach _array;

// How many times we have to do a 90 degree turn
_rotations = _directionVariation / 90;

_estimatedSpeed = [_maxSpeed - _rotations, _minSpeed, _maxSpeed] call limitToRange;

_startDelay = 5; // Time to get to first checkpoint
_seconds = (_distance / _estimatedSpeed) + _startDelay;

if (!_returnAsString) exitWith { _seconds };

_hoursAlive = floor(_seconds / 3600);
_minsAlive = floor((_seconds - (_hoursAlive*3600)) / 60);
_secsAlive = floor(_seconds % 60);
_totalTime = format['%1h : %2m : %3s', ([_hoursAlive, 2] call padZeros), ([_minsAlive, 2] call padZeros), ([_secsAlive, 2] call padZeros)];	

_totalTime


// if (!_returnAsString) exitWith { _estimate };

// _d = if (_d > 1000) then { format['%1km', [_d / 1000, 1] call roundTo ] } else { format['%1m', [_d, 1] call roundTo ]};

// _d