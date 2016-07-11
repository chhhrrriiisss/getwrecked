disableSerialization;
_display = findDisplay 46 createDisplay "RscCredits";
_ctrl = _display ctrlCreate ["RscHTML", -1];

_ctrl ctrlSetBackgroundColor [0,0,0,0];
_ctrl ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW, safeZoneH];
_ctrl ctrlSetText '';
_ctrl ctrlCommit 0;

_ctrl htmlLoad "http://getwrecked-chrisnic.rhcloud.com/hints/test/test";
_ctrl ctrlCommit 0;

_timeout = time + 3;
	waitUntil {
	((ctrlHTMLLoaded _ctrl) || time > _timeout)
};

ctrlDelete _ctrl;
_display closeDisplay 1;

