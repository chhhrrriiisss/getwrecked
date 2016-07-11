//
//      Name: createHint
//      Desc: Used for displaying a large full-screen message
//      Return: None
//

// Overlay already active, abort
if (!isNull (findDisplay 602)) exitWith {};
IF (!isnull (findDisplay 99000)) exitWith {};

// Close the hud if its open
GW_HUD_ACTIVE = false;
GW_HUD_LOCK = true;

private ['_buttonString', '_timeValue', '_canAbort', '_timeout'];

_item =  [_this,0, "welcome", [""]] call filterParam;

_maxTime = 10;

// _soundEnabled = [_this,3, false, [false]] call filterParam;
disableSerialization;

if(!(createDialog "GW_Hint")) exitWith { systemchat 'Error - couldnt create title.'; false }; 
showChat false;

_timeout = time + _maxTime;

disableSerialization;
_title = ((findDisplay 99000) displayCtrl 99001);
_content = ((findDisplay 99000) displayCtrl 99002);
_btnA = ((findDisplay 99000) displayCtrl 99003);
_btnB = ((findDisplay 99000) displayCtrl 99004);
_bg = ((findDisplay 99000) displayCtrl 99005);

_bg ctrlShow true;
_bg ctrlCommit 0;

_btnA ctrlShow true;
_btnA ctrlSetText 'CONTINUE';
ctrlSetFocus _btnA;
_btnA ctrlCommit 0;

_focusReset = (findDisplay 99000) displayAddEventHandler ["MouseMoving", {

	ctrlSetFocus ((findDisplay 99000) displayCtrl 99003);

}]; 


_btnB ctrlShow true;
_btnB ctrlCommit 0;

_title ctrlShow true;
_t = format['<img image="%1" size="16" align="center"/>', MISSION_ROOT + "client\images\logo_isolation.paa"];
_title ctrlSetStructuredText(parseText(_t));
_title ctrlCommit 0;

_content ctrlShow true;

_t = if (_item == "welcome") then {

	format[
		"<t size='0.85' font='puristaMedium' shadow='1' color='#FFFFFF' align='center'>%1 </t>
		<br /><br />
		<t size='0.85' font='puristaLight' shadow='1' color='#FFFFFF' align='center'>%2</t>
		<br /><br />
		<t size='0.85' font='puristaMedium' shadow='1' color='#FFFFFF' align='center'> If you have issues that aren't fixed by rejoining, try the <t color='#FCD93B'>!reset</t> command.</t>", 
		"Get Wrecked is a custom vehicle sandbox that challenges players to create armoured vehicles and then fight to the death in a battle zone or custom race.",
		"To begin, find an empty 'Vehicle Service Terminal' to load or create a vehicle from scratch. <br /> You can find items to attach around the Workshop or specific parts from vendors.",
		[ (['INFO'] call getGlobalBind) ] call codeToKey
	]

} else {
	
	"test"

};

_content ctrlSetStructuredText(parseText(_t));
_content ctrlCommit 0;


// Desaturate screen
"colorCorrections" ppEffectEnable true; 
"colorCorrections" ppEffectAdjust [1, 1, 0, [1, 1, 1, 0], [1, 1, 1, 0], [0.75, 0.25, 0, 1.0]];
"colorCorrections" ppEffectCommit 0;

ctrlSetFocus _btnA;

waitUntil{
	isNull (findDisplay 99000)
};

if (!isNil "_focusReset") then {
	(findDisplay 99000) displayRemoveEventHandler ["MouseMoving", _focusReset];
};

// Desaturate screen
"colorCorrections" ppEffectAdjust [1, 1, 0,[ 0, 0, 0, 0],[ 1, 1, 1, 1],[ 0, 0, 0, 0]]; 
"colorCorrections" ppEffectEnable true; 
"colorCorrections" ppEffectCommit 0;

// Timer over, tidy up
showChat true;

GW_HUD_ACTIVE = false;
GW_HUD_LOCK = false;






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


