//
//      Name: createTitle
//      Desc: Used for displaying a large full-screen message
//      Return: None
//

if (GW_TITLE_ACTIVE) exitWith { 
	systemchat 'Title already active.'; 
	false
};

GW_TITLE_ACTIVE = true;
GW_TITLE_BUTTON_VISIBLE = false;

// Close the hud if its open
GW_HUD_ACTIVE = false;
GW_HUD_LOCK = true;

private ['_buttonString', '_timeValue', '_canAbort', '_timeout'];

_textString =  [_this,0, "", ["", {}]] call filterParam;
_buttonString = [_this,1, "CANCEL", [""]] call filterParam;

_abortParameters = if ((_this select 2) isEqualType []) then { (_this select 2) } else { [true, { true }] };

_canAbort = [_abortParameters,0, true, [false]] call filterParam;
_buttonCondition = [_abortParameters,1, { true }, [{}]] call filterParam;

_condition = [_this,3, { true }, [{}]] call filterParam;
_maxTime = [_this,4, 60, [0]] call filterParam;
_showBorders = [_this,5, true, [false]] call filterParam;
functionOnComplete = [_this, 6, {	systemchat 'Button function original!'; true }, [{}]] call filterParam;

_exitWith = false;

// _soundEnabled = [_this,3, false, [false]] call filterParam;
disableSerialization;

closeDialog 95000;
if(!(createDialog "GW_TitleScreen")) exitWith { systemchat 'Error - couldnt create title.'; GW_TITLE_ACTIVE = false; false }; 
showChat true;

_timeout = time + _maxTime;

disableSerialization;
_text = ((findDisplay 95000) displayCtrl 95001);
_btn = ((findDisplay 95000) displayCtrl 95002);
_marginBottom = ((findDisplay 95000) displayCtrl 95003);
_marginTop = ((findDisplay 95000) displayCtrl 95004);
_margins = [_marginTop, _marginBottom];

_btn ctrlShow true;
_btn ctrlSetText _buttonString;
_btn ctrlCommit 0;	

if (_text call _buttonCondition) then {
	_btn ctrlEnable true;
	_btn ctrlShow true;
	_btn CtrlCommit 0;	
} else {
	_btn ctrlEnable false;
	_btn ctrlShow false;
	_btn CtrlCommit 0;	
};

// Show button if we can cancel this title
if (!_canAbort) then {
	[95000, true] call toggleDisplayLock;	
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

for "_i" from 0 to 1 step 0 do {	

	if (isNull (findDisplay 95000)) exitWith {};

	_textValue = if (_textString isEqualType "") then { _textString } else { ([time, _timeout] call _textString) };
	_text ctrlSetStructuredText parseText ( _textValue );
	_text ctrlCommit 0;

	if (_text call _buttonCondition) then {		
		_btn ctrlEnable true;
		_btn ctrlShow true;
		_btn CtrlCommit 0;
	};

	if ((time > _timeout) || !(_text call _condition) || !GW_TITLE_ACTIVE) exitWith {};

	Sleep 0.1;
};

// Timer over, tidy up
showChat true;

_exitWith = if (GW_TITLE_ACTIVE && time > _timeout || !(_text call _condition) ) then { 
	true 
} else { false };

GW_TITLE_ACTIVE = false;
GW_HUD_ACTIVE = false;
GW_HUD_LOCK = false;
closeDialog 95000;

[95000, false] call toggleDisplayLock;	

_exitWith




// disableSerialization;
// _text = ((findDisplay 95000) displayCtrl 95001);
// _btn = ((findDisplay 94000) displayCtrl 94002);

// _btn ctrlSetText _buttonString;
// _btn ctrlShow true;
// _btn ctrlCommit 0;

// // Allows the timer to be cancelled via button
// if (!_showButton) then {
// 	_btn ctrlShow false;
// 	_btn ctrlCommit 0;
// };

// _exitWith = false;
// _sleepTime = 0.1;
// _lastSecond = 0;

// for "_i" from 0 to 1 step 0 do {

// 	if (isNull (findDisplay 94000) || (time > GW_TIMER_VALUE) || !GW_TITLE_ACTIVE) exitWith {};

// 	_left = (GW_TIMER_VALUE - time);
// 	_seconds = floor (_left);	
// 	_milLeft = floor ( abs ( floor( _left ) - _left) * 10);
// 	_hoursLeft = floor(_seconds / 3600);
// 	_minsLeft = floor((_seconds - (_hoursLeft*3600)) / 60);
// 	_secsLeft = floor(_seconds % 60);
// 	_timeLeft = format['-%1:%2:%3:%4', ([_hoursLeft, 2] call padZeros), ([_minsLeft, 2] call padZeros), ([_secsLeft, 2] call padZeros), ([_milLeft, 2] call padZeros)];

// 	disableSerialization;
// 	_text = ((findDisplay 94000) displayCtrl 94001);
// 	_text ctrlSetText _timeLeft;
// 	_text ctrlCommit 0;

// 	if (_soundEnabled) then {
// 		if (_seconds != _lastSecond) then {
// 			_lastSecond = _seconds;
// 			GW_CURRENTVEHICLE say "beepTarget";
// 		};
// 	};

// 	Sleep _sleepTime;

// };

// // Timer over, tidy up
// showChat true;
// _exitWith = if (GW_TITLE_ACTIVE && time > GW_TIMER_VALUE) then { true } else { false };
// GW_TITLE_ACTIVE = false;
// closeDialog 0;

// _exitWith


