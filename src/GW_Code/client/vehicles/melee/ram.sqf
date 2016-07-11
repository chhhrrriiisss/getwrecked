private ['_source', '_target', '_collide', '_velocity', '_damage', '_multiplier'];

if (isNil "GW_LAST_COLLISION") then { GW_LAST_COLLISION = time - (GW_COLLISION_FREQUENCY / 2); };
if (time - GW_LAST_COLLISION < (GW_COLLISION_FREQUENCY / 2)) exitWith { true };
GW_LAST_COLLISION = TIME;

params ['_source', '_target'];
	
_status = _target getVariable ['status', []];
if ('invulnerable' in _status || 'cloak' in _status) exitWith { true };

_vehicle = attachedTo _source;      
_velocity = GW_CURRENTVEL distance [0,0,0]; 
_multiplier = [((random (_velocity/100)) + ((_velocity/100) * 0.25)), 0.04, 0.5] call limitToRange;
_damage = if ('nanoarmor' in _status) then { 0.001 } else { (_multiplier*GW_GMM) };

_damageSelf = ((random 0.08) + 0.03) * GW_MELEE_DEGRADATION;
_source setDammage (getDammage _source) + _damageSelf; 

if ((getDammage _source) >= 1) exitWith {

    playSound3D ["a3\sounds_f\sfx\missions\vehicle_collision.wss", _source, false, (ASLtoATL visiblePositionASL _source), 10, 1, 50];

    [       
        [
            _source modelToWorldVisual [0,0,0]
        ],
        "impactEffect",
        true,
        false 
    ] call bis_fnc_mp;        

    deleteVehicle _source;

    true

};

_pos = lineIntersectsSurfaces [visiblePositionASL _source, ATLtoASL (_source modelToWorldVisual [2,0,0]), _source, GW_CURRENTVEHICLE, true, 1];

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

[_target, 'WBR'] call markAsKilledBy;

if (GW_DEBUG) then { 
    systemchat format['damage: %1 / %2', _damage, getdammage _target]; 
};

true
