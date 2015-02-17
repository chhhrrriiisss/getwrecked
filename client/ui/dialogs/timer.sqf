//
//      Name: settingsMenu
//      Desc: Used for customizing keybinds, checking stats and renaming/unflipping the vehicle
//      Return: None
//

if (GW_TIMER_ACTIVE) then {
	GW_TIMER_ACTIVE = false;
	closeDialog 94000;
};

// Close the hud if its open
GW_HUD_ACTIVE = false;
GW_TIMER_ACTIVE = true;

private ['_buttonString', '_timeValue', '_showButton'];

_buttonString = [_this,0, "CANCEL", [""]] call BIS_fnc_param;
_timeValue =  [_this,1, 3, [0]] call BIS_fnc_param;

GW_TIMER_VALUE = time + _timeValue;
_showButton = [_this,2, true, [false]] call BIS_fnc_param;

// Global function to cancel the current timer
cancelCurrentTimer = {	
	GW_TIMER_ACTIVE = false;
};

disableSerialization;
if(!(createDialog "GW_Timer")) exitWith { GW_TIMER_ACTIVE = false; }; 

disableSerialization;
_text = ((findDisplay 94000) displayCtrl 94001);
_btn = ((findDisplay 94000) displayCtrl 94002);

_btn ctrlSetText _buttonString;
_btn ctrlShow true;
_btn ctrlCommit 0;

// Allows the timer to be cancelled via button
if (!_showButton) then {
	_btn ctrlShow false;
	_btn ctrlCommit 0;
};

_exitWith = false;


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

	Sleep 0.05;

};

// Timer over, tidy up
showChat true;
_exitWith = if (GW_TIMER_ACTIVE && time > GW_TIMER_VALUE) then { true } else { false };
GW_TIMER_ACTIVE = false;
closeDialog 0;

_exitWith


