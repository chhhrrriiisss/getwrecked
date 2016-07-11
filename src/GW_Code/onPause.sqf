disableSerialization;

waitUntil {!isNull findDisplay 49}; // 49 = Esc menu

// Disable field manual
((findDisplay 49) displayCtrl 122) ctrlEnable false;

_respawnButton = (findDisplay 49) displayCtrl 1010;
_saveButton = ((findDisplay 49) displayCtrl 103) ctrlEnable false;
_continueButton = ((findDisplay 49) displayCtrl 2) ctrlEnable false;

// MENU #523
// NAME #109
// CONTINUE #2
// SAVE #103
// SKIP #1002
// RESPAWN #1010
// CONFIGURE #101
// SAVE AND EXIT #104

// _string = "";
// {
// 	_ctrl = _x;
// 	_text =ctrlText _ctrl;
// 	if (count toArray _text > 0) then {
// 		_string = format['%1 %2 / %3 \n\n', _string, ctrlText _ctrl, _x];
// 	};
// } foreach allControls findDisplay 49;

// HINT format['%1', _string];

[] spawn
{
	disableSerialization;
	waitUntil {	
		_respawnButton = (findDisplay 49) displayCtrl 1010;
		if (player distance (getMarkerPos "workshopZone_camera") > 300) then {
			_respawnButton ctrlsetText "RESPAWN AT WORKSHOP";
		};

		(!isNull findDisplay 49)
	};
};
