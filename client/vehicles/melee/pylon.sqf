private ['_source', '_target', '_collide', '_velocity', '_damage', '_multiplier'];

if (isNil "GW_LAST_COLLISION") then { GW_LAST_COLLISION = time - GW_COLLISION_FREQUENCY; };
if (time - GW_LAST_COLLISION < GW_COLLISION_FREQUENCY) exitWith { true };
GW_LAST_COLLISION = TIME;

_source = _this select 0;
_target = _this select 1;
	
_status = _target getVariable ['status', []];
if ('invulnerable' in _status || 'cloak' in _status) exitWith { true };

_vehicle = attachedTo _source;
_velocity = (velocity _vehicle) distance [0,0,0];	
_multiplier = [((random (_velocity/100)) + ((_velocity/100) * 0.25)), 0.04, 0.5] call limitToRange;
_damage = if ('nanoarmor' in _status) then { 0.001 } else { _multiplier };
_source setDammage (getDammage _source) + ((random 0.05) + 0.01); 

[       
    [
        _source modelToWorldVisual [0,-2,0]
    ],
    "impactEffect",
    true,
    false 
] call gw_fnc_mp; 

_target setDammage (getDammage _target) + _damage;

[       
    _target,
    "updateVehicleDamage",
    _target,
    false 
] call gw_fnc_mp; 

[_target, 'CRR'] call markAsKilledBy;

if (GW_DEBUG) then { systemchat format['damage: %1 / %2', _damage, getdammage _target]; };

true
