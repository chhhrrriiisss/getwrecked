//
//      Name: setupLocalObjectHandlers
//      Desc: Adds event handlers to a local object
//      Return: None
//

private ['_obj'];

_obj = _this select 0;

if (isNil {_obj getVariable "GW_handleTakeEH"} && typeOf _obj == 'groundWeaponHolder') then {
	_obj setVariable ["GW_handleTakeEH", _obj addEventHandler ["Take", handleTakeObject]];
};

if (isNil {_obj getVariable "GW_handleKilledEH"}) then {
	_obj setVariable ["GW_handleKilledEH", _obj addEventHandler ["Killed", handleKilledObject]];
};

if (isNil {_obj getVariable "GW_handleDamageEH"}) then {
	_obj setVariable ["GW_handleDamageEH", _obj addEventHandler ["handleDamage", handleDamageObject]];
};

if (isNil {_obj getVariable "GW_handleExplosionEH"}) then {
	_obj setVariable ["GW_handleExplosionEH", _obj addEventHandler ["Explosion", handleExplosionObject]];
};

if (isNil {_obj getVariable "GW_handleEpeContactEH"}) then {
	_obj setVariable ["GW_handleEpeContactEH", _obj addEventHandler ["EpeContact", handleContactObject]];
};

if (isNil {_obj getVariable "GW_handleDisassembled"}) then {
	_obj setVariable ["GW_handleDisassembled", _obj addEventHandler ["weaponDisassembled", handleDisassembledObject]];
};

true	
