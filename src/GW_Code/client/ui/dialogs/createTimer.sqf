//
//      Name: createTimer
//      Desc: Used for customizing keybinds, checking stats and renaming/unflipping the vehicle
//      Return: None
//

if (GW_TIMER_ACTIVE) then {
	GW_TIMER_ACTIVE = false;
	closeDialog 94000;
};

// Close the hud if its open
GW_HUD_ACTIVE = false;
GW_HUD_LOCK = true;
GW_TIMER_ACTIVE = true;

private ['_buttonString', '_timeValue', '_canAbort'];

_buttonString = [_this,0, "CANCEL", [""]] call filterParam;
_timeValue =  [_this,1, 3, [0]] call filterParam;

GW_TIMER_VALUE = time + _timeValue;

_abortParameters = if (isNil { (_this select 2) }) then { [true, true] } else { (_this select 2) };
_abortParameters = if ((_this select 2) isEqualType []) then { (_this select 2) } else { [true, true] };

_canAbort = [_abortParameters,0, true, [false]] call filterParam;
_showButton = [_abortParameters,1, true, [false]] call filterParam;

_soundEnabled = [_this,3, false, [false]] call filterParam;
_functionOnComplete = [_this,4, { true }, [{}]] call filterParam;
_showBorders = [_this,5, true, [false]] call filterParam;

// Global function to cancel the current timer
cancelCurrentTimer = {	
	GW_TIMER_ACTIVE = false;
};

// Disable HUD
GW_HUD_LOCK = true;
waitUntil {isNil "GW_HUD_INITIALIZED" };

disableSerialization;
if(!(createDialog "GW_Timer")) exitWith { GW_TIMER_ACTIVE = false; GW_HUD_LOCK = false; }; 

_text = ((findDisplay 94000) displayCtrl 94001);
_btn = ((findDisplay 94000) displayCtrl 94002);
_marginBottom = ((findDisplay 94000) displayCtrl 94003);
_marginTop = ((findDisplay 94000) displayCtrl 94004);
_margins = [_marginTop, _marginBottom];

_btn ctrlSetText _buttonString;
_btn ctrlShow true;
_btn ctrlCommit 0;
//showChat false;

// Allows the timer to be cancelled via esc
if (!_canAbort) then {
	[94000, true] call toggleDisplayLock;	
};

// Button is not visible
if (!_showButton) then {
	_btn ctrlShow false;
	_btn ctrlCommit 0;	
};

// Hide/show top and bottom margins
if (!_showBorders) then {

	{
		_x ctrlSetFade 1;
		_x ctrlCommit 0;
	} foreach _margins;

} else {

	{
		_x ctrlSetFade 0;
		_x ctrlCommit 0;
	} foreach _margins;

};

_exitWith = false;
_sleepTime = 0.1;
_lastSecond = 0;

for "_i" from 0 to 1 step 0 do {

	if (isNull (findDisplay 94000) || (time > GW_TIMER_VALUE) || !GW_TIMER_ACTIVE) exitWith {};

	_left = (GW_TIMER_VALUE - time);
	_seconds = floor (_left);	
	_milLeft = floor ( abs ( floor( _left ) - _left) * 10);
	_hoursLeft = floor(_seconds / 3600);
	_minsLeft = floor((_seconds - (_hoursLeft*3600)) / 60);
	_secsLeft = floor(_seconds % 60);
	_timeLeft = format['-%1:%2:%3:%4', ([_hoursLeft, 2] call padZeros), ([_minsLeft, 2] call padZeros), ([_secsLeft, 2] call padZeros), ([_milLeft, 2] call padZeros)];

	disableSerialization;
	_text = ((findDisplay 94000) displayCtrl 94001);
	_text ctrlSetText _timeLeft;
	_text ctrlCommit 0;

	if (_soundEnabled) then {
		if (_seconds != _lastSecond) then {
			_lastSecond = _seconds;

			GW_CURRENTVEHICLE say "beepTarget";
		};
	};

	Sleep _sleepTime;

};

GW_HUD_LOCK = false;

// Timer over, tidy up
showChat true;
_exitWith = if (GW_TIMER_ACTIVE && time > GW_TIMER_VALUE) then { 
	[] call _functionOnComplete;
	true 
} else { false };

GW_TIMER_ACTIVE = false;
GW_HUD_ACTIVE = false;
GW_HUD_LOCK = false;
//disableUserInput false;
closeDialog 0;

[94000, false] call toggleDisplayLock;

_exitWith


