disableSerialization;

_display = findDisplay 46 createDisplay "RscCredits";
_ctrl = _display ctrlCreate ["RscTitle", -1];

_ctrl ctrlSetBackgroundColor [0,0,0,0];
_ctrl ctrlSetPosition [safeZoneX,safezoneY, safeZoneW, safeZoneH];
_ctrl ctrlSetScale 1;
_ctrl ctrlSetTextColor [1,1,1,1];
_ctrl ctrlSetFont "PuristaMedium";
_ctrl ctrlSetStructuredText parseText '<t color="ffffff" align="center">TESSSSST!!!!</t>';
_ctrl ctrlCommit 0;


_timeout = time + 3;
waitUntil {

	(time > _timeout)

};

ctrlDelete _ctrl;
_display closeDisplay 0;