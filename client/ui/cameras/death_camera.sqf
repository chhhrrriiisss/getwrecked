//
//      Name: deathCamera
//      Desc: Overview camera that is shown after the player dies
//      Return: None
//

private ["_cam", "_victim", "_killer", "_centerCamera"];

_victim = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_killer = [_this,1, objNull, [objNull]] call BIS_fnc_param;

_point = getMarkerPos format['%1_%2', GW_CURRENTZONE, 'camera'];
_centerCamera = if (_point distance [0,0,0] <= 0) then { getMarkerPos "workshopZone_camera" } else { _point };

_target = _centerCamera;
_type = 'default';

if (!isNull _killer && !isNull _victim) then {

	// Possible suicide, try go to overview shot
	if ((_killer == _victim) || (!alive _killer)) exitWith {		

		// Do we have a previous position to work with?
		_prevPos = _victim getVariable ['prevPos', nil];
		_target = if (!isNil "_prevPos") then { _prevPos } else { _centerCamera };
		_type = 'overview';

	};

	// Definitely a homocide! Killer is alive and in a vehicle
	if (alive _killer && (_killer != (vehicle _killer)) ) exitWith {
		_target= vehicle _killer;
		_type = 'focus';
	};

} else {
	
	// No clue, just show something
	_target = _centerCamera;
	_type = 'default';

};

// Reset kill stats
player setVariable ["killedBy", nil];
player setVariable ["prevPos", nil];

GW_DEATH_CAMERA_ACTIVE = true;

9999 cutText ["", "BLACK IN", 1.5];  



// Create a timer dialog
[] spawn {
	_result = ['RESPAWN', GW_RESPAWN_DELAY, true] call createTimer;
	if (GW_DEATH_CAMERA_ACTIVE) then { GW_DEATH_CAMERA_ACTIVE = false;	};
};

_targetPosition = if (typename _target == "OBJECT") then { visiblePosition _target } else { _target };

_cam = [];	
_cam = "camera" camCreate [_targetPosition select 0, _targetPosition select 1, 30];

_timeout = time + GW_RESPAWN_DELAY;

// Initialize the camera based on type requested
switch (_type) do {

	case "focus":
	{
		_cam camSetTarget _target;
		_cam cameraeffect["internal","back"];
		_cam camCommit 0;

		// At least 2 metres away
		_rndX = ((random 50) - 25) + 2;
		_rndY = ((random 50) - 25) + 2; 
		_rndZ = (random 20) + 20;

		// Determine orbit position
		_theta = random 360;
		_r = 7;
		_phi = 1;
		_rx = _r * (sin _theta) * (cos _phi);
		_ry = _r * (cos _theta) * (cos _phi);
		_rz = _r * (sin _phi);

		// Apply to camera
		_cam camSetRelPos [_rx, _ry, _rz];

		while {time < _timeout && GW_DEATH_CAMERA_ACTIVE} do {

			_theta = _theta + 0.001;
			_theta = _theta mod 360;

			_r = _r + 0.00015;

			_rx = _r * (sin _theta) * (cos _phi);
			_ry = _r * (cos _theta) * (cos _phi);

			_cam camSetRelPos [_rx, _ry, _rz];
			_cam camCommit 0;

		};	

	};

	case "overview":
	{
		_cam camSetTarget _targetPosition;
		_cam cameraeffect["internal","back"];
		_cam camCommit 0;

		// Determine orbit position
		_theta = random 360;
		_r = 30;
		_phi = 1;
		_rx = _r * (sin _theta) * (cos _phi);
		_ry = _r * (cos _theta) * (cos _phi);
		_rz = 15;

		// Apply to camera
		_cam camSetRelPos [_rx, _ry, 25];

		while {time < _timeout && GW_DEATH_CAMERA_ACTIVE} do {

			_theta = _theta + 0.0001;
			_theta = _theta mod 360;

			_rx = _r * (sin _theta) * (cos _phi);
			_ry = _r * (cos _theta) * (cos _phi);
			_rz = _rz + 0.0001;

			_cam camSetRelPos [_rx, _ry, _rz];
			_cam camSetFocus [_r, 0.1];
			_cam camCommit 0;

		};	
	};

	default
	{	
		_cam camSetTarget _target;
		_cam cameraeffect["internal","back"];
		_cam camCommit 0;		

		// Determine orbit position
		_theta = random 360;
		_r = 150;
		_phi = 1;
		_rx = _r * (sin _theta) * (cos _phi);
		_ry = _r * (cos _theta) * (cos _phi);
		_rz = 30;

		// Apply to camera
		_cam camSetRelPos [_rx, _ry, _rz];

		while {time < _timeout && GW_DEATH_CAMERA_ACTIVE} do {

			_theta = _theta + 0.00005;
			_theta = _theta mod 360;

			_rx = _r * (sin _theta) * (cos _phi);
			_ry = _r * (cos _theta) * (cos _phi);

			_cam camSetRelPos [_rx, _ry, _rz];
			_cam camCommit 0;

		};	

	};

};

// Game over, now tidy up
waitUntil { (camCommitted _cam) };
player cameraeffect["terminate","back"];
"colorCorrections" ppEffectEnable false; 
camdestroy _cam;
GW_DEATH_CAMERA_ACTIVE = false;
