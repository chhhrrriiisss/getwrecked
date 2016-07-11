//
//      Name: createNotification
//      Desc: Creates a notification box in the center of the screen
//      Return: None
//

// _alertFrame = 0.5;

// if (isNil "GW_ALERT_TIMEOUT") then { GW_ALERT_TIMEOUT = time - _alertFrame; };

// // Delay each icon into a 0.5 second frame
// if ((time - GW_ALERT_TIMEOUT) < _alertFrame) exitWith {
// 	Sleep (_alertFrame - (time - GW_ALERT_TIMEOUT));
// 	_this execVM 'client\ui\hud\alert_new.sqf';
// };

// GW_ALERT_TIMEOUT = time;

private ['_text', '_duration', '_icon', '_colour', '_type'];

_text = [_this,0, "", [""]] call filterParam;
_duration = [_this,1, 1, [0]] call filterParam;
_icon = [_this,2, blankIcon, [""]] call filterParam;
_colour = [_this,3, [], [[]]] call filterParam;
_type =  [_this,4, "default", [""]] call filterParam;
_sound =  [_this,5, "beep_light", [""]] call filterParam;
_condition = [_this,6, { true }, [{}]] call filterParam;

_bgColour = [0,0,0,1];
_fontColour = [1,1,1,1];

if (count _colour > 0) then {	
	_bgOpacity = 0.5;
	_bgColour = [_colour select 0, _colour select 1, _colour select 2, _bgOpacity];
	_fontColour = _colour;
};

_iconSize = if (_icon == blankIcon) then { 0 } else { 1.9 };
_text =	format["<img size='%1' sizeEx= '0.1' align='center' shadow='0' image='%2' /><br />", _iconSize, _icon, _text];
_id = (random 1000000);

// Get controls and display
disableSerialization;

_firstPass = if (isNil "layerAlert") then {
	1000 cutRsc ["GW_Notification", "PLAIN"];
	layerAlert = ("GW_Notification" call BIS_fnc_rscLayer);
	true
} else { false };

_ui = uiNamespace getVariable "GW_Notification"; 

// Create alert groups
_aG1 = [
	_ui displayCtrl 1002,
	_ui displayCtrl 1001
];

_aG2 = [
	_ui displayCtrl 1004,
	_ui displayCtrl 1003
];

_aG3 = [
	_ui displayCtrl 1006,
	_ui displayCtrl 1005
];

_aG4 = [
	_ui displayCtrl 1008,
	_ui displayCtrl 1007
];

_aG5 = [
	_ui displayCtrl 1010,
	_ui displayCtrl 1009
];

_aG6 = [
	_ui displayCtrl 1012,
	_ui displayCtrl 1011
];

_aG7 = [
	_ui displayCtrl 1014,
	_ui displayCtrl 1013
];

_aG8 = [
	_ui displayCtrl 1016,
	_ui displayCtrl 1015
];

// If first time alert triggered, fade all elements
if (_firstPass) then {
	{
		(_x select 0) ctrlSetFade 1;
		(_x select 1) ctrlSetFade 1;
		(_x select 0) ctrlCommit 0;
		(_x select 1) ctrlCommit 0;
	} foreach [
		_aG1,
		_aG2,
		_aG3,
		_aG4,
		_aG5,
		_aG6,
		_aG7,
		_aG8
	];
};

_alertGroups = [
	_aG1,
	_aG2,
	_aG3,
	_aG4,
	_aG5,
	_aG6,
	_aG7,
	_aG8
];

_totalGroups = 8;
if (isNil "GW_ALERT_ARRAY") then { GW_ALERT_ARRAY = []; };
if ((count GW_ALERT_ARRAY-1) >= _totalGroups) exitWith {};

// If the type of alert already exists, abort
_id = _text;
if ((GW_ALERT_ARRAY find _id) > 0) exitWith { systemchat 'Icon already exists'; };

// Add the new alert to the array and determine current index
GW_ALERT_ARRAY pushBack _id;
_index = GW_ALERT_ARRAY find _id;
if (_index == -1) exitWith {};

