GW_SIM_ENABLE = true;

_this setVariable ['GW_IGNORE_SIM', true];

for "_i" from 0 to 1 step 0 do {
	
	if (!GW_SIM_ENABLE) exitWith {};

	_this enableSimulation false;

};

_this setVariable ['GW_IGNORE_SIM', nil];