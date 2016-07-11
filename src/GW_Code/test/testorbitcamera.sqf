//
//      Name: testfinishcamera
//      Desc: 
//      Return: 
//

private ["_cam", "_victim", "_killer", "_centerCamera"];

_startPosition = positionCameraToWorld [0,0,0];
_targetPosition = positionCameraToWorld [0,0,50];

_dirTo = [_startPosition, _targetPosition] call dirTo;

_cam = "camera" camCreate _startPosition;
_cam camSetTarget GW_CURRENTVEHICLE;
_cam cameraeffect["internal","back"];
_cam camCommit 0;

_camPos = getPos _cam;
_phi = 1;
_theta = [getDir GW_CURRENTVEHICLE + 90] call normalizeAngle;
_r = 3;
_rz = 3;

waitUntil {	

	_rx = _r * (sin _theta) * (cos _phi);
	_ry = _r * (cos _theta) * (cos _phi);
	

	_cam camSetRelPos [_rx,_ry,_rz];
	_cam camCommit 0;

	_theta = _theta - 0.2;
	_theta = _theta mod 360;

	_r = [_r + 0.02, 1, 10] call limitToRange;
	_rz = [_rz + 0.01, 1, 5] call limitToRange;

	!alive GW_CURRENTVEHICLE
};

player cameraeffect["terminate","back"];
camdestroy _cam;
"colorCorrections" ppEffectEnable false;
"filmGrain" ppEffectEnable false;

