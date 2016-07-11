//
//      Name: formatTimeStamp
//      Desc: Create a formatted string from a time
//      Return: None
//

private ['_currentTime', '_seconds', '_milLeft', '_hoursLeft', '_minsLeft', '_secsLeft', '_timeStamp'];

_currentTime = _this;
_seconds = floor (_currentTime);	
_milLeft = floor ( abs ( floor( _currentTime ) - _currentTime) * 10);
_hoursLeft = floor(_seconds / 3600);
_minsLeft = floor((_seconds - (_hoursLeft*3600)) / 60);
_secsLeft = floor(_seconds % 60);
_timeStamp = format['%1:%2:%3:%4', ([_hoursLeft, 2] call padZeros), ([_minsLeft, 2] call padZeros), ([_secsLeft, 2] call padZeros), ([_milLeft, 2] call padZeros)];
_timeStamp