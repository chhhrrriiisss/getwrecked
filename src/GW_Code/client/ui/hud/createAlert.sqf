//
//      Name: createAlert
//      Desc: Creates a notification box in the center of the screen
//      Return: None
//

if (GW_WAITALERT || GW_SETTINGS_ACTIVE || GW_HUD_LOCK) exitWith {};
GW_WAITALERT = true;

private ['_text', '_duration', '_icon', '_colour', '_type'];

_text = [_this,0, "", [""]] call filterParam;
_duration = [_this,1, 1, [0]] call filterParam;
_icon = [_this,2, blankIcon, [""]] call filterParam;
_colour = [_this,3, [], [[]]] call filterParam;
_type =  [_this,4, "default", [""]] call filterParam;
_sound =  [_this,5, "beep_light", [""]] call filterParam;

_bgColour = [0,0,0,0.3];
_fontColour = [1,1,1,1];

if (count _colour > 0) then {	
	_bgColour = [_colour select 0, _colour select 1, _colour select 2, ((_colour select 3) * 0.15) max 0.15];
	_fontColour = _colour;
};

_iconSize = if (_icon == blankIcon) then { 0 } else { 1.4 };
_text =	format["<img size='%1' align='center' valign='middle' shadow='0' image='%2' />  <t size='0.8' align='center'>%3</t>  ", _iconSize, _icon, _text];

// Get controls and display
disableSerialization;
940000 cutRsc ["GW_Alert", "PLAIN"];
_layerAlert = ("GW_Alert" call BIS_fnc_rscLayer);
_ui = uiNamespace getVariable "GW_Alert"; 
_title = _ui displayCtrl 940002;
_bg = _ui displayCtrl 940001;

// Create the alert group
_alertGroup = [
	_title,
	_bg
];

// Initially, fade everything out
_bg ctrlSetPosition [0.405 * safeZoneW + safeZoneX, 0.2 * safeZoneH + safeZoneY];
_bg ctrlSetBackgroundColor _bgColour;
_bg ctrlSetFade 1;
_bg ctrlCommit 0;

_title ctrlSetPosition [0.405 * safeZoneW + safeZoneX, 0.217 * safeZoneH + safeZoneY];
_title ctrlSetTextColor _fontColour;
_title ctrlSetFade 1;
_title ctrlCommit 0;

_inDuration = (_duration / 7.5) max 0.15;
_outDuration = (_duration / 15) max 0.15;

if (_sound == "") then {} else { player say3D _sound; };

_alertGroup spawn {	
	for "_i" from 0 to 1 step 0 do {
		if (!GW_WAITALERT) exitWith {};
		[_this, [['fade', 1, 0, 0]], "quad"] spawn createTween;
		Sleep 0.25;
	};
};

switch (_type) do {

	case "slideDown":
	{
		_inDuration = _inDuration * 2;
		[_alertGroup, [['fade', 1, 0, _inDuration],['y', '-0.05', '0', _inDuration]], "quad"] spawn createTween;
	};
    
	case "flash":
	{
		_inDuration = 0;
		_outDuration = 0.05;		
		_duration = 0.5;
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
Sleep _duration;

// Determine which close animation to use
switch (_type) do {

	case "slideDown":
	{
		[_alertGroup, [['fade', 0, 1, _outDuration], ['y', '0', '0.05', _outDuration]], "quad"] spawn createTween;
	};
	
	default
	{
		[_alertGroup, [['fade', 0, 1, _outDuration]], "quad"] spawn createTween;
	};
};

Sleep _outDuration;

140000 cutText ["", "PLAIN", 0.01];

GW_WAITALERT = false;