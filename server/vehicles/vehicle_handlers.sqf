/*

    Adds Event Handlers To A Vehicle

*/

if (!isServer) exitWith {};

_vehicle = _this select 0;

if (isNil {_vehicle getVariable "GW_MPHitEH"}) then {	
	_vehicle setVariable ["GW_MPHitEH", _vehicle addMPEventHandler ["MPHit", handleHitVehicle]];
};

if (isNil {_vehicle getVariable "GW_MPKilledEH"}) then {	
	_vehicle setVariable ["GW_MPKilledEH", _vehicle addMPEventHandler ["MPKilled", handleKilledVehicle]];
};

if (isNil {_vehicle getVariable "GW_ExplosionEH"}) then {	
	_vehicle setVariable ["GW_ExplosionEH", _vehicle addEventHandler ["Explosion", handleExplosionVehicle]];
};

if (isNil {_vehicle getVariable "GW_HandleDamageEH"}) then {	
	_vehicle setVariable ["GW_HandleDamageEH", _vehicle addEventHandler ["HandleDamage", handleDamageVehicle]];
};

if (isNil {_vehicle getVariable "GW_EpeContactEH"}) then {	
	_vehicle setVariable ["GW_EpeContactEH", _vehicle addEventHandler ["EpeContact", handleContactVehicle]];
};
