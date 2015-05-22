//
//      Name: setVehicleHandlers
//      Desc: Adds eh's to vehicle
//      Return: Bool
//

private ['_vehicle'];

_vehicle = _this select 0;

_hasHandlers = _vehicle getVariable ['hasHandlers', false];
if (_hasHandlers) exitWith { true };

_vehicle removeAllEventHandlers "MPHit";
_vehicle removeAllEventHandlers "MPKilled";
_vehicle removeAllEventHandlers "Explosion";
_vehicle removeAllEventHandlers "HandleDamage";
_vehicle removeAllEventHandlers "EpeContact";
_vehicle removeAllEventHandlers "EpeContactStart";
_vehicle removeAllEventHandlers "GetOut";


if (isServer) then {

	if (isNil {_vehicle getVariable "GW_MPHitEH"}) then {	
		_vehicle setVariable ["GW_MPHitEH", _vehicle addMPEventHandler ["MPHit", handleHitVehicle]];
	};

	if (isNil {_vehicle getVariable "GW_MPKilledEH"}) then {	
		_vehicle setVariable ["GW_MPKilledEH", _vehicle addMPEventHandler ["MPKilled", handleKilledVehicle]];
	};

};

if (isNil {_vehicle getVariable "GW_handleDamageHP"}) then {

	_vehicle setVariable ["GW_handleDamageHP", true, true];

	if (isNil { _vehicle getVariable 'GW_Hitpoints' }) then {

		{
			_vehicle setVariable ["GW_hitPoint_" + getText (_x >> "name"), configName _x, true];
			false
		} count ((typeOf _vehicle) call getHitPoints) > 0;

		_vehicle setVariable ['GW_Hitpoints', true, true];
	};	
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

if (isNil {_vehicle getVariable "GW_EpeContactStartEH"}) then {	
	_vehicle setVariable ["GW_EpeContactStartEH", _vehicle addEventHandler ["EpeContactStart", handleContactStartVehicle]];
};

if (isNil {_vehicle getVariable "GW_handleGetInEH"}) then {
	_vehicle setVariable ["GW_handleGetInEH", _vehicle addEventHandler ["GetIn", handleGetIn]];
};

if (isNil {_vehicle getVariable "GW_handleGetOutEH"}) then {		
	_vehicle setVariable ["GW_handleGetOutEH", _vehicle addEventHandler ["GetOut", handleGetOut]];
};

_vehicle setVariable ['hasHandlers', true];

true