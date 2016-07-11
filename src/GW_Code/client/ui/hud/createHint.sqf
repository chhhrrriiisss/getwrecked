//
//      Name: createHint
//      Desc: Creates a notification hint in the center of the screen
//      Return: None
//

if (!GW_HINTS_ENABLED) exitWith {};
if (isNIl "GW_WAITHINT") then {GW_WAITHINT = false; };
if (GW_WAITHINT) then { GW_WAITHINT = false; };
GW_WAITHINT = true;

hint '';

private ['_text', '_duration', '_icon', '_colour', '_type'];

_text = [_this,0, "", [""]] call filterParam;
_duration = [_this,1, 99, [0]] call filterParam;
_icon = [_this,2, blankIcon, [""]] call filterParam;
_colour = [_this,3, [], [[]]] call filterParam;
_type =  [_this,4, "default", [""]] call filterParam;
_sound =  [_this,5, "beep_light", [""]] call filterParam;


_fontSize = 1;

_header = format["<t font='PuristaMedium' size='%1' align='center' color='#FCD93B'>%2</t>", 1.5 * _fontSize, 'WELCOME'];
_body =	format["<t font='PuristaMedium' size='%1' align='center' color='#ffffff' >%2</t>", 1 * _fontSize, "<t color='#FCD93B'>Get Wrecked</t> challenges players to build a custom armored vehicle and then fight to the death! <br /><br /> Begin by finding a <t color='#FCD93B'>Vehicle Service Terminal</t> in the workshop to load or create a new vehicle."];

_footerFontSize = 0.8;
_highlightColor = '#FCD93B';
_footer1 = format["<t size='%1' color='#ffffff' align='center' valign='bottom'>Use <t color='%2'>!help</t> in chat to hide all hints.</t>", _footerFontSize, _highlightColor];
_footer2 = format["<t size='%1' color='#ffffff' align='center' valign='bottom'>Press <t color='%2'>[i]</t> show info on a nearby item.</t>", _footerFontSize, _highlightColor];
_footer3 = format["<t size='%1' color='#ffffff' background='#fefefe' align='center'>Press <t color='%2'>[~]</t> to close.</t>", _footerFontSize, _highlightColor];
_footer = format['%1 <br /> %2 <br /> %3', _footer1, _footer2, _footer3];


_body = format['<br /> %1 <br /><br /> %2 <br /><br /> %3 <br /> <br />', _header, _body, _footer];



hint parseText _body;

// // Hide unit/stance info
// {
// 	private ["_rsc","_idcs"];
// 	_rsc = _x;
// 	_idcs = [configfile >> "RscInGameUI" >> _rsc, 1, true] call BIS_fnc_displayControls; 
// 	{
// 		((findDisplay 301) displayCtrl _x) ctrlSetPosition [0, 0, 0, 0];
// 		((findDisplay 301) displayCtrl _x) ctrlSetBackgroundColor [0,0,0,0];
// 		((findDisplay 301) displayCtrl _x) ctrlCommit 0;
// 	} forEach _idcs;
// } forEach ["RscHint"];

((findDisplay 301) displayCtrl 101) ctrlSetBackgroundColor [0,0,0,0];
((findDisplay 301) displayCtrl 101) ctrlSetFade 1;
((findDisplay 301) displayCtrl 101) ctrlCommit 0;



// Get controls and display

// disableSerialization;
// 133000 cutRsc ["GW_Hint", "PLAIN"];
// _layerAlert = ("GW_Hint" call BIS_fnc_rscLayer);
// _ui = uiNamespace getVariable "GW_Hint"; 


// _content = _ui displayCtrl 133001;
// _bg = _ui displayCtrl 133002;
// _title =_ui displayCtrl 133003;
// // _icon = _ui displayCtrl 133004;

// // Create the alert group
// _alertGroup = [
// 	_bg,
// 	_content,

// 	_title	
// ];

// // Initially, fade everything out
// _bg ctrlSetPosition [0.77 * (safeZoneW + safeZoneX), -0.24 * (safeZoneH + safeZoneY)];
// _bg ctrlSetBackgroundColor _bgColour;
// _bg ctrlSetFade 1;
// _bg ctrlCommit 0;

// _content ctrlSetPosition [0.77  * (safeZoneW + safeZoneX), -0.21 * (safeZoneH + safeZoneY)];
// _content ctrlSetTextColor _fontColour;
// _content ctrlSetBackgroundColor [0,0,0,0];
// _content ctrlSetFade 1;
// _content ctrlCommit 0;

// // _icon ctrlSetPosition [0.77  * (safeZoneW + safeZoneX), -0.24 * (safeZoneH + safeZoneY)];
// // _icon ctrlSetTextColor _fontColour;
// // _icon ctrlSetFade 1;
// // _icon ctrlCommit 0;

// _title ctrlSetPosition [0.77  * (safeZoneW + safeZoneX), -0.24 * (safeZoneH + safeZoneY)];
// _title ctrlSetTextColor _fontColour;
// _title ctrlSetFade 1;
// _title ctrlCommit 0;

// _inDuration = 0.1;
// _outDuration = (_duration / 15) max 0.15;

// if (_sound == "") then {} else { player say3D _sound; };

// _alertGroup spawn {	
// 	for "_i" from 0 to 1 step 0 do {
// 		if (!GW_WAITALERT) exitWith {};
// 		[_this, [['fade', 1, 0, 0]], "quad"] spawn createTween;
// 		Sleep 0.25;
// 	};
// };

// switch (_type) do {

// 	case "slideDown":
// 	{
// 		_inDuration = _inDuration * 2;
// 		[_alertGroup, [['fade', 1, 0, _inDuration],['y', '-0.05', '0', _inDuration]], "quad"] spawn createTween;
// 	};
    
// 	case "flash":
// 	{
// 		_inDuration = 0;
// 		_outDuration = 0.05;		
// 		_duration = 0.5;
// 		[_alertGroup, [['fade', 1, 0, 0]], "quad"] call createTween;
// 	};

// 	case "warning":
// 	{		
// 		[_alertGroup, [['fade', 1, 0, _inDuration]], "quad"] spawn createTween;		
// 	};

// 	default
// 	{
// 		_inDuration = _inDuration * 2;
// 		[_alertGroup, [['fade', 1, 0, _inDuration]], "quad"] spawn createTween;
// 	};

// };

// _content ctrlSetStructuredText parseText ( _body );
// _content ctrlCommit 0;

// _icon ctrlSetStructuredText parseText ( _iconText );
// _icon ctrlCommit 0;

// _title ctrlSetStructuredText parseText ( _header );
// _title ctrlCommit 0;

// // Wait for tween to finish
// Sleep _inDuration;

// _timeout = time + _duration;
// waitUntil {	
// 	(time > _timeout) || !GW_WAITHINT
// };

// if (!GW_WAITHINT) exitWith { 133000 cutText ["", "PLAIN", 0.01]; };

// // Determine which close animation to use
// switch (_type) do {

// 	case "slideDown":
// 	{
// 		[_alertGroup, [['fade', 0, 1, _outDuration], ['y', '0', '0.05', _outDuration]], "quad"] spawn createTween;
// 	};
	
// 	default
// 	{
// 		[_alertGroup, [['fade', 0, 1, _outDuration]], "quad"] spawn createTween;
// 	};
// };

// Sleep _outDuration;

// 133000 cutText ["", "PLAIN", 0.01];

// GW_WAITHINT = false;