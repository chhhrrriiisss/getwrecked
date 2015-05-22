//
//      Name: setObjectHandlers
//      Desc: Adds eh's to object
//      Return: Bool
//

private ['_obj'];

_obj = _this select 0;

if (isServer) then {

	if (isNil {_obj getVariable "GW_MPHitEH"}) then {	
		_obj setVariable ["GW_MPHitEH", _obj addMPEventHandler ["MPHit", handleHitObject]];
	};

	if (isNil {_obj getVariable "GW_MPKilledEH"}) then {	
		_obj setVariable ["GW_MPKilledEH", _obj addMPEventHandler ["MPKilled", handleKilledObject]];
	};

};

if (isNil {_obj getVariable "GW_ExplosionEH"}) then {	
	_obj setVariable ["GW_ExplosionEH", _obj addEventHandler ["Explosion", handleExplosionObject]];
};

if (isNil {_obj getVariable "GW_HandleDamageEH"}) then {
	_obj setVariable ["GW_HandleDamageEH", _obj addEventHandler ["HandleDamage", handleDamageObject]];
};

if (isNil {_obj getVariable "GW_EpeContactEH"}) then {	
	_obj setVariable ["GW_EpeContactEH", _obj addEventHandler ["EpeContact", handleContactObject]];
};

_obj setVariable ['hasHandlers', true];


true
