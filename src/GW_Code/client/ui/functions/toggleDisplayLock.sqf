//
//      Name: toggleDisplayLock
//      Desc: 
//      Return: 
//

params ['_displayID', '_lock'];
private ['_displayID', '_lock'];

// If the chat window is open and we're going into lock mode, close it to avoid crashing
if (!isNull (finddisplay 24 displayctrl 101) && _lock) then {
	finddisplay 24 closeDisplay 0;	
};

if (isNil "GW_LOCKED_DISPLAYS") then { GW_LOCKED_DISPLAYS = []; };

if (_lock) exitWith {
	_ID = (findDisplay _displayID) displayAddEventHandler ["KeyDown", {	true }];
	GW_LOCKED_DISPLAYS set [_ID, _displayID];
	true
};

if (!_lock) exitWith {
	_ID = GW_LOCKED_DISPLAYS find _displayID;
	if (_ID == -1) exitWith { true };
	(findDisplay _displayID) displayRemoveEventHandler ["KeyDown", _ID];
	GW_LOCKED_DISPLAYS deleteAt _ID;
	true
};

true