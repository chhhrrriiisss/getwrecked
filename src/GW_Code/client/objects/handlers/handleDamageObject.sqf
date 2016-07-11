//
//      Name: handleDamageObject
//      Desc: Damage event handler for objects
//      Return: Bool (False, as health handled independently)
//

private ["_obj", "_damage", "_projectile"];
params ['_obj', '_nil', '_damage', '_nil', '_projectile'];

if (_obj distance (getMarkerPos "workshopZone_camera") < 200) exitWith { false };

// Dont handle damage for weapons or modules
_tag = _obj getVariable ["GW_Tag", ""];
if (_tag in GW_WEAPONSARRAY || _tag in GW_LOCKONWEAPONS || _tag in GW_TACTICALARRAY || _tag in GW_SPECIALARRAY) exitWith {
    _obj removeAllEventHandlers "handleDamage";
    _obj addEventHandler ['handleDamage', { false }];
    false 
};

_data = _obj getVariable ["GW_Data", "['Bad data', 0, 0, 0, '']"];
_data = call compile _data;
_originalHealth = if (isNil "_data") then { 1 } else { (_data select 4) };
_health = _obj getVariable ["GW_Health", 0];

// If it's not already dead
if (_health > 0) then  {

    if (_projectile == "") then {

        _damage = (_damage * OBJ_COLLISION_DMG_SCALE);

    } else {

        _scale = _projectile call objectDamageData;
        _damage = (_damage * _scale);

    };    
   
};

_health = _health - _damage;

_name = (_obj getVariable ['name', 'object']);


if (_health < 0) then {

    _obj spawn {       
        [_this, true] spawn destroyObj;
    };

} else {	
	_obj setVariable["GW_Health", _health, true];
};

if (GW_DEBUG) then {
    _str = format['%1 / %2 / %3 %4', typeof _obj, _damage, _health];
    systemchat _str;
    pubVar_systemChat = _str;
    publicVariable "pubVar_systemChat";
};


false
