//
//      Name: fireGuided
//      Desc: Fires a GW_GUIDED_MISSILE that can be controlled
//      Return: None
//

private ['_gun', '_target', '_vehicle'];

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerInterlace = ("BIS_layerInterlacing" call BIS_fnc_rscLayer);
_layerDisplay = ("Custom_Layer" call BIS_fnc_rscLayer);
    
_gun = _this select 0;
_target = _this select 1;
_vehicle = _this select 2;

// GW_GUIDED_MISSILE Properties
_repeats = 1;
_round = "M_PG_AT";
_soundToPlay = "a3\sounds_f\weapons\Launcher\nlaw_final_2.wss";
_fireSpeed = 1;
_projectileSpeed = 70;
_range = 2500;

// Flight properties
_minFlightSpeed = 35;
_maxFlightSpeed = 100;
_maxFlightTime = time + 20;
_releaseTime = time;
yawFactor = 72;
pitchFactor = 25;

// Get initial heading 
_vehDir = getDir _vehicle;
_gunDir = [((getDir _gun) + 90)] call normalizeAngle;
_gPos = _gun modelToWorldVisual [2,0,0];
GW_GUIDED_TARGET = _gun modelToWorldVisual [3000, 0, 30];

GW_GUIDED_HEADING = [_gPos,GW_GUIDED_TARGET] call BIS_fnc_vectorFromXToY;
GW_GUIDED_VELOCITY = [GW_GUIDED_HEADING, _projectileSpeed] call BIS_fnc_vectorMultiply; 

// Release the hound!
GW_GUIDED_MISSILE = createVehicle [_round, _gPos, [], 0, "FLY"];
GW_GUIDED_MISSILE setVectorUp GW_GUIDED_HEADING; 
GW_GUIDED_MISSILE setVelocity GW_GUIDED_VELOCITY;

playSound3D ["a3\sounds_f\weapons\Launcher\nlaw_final_2.wss", GW_GUIDED_MISSILE, false, (visiblePosition GW_GUIDED_MISSILE), 5, 1, 100];

[_vehicle, ['radar'], 20] call addVehicleStatus;

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
_cam camSetTarget GW_GUIDED_MISSILE;
_cam camSetRelPos [0,-1,0.05];
_cam camCommit 0;

GW_GUIDED_ACTIVE = true;
GW_HUD_ACTIVE = false;
_lastMissilePos = [0,0,0];

