_isHidden = _this getVariable ['GW_HIDDEN', false];

if (_isHidden) then {
	_this setVariable ['GW_HIDDEN', false, true];
	player customChat [GW_WARNING_CHANNEL, 'Vehicle is now visible to all players.'];   

	// Enable visibility	
	pubVar_setHidden = [_this, false];
	publicVariable "pubVar_setHidden";
	[_this, false] call pubVar_fnc_setHidden;
	
} else {
	_this setVariable ['GW_HIDDEN', true, true];
	player customChat [GW_SUCCESS_CHANNEL, 'Vehicle changes are now hidden from other players.'];   

	// Disable visibility	
	pubVar_setHidden = [_this, true];
	publicVariable "pubVar_setHidden";
	[_this, false] call pubVar_fnc_setHidden;

};