//
//      Name: effectIsVisible
//      Desc: Check if a particular effect should be rendered by comparing max effect range and source FOV
//      Return: Bool
//

private ['_pos', '_duration', '_source', '_scope', '_dist', '_target'];

_target = [_this, 0, [], [[]]] call filterParam;
_duration = [_this, 1, 0, [0]] call filterParam;

if (GW_PREVIEW_CAM_ACTIVE || count _target == 0) exitWith { false };

// Get the source for this client, even if we're currently in a preview camera
_source = if (GW_DEATH_CAMERA_ACTIVE) then {
	[(positionCameraToWorld [0,0,0]), [(positionCameraToWorld [0,0,0]), (positionCameraToWorld [0,0,4])] call dirTo]
} else {
	[(ASLtoATL visiblePositionASL player), direction player]
};

// Outside effects range dont worry about it
_dist = (_target distance (_source select 0));
if (_dist > GW_EFFECTS_RANGE) exitWith { false };

// Super close? Dont do a FOV check
if (_dist < 15) exitWith { true };

// Inside effects range but duration is long enough we PROBABLY shouldnt check the direction
if (_duration > 0.5) exitWith { true };

// Check the effect is within our FOV
_dirTo = [(_source select 1), _target] call dirTo;
_dif = abs ( [(_source select 1) - _dirTo] call flattenAngle );

if (_dif < 80) exitWith { true };

false