waitUntil {

	_key = if (!isNil "GW_KEYDOWN") then { GW_KEYDOWN } else { if (isNil "_lastKey") exitWith { 0 }; _lastKey };	
	_dir = [GW_GUIDED_MISSILE, GW_GUIDED_TARGET] call dirTo;
	_lastKey = _key;

	// esc
	if (_key == 1) then { GW_GUIDED_ACTIVE = false; };

	// W & S
	if (_key == 31 || _key == 17) then {	
		_pitch = if (_key == 31) then { -25 } else { 25 };
		GW_GUIDED_TARGET set[2, (GW_GUIDED_TARGET select 2) + _pitch];
	}; 

	// A & D
	if (_key == 32 || _key == 30) then {	
		_dir = if (_key == 32) then { (_dir + 90) } else { (_dir - 90) };
		_rx = 15 * (sin _dir) * (cos 1);
		_ry = 15 * (cos _dir) * (cos 1);
		GW_GUIDED_TARGET = [(GW_GUIDED_TARGET select 0) + _rx, (GW_GUIDED_TARGET select 1) + _ry, (GW_GUIDED_TARGET select 2)];
	}; 

	_lastPos = screenToWorld [0.5, 0.5];
	[_lastPos, 5, "GUD"] spawn markNearby;	

	// Calculate its speed
	_dist = (GW_GUIDED_MISSILE distance _vehicle) / 200;
	_difTime = time - _releaseTime;
	_calcSpeed = (_projectileSpeed * _dist * _difTime);
	if (_calcSpeed < _minFlightSpeed) then { _calcSpeed = _minFlightSpeed; };
	if (_calcSpeed > _maxFlightSpeed) then { _calcSpeed = _maxFlightSpeed; };

	// Get updated heading, if its been changed
	_gPos = visiblePosition GW_GUIDED_MISSILE;

	GW_GUIDED_HEADING = [_gPos,GW_GUIDED_TARGET] call BIS_fnc_vectorFromXToY;
	GW_GUIDED_VELOCITY = [GW_GUIDED_HEADING, _calcSpeed] call BIS_fnc_vectorMultiply;

	_sA = 0.002; 

	// Add some shake
	GW_GUIDED_HEADING set [0, (GW_GUIDED_HEADING select 0) + ((random _sA) - (_sA/2))];
	GW_GUIDED_HEADING set [1, (GW_GUIDED_HEADING select 1) + ((random _sA) - (_sA/2))];
	GW_GUIDED_HEADING set [2, (GW_GUIDED_HEADING select 2) + ((random _sA) - (_sA/2))];



	// Set position/heading
	GW_GUIDED_MISSILE setVectorDir GW_GUIDED_HEADING;
	GW_GUIDED_MISSILE setVelocity GW_GUIDED_VELOCITY;

	// Update camera, only if GW_GUIDED_MISSILE alive
	if (alive GW_GUIDED_MISSILE) then {	

		_cam camSetTarget GW_GUIDED_MISSILE;
		_cam camSetRelPos [0,-3,0];
		_cam camPrepareFOV 0.6;
		_cam camCommit 0;

		_src = visiblePositionASL GW_GUIDED_MISSILE;
		_des = GW_GUIDED_MISSILE modelToWorldVisual [0,0,15];
		_objs = lineIntersectsWith [_src, _des, (vehicle player), (player), false];

		if (count _objs > 0) then {

			{
				_isVehicle = _x getVariable ["isVehicle", false];
				if (_isVehicle) then {  [_x, "GUD"] call checkMark; };
				false
			} count _objs > 0;

		};

		_lastMissilePos = (AsLtoATL _src);
	};

	(!GW_GUIDED_ACTIVE || !alive GW_GUIDED_MISSILE || time > _maxFlightTime)
};

if (!alive GW_GUIDED_MISSILE && _lastMissilePos distance [0,0,0] > 1) then {

	_nearby = _lastMissilePos nearEntities [["Car"], 7];
	if (count _nearby == 0) exitWith {};

	{
		_status = _x getVariable ['status', []];
		_isVehicle = _x getVariable ['isVehicle', false];
		_velocity = (velocity _x);

		// If its a vehicle and its going fast blow it up
		if (_isVehicle && !('invulnerable' in _status) && _x != GW_CURRENTVEHICLE) then {
			
			if ('invulnerable' in _status) exitWith {};

			[_x, "GUD"] call markAsKilledBy;	
			_d = if ('nanoarmor' in _status) then { 0.05 } else { (0.15 + (random 0.25)) };

			_x setDamage ((getDammage _x) + _d);	
			[_lastMissilePos, 10, 25] call shockwaveEffect;

			[       
				_x,
				"updateVehicleDamage",
				_x,
				false
			] call gw_fnc_mp; 

		};

		false
		
	} count _nearby > 0;

};

// Tidy up, restore effects, destroy cam
_layerStatic cutRsc ["RscStatic", "PLAIN",1];      
titlecut["","BLACK OUT",1];
Sleep 0.5;

[_vehicle, ['radar']] call removeVehicleStatus;

_layerInterlace cutText ["", "PLAIN DOWN" ,0];
camdestroy _cam;
player cameraeffect["terminate","back"];

"colorCorrections" ppEffectEnable false; 
"colorCorrections" ppEffectCommit 0; 
"radialBlur" ppEffectEnable false;
"radialBlur" ppEffectCommit 0;

showCinemaBorder true;
titlecut["","PLAIN DOWN",0];

GW_GUIDED_ACTIVE = false;

true