_alertGroup = _alertGroups select _index;

// Generate xPos dynamically based on array index
_width = 0.048;
_gap = 0.007;
_startX = 0.012;
_startY = 0.9;
_xPos = _startX + (_width * _index) + (_gap * _index);

_alertPosition = [_xPos * safeZoneW + safeZoneX, _startY * safeZoneH + safeZoneY];


// Target relevant bg/title from current group
_bg = (_alertGroup select 0);
_title = (_alertGroup select 1);

// Initially, fade everything out
_bg ctrlSetPosition _alertPosition;
_bg ctrlSetBackgroundColor _bgColour;
_bg ctrlSetFade 1;
_bg ctrlCommit 0;
_title ctrlSetPosition [_xPos * safeZoneW + safeZoneX, (_startY+0.015) * safeZoneH + safeZoneY];
_title ctrlSetTextColor [1,1,1,1];
_title ctrlSetFade 1;
_title ctrlCommit 0;

_inDuration = (_duration / 7.5) max 0.15;
_outDuration = (_duration / 15) max 0.15;

if (_sound == "") then {} else { player say3D _sound; };

// _alertGroup spawn {	
// 	for "_i" from 0 to 1 step 0 do {
// 		if (!GW_WAITALERT) exitWith {};
// 		[_this, [['fade', 1, 0, 0]], "quad"] spawn createTween;
// 		Sleep 0.25;
// 	};
// };

switch (_type) do {

	case "slideUp":
	{
		_inDuration = _inDuration * 2;
		[_alertGroup, [['fade', 1, 0, _inDuration],['y', '0.03', '0', _inDuration]], "quad"] spawn createTween;
	};
    
	case "flash":
	{
		_inDuration = 0;
		_outDuration = 0;		
		//_duration = 0.5;
		[_alertGroup, [['fade', 1, 0, 0]], "quad"] call createTween;
	};

	case "warning":
	{		
		[_alertGroup, [['fade', 1, 0, _inDuration]], "quad"] spawn createTween;		
	};

	default
	{
		_inDuration = _inDuration * 2;
		[_alertGroup, [['fade', 1, 0, _inDuration]], "quad"] spawn createTween;
	};

};

_title ctrlSetStructuredText parseText ( _text );
_title ctrlCommit 0;

// Wait for tween to finish
Sleep _inDuration;

// Then wait the actual duration requested
_timeout = time + _duration;
waitUntil {

	// _index = [GW_ALERT_ARRAY find _id, 0, ((COUNT GW_ALERT_ARRAY) -1)] call limitToRange;
	// _alertPosition = [(_startX + (_width * _index) + (_gap * _index)) * safeZoneW + safeZoneX, _startY * safeZoneH + safeZoneY];

	// _currentPosition = ctrlPosition _bg;
	// if (abs ((_alertPosition select 0) - (_currentPosition select 0)) > 0) then {
	// 	_bg ctrlSetPosition [(_alertPosition select 0), (_currentPosition select 1)];
	// 	_bg ctrlCommit 0.25;

	// 	_title ctrlSetPosition [(_alertPosition select 0), (_currentPosition select 1)];
	// 	_title ctrlCommit 0.25;

	// 	waitUntil {
	// 		((ctrlCommitted _bg) && (ctrlCommitted _title))
	// 	};
	// };

	( (time > _timeout) || (!(call _condition)) )
};

// Determine which close animation to use
switch (_type) do {

	case "slideUp":
	{
		[_alertGroup, [['fade', 0, 1, _outDuration], ['y', '0', '0.03', _outDuration]], "quad"] spawn createTween;
	};
	
	default
	{
		[_alertGroup, [['fade', 0, 1, _outDuration]], "quad"] spawn createTween;
	};
};

Sleep _outDuration;

// 140000 cutText ["", "PLAIN", 0.01];

GW_ALERT_ARRAY = GW_ALERT_ARRAY - [_id];