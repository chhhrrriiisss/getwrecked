//
//      Name: setVehicleDamage
//      Return: Set damage to vehicle and all config points
//

private ["_vehicle", "_damage", "_hitdamages"];

_vehicle = _this select 0;
_damage = _this select 1;
_hitdamages = [];

{
    _d = (_vehicle getHitPointDamage _x);
    _hitdamages pushBack [_x, _d];
    false
} count (_vehicle getVariable ['GW_Hitpoints', []]) > 0;

_vehicle setDamage _damage;

{
    _vehicle setHit [_x select 0, _x select 1];
    false
} count _hitdamages > 0;
