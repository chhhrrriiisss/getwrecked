_time = diag_tickTime + 1;      
_i = 0;     


waitUntil {  
	Sleep 0.00051;
	_i = _i + 1;          
	diag_tickTime >= _time      
};      

_time = diag_tickTime + 1;
_y = 0;

for "_i" from 0 to 1 step 0 do {	
	_y = _y + 1;
	if (diag_tickTime >= time) exitWith {};
};

hint format ["FPS: %1 / WaitUntil: %2 / For: %3", diag_fps, _i, _y]; 