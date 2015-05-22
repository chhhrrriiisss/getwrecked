//
//      Name: meleeAttached
//      Desc: Toggle collision detection loop for melee weapons
//      Return: None
//

_meleeEnabled = _this getVariable ['GW_MELEE', false];
if (_meleeEnabled) exitWith { _this setVariable ['GW_MELEE', false]; false };

// No existing melee detection, generate a new one...
_this setVariable ['GW_MELEE', true];

_this spawn {
	
	private ['_v', '_name'];

	_v = _this;	
	_name = _v getVariable ['name', 'current vehicle'];
	if (GW_DEBUG) then { systemchat format['Melee detection active on %1.',_name]; };

	// Loop through every frame and check, disable when vehicle dies or melee toggled OFF
	waitUntil {
		Sleep 0.3;
		_v call collisionCheck;
		_meleeEnabled = _v getVariable ['GW_MELEE', false];
		(!alive _v || !_meleeEnabled || (_v != GW_CURRENTVEHICLE))
	};

	if (GW_DEBUG) then {  systemchat format['Melee detection disabled on %1.', _name]; };
	_v setVariable ['GW_MELEE', false];

};

true