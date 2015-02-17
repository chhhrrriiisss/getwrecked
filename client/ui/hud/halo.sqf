//
//	  createHalo
//	  Desc: Create a temporary circular indicator around the target vehicle
//	  return (none)
//

private ['_vehicle', '_condition'];

_vehicle = [_this,0, objNull , [objNull]] call BIS_fnc_param;
_duration = [_this,1, 0 , [0]] call BIS_fnc_param;
_texture = [_this,2, "" , [""]] call BIS_fnc_param;
_condition = [_this,3, { true } , [{}]] call BIS_fnc_param;
_rotate = [_this,4, true , [false]] call BIS_fnc_param;


if (isNull _vehicle || _duration == 0 || _texture == "") exitWith {};
if (!local _vehicle) exitWith {};

_pos = (ASLtoATL visiblePositionASL _vehicle);
_pos set[2, 0.35];

_ringTop = createVehicle ['UserTexture10m_F', _pos, [], 0, 'CAN_COLLIDE'];
_ringBottom = createVehicle ['UserTexture10m_F', _pos, [], 0, 'CAN_COLLIDE'];

_ringTop attachTo [_vehicle, _vehicle worldToModelVisual (ASLtoATL getPosASL _ringTop)];
_ringBottom attachTo [_vehicle, _vehicle worldToModelVisual (ASLtoATL getPosASL _ringBottom)];

[_ringTop, [-90,0,0]] call setPitchBankYaw;
[_ringBottom, [90,0,0]] call setPitchBankYaw;

_timeout = time + _duration;
_dir = getDir _ringTop;

Sleep 0.01;

_ringTop setObjectTextureGlobal [0, _texture];
_ringBottom setObjectTextureGlobal [0, _texture];

waitUntil {

	_dir = _dir + (	if (_dir > 360) then [{-360},{2}]	);
	_dir = if (_rotate) then { _dir } else { 0 };
	[_ringTop, [-90,0,_dir]] call setPitchBankYaw;
	[_ringBottom, [90,0,_dir]] call setPitchBankYaw;

	( (time > _timeout) || !([] call _condition) )
};

deleteVehicle _ringTop;	
deleteVehicle _ringBottom;
