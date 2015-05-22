//
//      Name: createNotification
//      Desc: Creates a notification box in the center of the screen
//      Return: None
//

private ['_text', '_duration', '_icon', '_colour', '_type'];

if (isNil "GW_NOTIFICATION_ACTIVE") then {
	GW_NOTIFICATION_ACTIVE = true;
};

if (GW_NOTIFICATION_ACTIVE) then {
	GW_NOTIFICATION_ACTIVE = false;

	Sleep 0.2;

	GW_NOTIFICATION_ACTIVE = true;
};

_text = [_this,0, "", [""]] call filterParam;
_duration = [_this,1, 1, [0]] call filterParam;
_icon = [_this,2, blankIcon, [""]] call filterParam;
_condition = [_this,3, { true } , [{}]] call filterParam;

disableSerialization;
150000 cutRsc ["GW_Notification", "PLAIN"];
_layerNotification = ("GW_Notification" call BIS_fnc_rscLayer);
_ui = uiNamespace getVariable "GW_Notification"; 

// Create the alert group
_notificationGroupA = [	
	_ui displayCtrl 150002,
	_ui displayCtrl 150001
];


{

	(_x select 0) ctrlSetTextColor [1,1,1,1];
	(_x select 0) ctrlSetFade 1;
	(_x select 0) ctrlCommit 0;

	(_x select 1) ctrlSetBackgroundColor [0,0,0,0];
	(_x select 1) ctrlSetFade 1;
	(_x select 1) ctrlCommit 0;

} count [
	_notificationGroupA
] > 0;


(_notificationGroupA select 1) ctrlSetStructuredText parseText ( format["<img size='2.7' align='center' valign='middle' shadow='0' image='%1' />", _icon] );
(_notificationGroupA select 1) ctrlCommit 0; 

(_notificationGroupA select 0) ctrlSetStructuredText parseText ( format["<t size='0.7' valign='middle' color='#ffffff' align='center'>%1</t> <t size='0.7' color='#ffc730' valign='middle'  align='center'> %2</t>", _text, 'INITIALIZING'] );
(_notificationGroupA select 0) ctrlCommit 0; 

[(_notificationGroupA select 1), [['fade', 1, 0, 0.3],['y', '-0.06', '0', 0.3]], "quad"] spawn createTween;
[(_notificationGroupA select 0), [['fade', 1, 0, 0.05],['y', '-0.1', '0', 0.05]], "quad"] spawn createTween;

_timeout = time + _duration;

waitUntil{
	Sleep 1;
	(([] call _condition) || (time > _timeout))
};

for "_i" from 0 to 1 step 0 do {

	if ( !([] call _condition) || time > _timeout || (!alive player)) exitWith {};
	_origin = time + _duration;
	_timeLeft = round(-1 * (time - _timeout));
	_timeLeft = if (_timeLeft < 0) then { 0 } else { _timeLeft };
	_colour = if (_timeLeft < 10) then { '#ff0000' } else { '#ffc730' };		
	(_notificationGroupA select 0) ctrlSetStructuredText parseText ( format["<t size='0.7' valign='middle' color='#ffffff' align='center'>%1</t> <t size='0.7' color='%3' valign='middle' align='center'> [ %2s ]</t>", _text, _timeLeft, _colour] );
	(_notificationGroupA select 0) ctrlCommit 0; 

	Sleep 0.5;
};

[(_notificationGroupA select 1), [['fade', 0, 1, 0.05], ['y', '0', '-0.06', 0.05]], "quad"] spawn createTween;
[(_notificationGroupA select 0), [['fade', 0, 1, 0.1], ['y', '0', '-0.08', 0.1]], "quad"] spawn createTween;

