_isHidden = _this getVariable ['GW_HIDDEN', false];

if (_isHidden) then {
	_this setVariable ['GW_HIDDEN', false, true];

	// Enable visibility	
	pubVar_setHidden = [_this, false];
	publicVariable "pubVar_setHidden";
	[_this, false] call pubVar_fnc_setHidden;
	
} else {
	_this setVariable ['GW_HIDDEN', true, true];

	// Disable visibility	
	pubVar_setHidden = [_this, true];
	publicVariable "pubVar_setHidden";
	[_this, false] call pubVar_fnc_setHidden;

};