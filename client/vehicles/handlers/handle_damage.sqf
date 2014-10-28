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

            _scale = switch (_projectile) do
            {
                case ("R_PG32V_F"): { RPG_DMG_SCALE };
                case ("M_Titan_AT"): { TITAN_AT_DMG_SCALE };
                case ("M_NLAW_AT_F"): { GUD_DMG_SCALE };
                case ("B_127x99_Ball_Tracer_Red"): { LSR_DMG_SCALE };
                case ("B_127x99_Ball"): { HMG_DMG_SCALE };
                case ("B_127x99_Ball_Tracer_Yellow"): { HMG_IND_DMG_SCALE };
                case ("B_35mm_AA_Tracer_Yellow"): { HMG_HE_DMG_SCALE };
                case ("R_TBG32V_F"): { MORTAR_DMG_SCALE };                
                case ("G_40mm_HEDP"): { GMG_DMG_SCALE };
                case ("Bo_GBU12_LGB"): { EXP_DMG_SCALE };    
                default                                { 1 };
            };

            _damage = ((_damage - _oldDamage) * _scale) + _oldDamage; 

        };

        // Stop immobilization when engine is hit
        if (_selection == "engine") then {
            _vehicle setHit ["engine", 0];
        }; 

    };

};

// Check tyres and whether we need to eject
[_vehicle] spawn checkTyres; 
[_vehicle, player] call checkEject;

// If we're invulnerable, ignore all damage
_status = _vehicle getVariable ["status", []];
if ("invulnerable" in _status) then {
    _damage = 0;
}  else {
    _vDmg = getDammage _vehicle;
    _crew = crew _vehicle;
    { _x setDammage _vDmg; } ForEach _crew;
};

_damage

