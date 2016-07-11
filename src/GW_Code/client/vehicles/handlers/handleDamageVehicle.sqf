//
//      Name: handleDamageVehicle
//      Return: None
//

private ["_vehicle", "_selection", "_damage", "_ammo"];
params ['_vehicle', '_selection', '_damage', '_nil', '_projectile'];

// If we're in the workshop, ignore all damage
if (_vehicle distance (getMarkerPos "workshopZone_camera") < 500) exitWith { false };

_origDamage = _damage;
_oldDamage = nil;
_scale = 1;
_armor = 1;   

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
            _armor = _vehicle getVariable ['GW_Armor', 1];
            _armor = if (_armor <= 0) then { 1 } else { _armor };
            _scale = if (GW_ARMOR_SYSTEM_ENABLED) then { (_scale * _armor) } else { _scale };
            _scale = if ("nanoarmor" in _status) then { 0.01 } else { _scale };
            _damage = ((_damage - _oldDamage) * _scale) + _oldDamage; 

        };

    };

};

// Debug damage 
if (isNil "GW_LASTDAMAGEMESSAGE") then { GW_LASTDAMAGEMESSAGE = time - 0.25; };
if (GW_DEBUG && (time - GW_LASTDAMAGEMESSAGE > 0.25)) then {

    GW_LASTDAMAGEMESSAGE = time;
    _vName = _vehicle getVariable ['name', 'A vehicle'];
    _health = _vehicle getVariable ['GW_Health', 100];
    _str = format['V: %1 A: %2 D: %3 H: %4 P:%5', _vName, _armor, _scale, _health, _projectile];
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

    { _vehicle setHit [_x, _highestDmg]; false } count _parts > 0;  

};



// Update the vehicle damage status bar
_vehicle spawn { 

    Sleep 0.01; 

    // Apply vehicle damage to driver
    _vehDamage = getDammage _this;
    if (getDammage (driver _this) != (_vehDamage)) then { (driver _this) setDammage _vehDamage; };

    _this call updateVehicleDamage; 

    if (!GW_DEBUG) exitWith {};

    _firstHit = _this getVariable ['firstHit', nil];
    if (isNil "_firstHit") then { _this setVariable ['firstHit', time]; };

    _health = _this getVariable ["GW_Health", 0];
    _name = _this getVariable ['name', 'vehicle'];
    _isDead = _this getVariable ["isDead", false];
    if (_health == 0 && !_isDead) then {
        _this setVariable ['isDead', true];
        _firstHit = _this getVariable ['firstHit', time];
        systemchat format['%1 destroyed in %2', _name, ([(time - _firstHit),1] call roundTo)];
    };  
   
};



[_vehicle, ['noservice'], 10] call addVehicleStatus;

_damage

