private ['_vehicle'];

_vehicle = _this select 0;

_vehicle setVariable ["hasActions", true];

if (isNil {_vehicle getVariable "GW_handleDamageHP"}) then {

	{
		_vehicle setVariable ["GW_hitPoint_" + getText (_x >> "name"), configName _x, true];
	} forEach ((typeOf _vehicle) call getHitPoints);

	_vehicle setVariable ["GW_handleDamageHP", true, true];
};

if (isNil {_vehicle getVariable "GW_handleKilledEH"}) then {
	_vehicle setVariable ["GW_handleKilledEH", _vehicle addEventHandler ["Killed", handleKilledVehicle]];
};

if (isNil {_vehicle getVariable "GW_handleDamageEH"}) then {
	_vehicle setVariable ["GW_handleDamageEH", _vehicle addEventHandler ["handleDamage", handleDamageVehicle]];
};

if (isNil {_vehicle getVariable "GW_handleExplosionEH"}) then {
	_vehicle setVariable ["GW_handleExplosionEH", _vehicle addEventHandler ["Explosion", handleExplosionVehicle]];
};

if (isNil {_vehicle getVariable "GW_handleEpeContactEH"}) then {
	_vehicle setVariable ["GW_handleEpeContactEH", _vehicle addEventHandler ["EpeContact", handleContactVehicle]];
};

if (isNil {_vehicle getVariable "GW_handleGetInEH"}) then {
	_vehicle setVariable ["GW_handleGetInEH", _vehicle addEventHandler ["GetIn", handleGetIn]];
};

if (isNil {_vehicle getVariable "GW_handleGetOutEH"}) then {		
	_vehicle setVariable ["GW_handleGetOutEH", _vehicle addEventHandler ["GetOut", handleGetOut]];
};

true	
