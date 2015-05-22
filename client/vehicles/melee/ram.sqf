private ['_source', '_target', '_collide', '_velocity', '_damage', '_multiplier'];

if (isNil "GW_LAST_COLLISION") then { GW_LAST_COLLISION = time - (GW_COLLISION_FREQUENCY / 2); };
if (time - GW_LAST_COLLISION < (GW_COLLISION_FREQUENCY / 2)) exitWith { true };
GW_LAST_COLLISION = TIME;

_source = _this select 0;
_target = _this select 1;
	
_status = _target getVariable ['status', []];
if ('invulnerable' in _status || 'cloak' in _status) exitWith { true };

_vehicle = attachedTo _source;
_damage = [(random 0.15), 0.05, 0.1] call limitToRange;
_velocity = (velocity _vehicle) distance [0,0,0];   
_source setDammage (getDammage _source) + ((random 0.1) + 0.01); 

if ((getDammage _source) >= 1) exitWith {

    playSound3D ["a3\sounds_f\sfx\vehicle_collision.wss", _source, false, (ASLtoATL visiblePositionASL _source), 10, 1, 50];

    [       
        [
            _source modelToWorldVisual [0,0,0]
        ],
        "impactEffect",
        true,
        false 
    ] call gw_fnc_mp;        

    deleteVehicle _source;

    true

};

[       
    [
        _source modelToWorldVisual [0,0,0]
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

[_target, 'WBR'] call markAsKilledBy;

if (GW_DEBUG) then { 
    systemchat format['damage: %1 / %2', _damage, getdammage _target]; 
};

true
