//
//      Name: handleDamageVehicle
//      Return: None
//

private ["_vehicle", "_selection", "_damage", "_ammo"];

_vehicle = _this select 0;
_selection = _this select 1;
_damage = _this select 2;

_origDamage = _damage;
_oldDamage = nil;
_projectile = _this select 4;

// Prevent wheel damage
if (_selection find "wheel" != -1) exitWith { false }; 

if (_selection != "?") then  {

    _oldDamage = if (_selection == "") then { 
        damage _vehicle 
    } else {  
        _vehicle getHitPointDamage (_vehicle getVariable ["GW_hitPoint_" + _selection, ""]) 
    };

    if (!isNil "_oldDamage") then  {

        if (_projectile == "") then {

            _selSubstr = toArray _selection;
            _selSubstr resize 5;

            _scale = switch (true) do {
                case (toString _selSubstr == "wheel"): { WHEEL_COLLISION_DMG_SCALE };
                default                                { COLLISION_DMG_SCALE };
            };

            _damage = ((_damage - _oldDamage) * _scale) + _oldDamage;  

        } else {

            _scale = _projectile call vehicleDamageData;

            _status = _vehicle getVariable ['status', []];
            _armor = _vehicle getVariable ['armor', 1];
            _scale = if (GW_ARMOR_SYSTEM_ENABLED) then { (_scale * _armor) } else { _scale };
            _scale = if ("nanoarmor" in _status) then { 0.01 } else { _scale };

            _damage = ((_damage - _oldDamage) * _scale) + _oldDamage; 

        };

    };

};

if (GW_DEBUG) then {
    _str = format['%1 / %2 / %3 / %4', typeof _vehicle, _damage, _selection, (getDammage _vehicle)];
    systemchat _str;
    pubVar_systemChat = _str;
    publicVariable "pubVar_systemChat";
};

// If we're invulnerable, ignore all damage
_status = _vehicle getVariable ["status", []];
if ("invulnerable" in _status) then {
    _damage = false;
}  else {
    
    // Match damage to crew
    _vDmg = getDammage _vehicle;
    _crew = crew _vehicle;
    { _x setDammage _vDmg; } ForEach _crew;

    // Match max part damage to all other parts
    _highestDmg = 0;
    _parts = ['palivo', 'motor', 'karoserie'];
    { 
        _dmg = _vehicle getHit _x; 
        if (!isNil "_dmg") then {
            if (_dmg > _highestDmg) then {
                _highestDmg = _dmg;
            };
        };
        false
    } count _parts > 0;

   

    if (_highestDmg > 0.91) then {} else {
        { _vehicle setHit [_x, _highestDmg]; false } count _parts > 0;
        _vehicle setDammage _highestDmg;
    };

};

_vehicle spawn { Sleep 0.05; _this call updateVehicleDamage; };
[_vehicle, ['noservice'], 5] call addVehicleStatus;

_damage

