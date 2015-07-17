private ['_source', '_target', '_collide', '_vehicle', '_damage', '_vp'];

if (isNil "GW_LAST_COLLISION") then { GW_LAST_COLLISION = time - GW_COLLISION_FREQUENCY; };
if (time - GW_LAST_COLLISION < GW_COLLISION_FREQUENCY) exitWith { true };
GW_LAST_COLLISION = TIME;

params ['_source', '_target'];

_collide = false;

_status = _target getVariable ['status', []];
if ('invulnerable' in _status || 'cloak' in _status) exitWith { true };

_vehicle = attachedTo _source;
_vP = _vehicle worldToModelVisual (_target modelToWorldVisual [0,0,0]);				
_damage = if ('nanoarmor' in _status) then { 0.001 } else { ((random 0.05) + 0.025) };
_source setDammage (getDammage _source) + ((random 0.1) + 0.01); 

[       
    [
        _source modelToWorldVisual [1,0,0]
    ],
    "impactEffect",
    true,
    false 
] call bis_fnc_mp; 

if ((_target isKindOf "Car") && !('forked' in _status || 'nofork' in _status) ) then  {

	[       
	    [
	        _target,
	        _vehicle,
	        _damage,
	        _vP
	    ],
	    "forkEffect",
	    _target,
	    false 
	] call bis_fnc_mp; 

	[_target, 'FRK'] call markAsKilledBy;

	_collide = false;

} else {
	
	_target setDammage ((getDammage _target) + _damage);

	[       
	    _target,
	    "updateVehicleDamage",
	    _target,
	    false 
	] call bis_fnc_mp; 

	_collide = true;

};

if (GW_DEBUG) then { systemchat format['damage: %1 / %2', _damage, getdammage _target]; };

_collide