
_p1 = (ATLtoASL positionCameraToWorld [0,0,-1]);
_p2 = (ATLtoASL positionCameraToWorld [0,0,10]);

_intersects = lineIntersectsSurfaces [_p1, _p2, player, objNull, true, 5, "VIEW"];

if (count _intersects == 0) exitWith { systemchat "Found nothing"; };

_target = [];
_isObjectOnVehicle = false;
_targetVehicle = objNull;

{
	_targetVehicle = if (isNull attachedTo (_x select 2)) then { (_x select 2) } else { _isObjectOnVehicle = true; (_x select 3) };
	_isVehicle = _targetVehicle getVariable ['isVehicle', false];	
	if (_isVehicle) exitWith { _target = _x; };

} foreach _intersects;

if (count _target == 0) exitWith {};
if (isNull _targetVehicle) exitWith {};

_int = (_target select 0);

// [(ASLtoATL _int), (ASLtoATL _p1), 3] spawn debugLine;

_vec = (_target select 1) vectorMultiply 1.5;
_int2 = _int vectorAdd _vec;
_intOut = _int vectorAdd ((_target select 1) vectorMultiply 0.05);

[(ASLtoATL _int), (ASLtoATL _int2), 3] spawn debugLine;

_decal = createVehicle ["UserTexture1m_F", _intOut, [], 0, 'CAN_COLLIDE']; 
_decal setObjectTextureGlobal [0, MISSION_ROOT + "client\images\signage\tyraid.jpg"];
_decal setPosASL _intOut;

// Set surface normal and apply rotations
_decal setVectorDirAndUp [[0.9,0,0], (_target select 1)];
// _pitchBank = _decal call BIS_fnc_getPitchBank;
// [_decal, [[((_pitchBank select 0) - 180)] call normalizeAngle, [((getDir _decal) - 180)] call normalizeAngle, [((getDir _decal) - 90)] call normalizeAngle ]] call setPitchBankYaw;

Sleep 5;

deleteVehicle _decal;

// _decal setVectorUp (_target select 1);
// _vect = [_decal, _targetVehicle] call getVectorDirAndUpRelative;
// _decal attachTo [_targetVehicle];
// _decal setVectorDirAndUp _vect;

systemchat format['%1 / %2 / %3', (_targetVehicle getVariable ['name', 'noname']), _isObjectOnVehicle, time ];