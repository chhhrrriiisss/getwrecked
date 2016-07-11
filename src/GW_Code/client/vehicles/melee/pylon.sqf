private ['_source', '_target', '_collide', '_velocity', '_damage', '_multiplier'];

if (isNil "GW_LAST_COLLISION") then { GW_LAST_COLLISION = time - GW_COLLISION_FREQUENCY; };
if (time - GW_LAST_COLLISION < GW_COLLISION_FREQUENCY) exitWith { true };
GW_LAST_COLLISION = TIME;

params ['_source', '_target'];
	
_status = _target getVariable ['status', []];
if ('invulnerable' in _status || 'cloak' in _status) exitWith { true };

_vehicle = attachedTo _source;
_velocity = (velocity _vehicle) distance [0,0,0];	
_damage = if ('nanoarmor' in _status) then { 0.001 } else { (((random 0.046) + 0.023) * GW_GMM) };

_damageSelf = ((random 0.025) + 0.01) * GW_MELEE_DEGRADATION;
_source setDammage (getDammage _source) + _damageSelf; 

_pos = lineIntersectsSurfaces [visiblePositionASL _source, ATLtoASL (_source modelToWorldVisual [0,-2,0]), _source, GW_CURRENTVEHICLE, true, 1];

if (count _pos > 0) then {
    [       
        [
            (ASLtoATL ((_pos select 0) select 0))
        ],
        "impactEffect",
        true,
        false 
    ] call bis_fnc_mp; 
};

_target setDammage (getDammage _target) + _damage;

[       
    _target,
    "updateVehicleDamage",
    _target,
    false 
] call bis_fnc_mp; 

[_target, 'CRR'] call markAsKilledBy;

if (GW_DEBUG) then { systemchat format['damage: %1 / %2', _damage, getdammage _target]; };

true
