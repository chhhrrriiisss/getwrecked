//
//      Name: deathCamera
//      Desc: Overview camera that is shown after the player dies
//      Return: None
//

private ["_cam", "_victim", "_killer", "_centerCamera"];

// Optional toggle to prevent death camera showing in certain conditions (race ending for example)
if (GW_IGNORE_DEATH_CAMERA) exitWith { 
	GW_IGNORE_DEATH_CAMERA = false; 
	player cameraeffect["terminate","back"]; 
	9999 cutText ["", "BLACK IN", 1.5]; 

	// Set our current zone early
	["workshopZone"] call setCurrentZone;
};

_target = if (!isNil { _this select 0 }) then { (_this select 0) } else { (getMarkerPos "workshopZone_camera") };
_type = [_this,1, "default", [""]] call filterParam;

9999 cutText ["", "BLACK IN", 1.5];  

// Reset kill stats
IF (GW_DEATH_CAMERA_ACTIVE) exitWith {};
GW_DEATH_CAMERA_ACTIVE = true;

// Create a timer dialog
[] spawn {
	_result = ['RESPAWN', GW_RESPAWN_DELAY, true] call createTimer;
	if (GW_DEATH_CAMERA_ACTIVE) then { GW_DEATH_CAMERA_ACTIVE = false;	};
};

_targetPosition = if (_target isEqualType objNull) then { (ASLtoATL visiblePositionASL _target) } else { _target };
_cam = "camera" camCreate [_targetPosition select 0, _targetPosition select 1, 30];

_timeout = time + GW_RESPAWN_DELAY;

// Initialize the camera based on type requested
switch (_type) do {
	
	case "nukefocus":
	{
		profileNamespace setVariable ['killedByNuke', []];
		saveProfileNamespace;

		_cam camSetTarget _targetPosition;
		_cam cameraeffect["internal","back"];
		_cam camCommit 0;

		// Determine orbit position
		_theta = random 360;
		_r = 400;
		_phi = 1;
		_rx = _r * (sin _theta) * (cos _phi);
		_ry = _r * (cos _theta) * (cos _phi);
		_rz = 70;

		// Apply to camera
		_cam camSetRelPos [_rx, _ry, 100];

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
