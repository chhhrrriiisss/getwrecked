//
//      Name: fireGuided
//      Desc: Fires a missile that can be controlled
//      Return: None
//

private ['_gun', '_target', '_vehicle'];

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerInterlace = ("BIS_layerInterlacing" call BIS_fnc_rscLayer);
_layerDisplay = ("Custom_Layer" call BIS_fnc_rscLayer);
    
_gun = _this select 0;
_target = _this select 1;
_vehicle = _this select 2;

// Missile Properties
_repeats = 1;
_round = "M_Titan_AT";
_soundToPlay = "a3\sounds_f\weapons\Launcher\nlaw_final_2.wss";
_fireSpeed = 1;
_projectileSpeed = 70;
_range = 2500;

// Flight properties
_minFlightSpeed = 35;
_maxFlightSpeed = 100;
_maxFlightTime = time + 12;
_releaseTime = time;
yawFactor = 72;
pitchFactor = 25;

// Get initial heading 
_vehDir = getDir _vehicle;
_gunDir = [((getDir _gun) + 90)] call normalizeAngle;
_gPos = _gun modelToWorldVisual [2,0,0];
tPos = _gun modelToWorldVisual [3000, 0, 30];

missileHeading = [_gPos,tPos] call BIS_fnc_vectorFromXToY;
missileVelocity = [missileHeading, _projectileSpeed] call BIS_fnc_vectorMultiply; 

// Release the hound!
missile = createVehicle [_round, _gPos, [], 0, "FLY"];
missile setVectorUp missileHeading; 
missile setVelocity missileVelocity;

playSound3D ["a3\sounds_f\weapons\Launcher\nlaw_final_2.wss", missile, false, (visiblePosition missile), 5, 1, 100];

// Screen effects
showCinemaBorder false;
titlecut["","BLACK IN",0.5];

_layerStatic cutRsc ["RscStatic", "PLAIN",2];      
_layerInterlace cutRsc ["RscInterlacing", "PLAIN" ,2];

"colorCorrections" ppEffectEnable true; 
"colorCorrections" ppEffectAdjust [1, 0.3, 0, [1,1,1,-0.1], [1,1,1,2], [-0.5,-1,-1,-0.5]]; 
"colorCorrections" ppEffectCommit 1; 

"radialBlur" ppEffectEnable true;
"radialBlur" ppEffectAdjust [0.005,0.005,0.15,0.15]; 
"radialBlur" ppEffectCommit 1;

// Set initial position
_cam = "camera" camCreate _gPos;

_cam cameraEffect ["internal","back"];
_cam camSetTarget missile;
_cam camSetRelPos [0,-1,0.05];
_cam camCommit 0;

stopMissile = false;

// For controlling the missile
alterPath = {

	_key = _this select 1; // The key that was pressed
	_dir = [missile, tPos] call dirTo;

	// esc
	if (_key == 1) then {
		stopCamera = true;
	};

	// w
	if (_key == 31) then {
		tPos set[2, (tPos select 2) - pitchFactor];
	};

	// S
	if (_key == 17) then {
		tPos set[2, (tPos select 2) + pitchFactor];
	};

	// A
	if (_key == 30) then {		
		_dir = _dir - yawFactor;
		tPos = [tPos, 15, _dir] call BIS_fnc_relPos;
	};

	// D
	if (_key == 32) then {
		_dir = _dir + yawFactor;	
		tPos = [tPos, 15, _dir] call BIS_fnc_relPos;

	};

};

_missileControls = (findDisplay 46) displayAddEventHandler ["KeyDown", "_this call alterPath; false;"];

waitUntil {
	
	_lastPos = screenToWorld [0.5, 0.5];
	[_lastPos, 5, "GUD"] spawn markNearby;	

	// Calculate its speed
	_dist = (missile distance _vehicle) / 200;
	_difTime = time - _releaseTime;
	_calcSpeed = (_projectileSpeed * _dist * _difTime);
	if (_calcSpeed < _minFlightSpeed) then { _calcSpeed = _minFlightSpeed; };
	if (_calcSpeed > _maxFlightSpeed) then { _calcSpeed = _maxFlightSpeed; };

	// Get updated heading, if its been changed
	_gPos = visiblePosition missile;

	missileHeading = [_gPos,tPos] call BIS_fnc_vectorFromXToY;
	missileVelocity = [missileHeading, _calcSpeed] call BIS_fnc_vectorMultiply;

	_sA = 0.002; 

	// Add some shake
	missileHeading set [0, (missileHeading select 0) + ((random _sA) - (_sA/2))];
	missileHeading set [1, (missileHeading select 1) + ((random _sA) - (_sA/2))];
	missileHeading set [2, (missileHeading select 2) + ((random _sA) - (_sA/2))];

	// Set position/heading
	missile setVectorDir missileHeading;
	missile setVelocity missileVelocity;

	// Update camera, only if missile alive
	if (alive missile) then {	

		_cam camSetTarget missile;
		_cam camSetRelPos [0,-3,0];
		_cam camPrepareFOV 0.6;
		_cam camCommit 0;

		_src = getPosASL missile;
		_des = missile modelToWorldVisual [0,0,15];
		_objs = lineIntersectsWith [_src, _des, (vehicle player), (player), false];

		if (count _objs > 0) then {

			{
				_isVehicle = _x getVariable ["isVehicle", false];
				_killedBy = _x getVariable ["killedBy", ["Nobody", ""]];

				if ( ( (_killedBy select 0) == "Nobody" || (_killedBy select 0) != GW_PLAYERNAME ) && _isVehicle) then {	
					[_x, "GUD"] call markAsKilledBy;
				};
				false
			} count _objs > 0;

		};


	};

	(stopMissile || !alive missile || time > _maxFlightTime)
};


// Tidy up, restore effects, destroy cam
_layerStatic cutRsc ["RscStatic", "PLAIN",1];      
titlecut["","BLACK OUT",1];
(findDisplay 46) displayRemoveEventHandler ["KeyDown", _missileControls];
Sleep 0.5;

_layerInterlace cutText ["", "PLAIN DOWN" ,0];
camdestroy _cam;
player cameraeffect["terminate","back"];

"colorCorrections" ppEffectEnable false; 
"radialBlur" ppEffectEnable false;

showCinemaBorder true;
titlecut["","PLAIN DOWN",0];

true
