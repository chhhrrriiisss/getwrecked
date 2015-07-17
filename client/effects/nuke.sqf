//
//      Name: nukeEffect
//      Desc: Creates a nuclear explosion that damages and pushes vehicles in the area
//		Original author: Moerderhoschi, modified by Sli for Get Wrecked//		
//      Return: None
//

_crate = (_this select 0);
_vehicle = (vehicle player);

// Disable VEhicle
[_vehicle, ['emp', 'nuke'], 15] call addVehicleStatus;
profileNamespace setVariable ['killedByNuke', (ASLtoATL visiblePositionASL _crate)];
saveProfileNamespace;

_fuel = fuel _vehicle;
[_fuel, _vehicle] spawn {
	(_this select 1) setFuel 0;
	Sleep 15;
	(_this select 1) setFuel (_this select 0);	
};

Sleep 0.25;

// Calculate velocity hit
_dist = _vehicle distance _crate;

// Calculate damage caused
_dmg = _dist call {	
	if (_this < 200) exitWith { 1 };
	if (_this < 400) exitWith { (0.75 + random 0.25) };
	if (_this < 600) exitWith { (0.5 + random 0.5) };
	if (_this < 1000) exitWith { (0.25 + random 0.5) };
	if (_this >= 1000) exitWith { (0.15 + random 0.5) };
};

_status = _vehicle getVariable ['status', []];
if (!("invulnerable" in _status)) then {
	_vehicle setDamage ((getDammage _vehicle) + _dmg);
};


playSound "nuke";

// Create particle effects
_Cone = "#particlesource" createVehicleLocal getpos _crate;
_Cone setParticleParams [["A3\Data_F\ParticleEffects\Universal\universal.p3d", 16, 7, 48], "", "Billboard", 1, 10, [0, 0, 0],
				[0, 0, 0], 0, 1.275, 1, 0, [40,80], [[0.25, 0.25, 0.25, 0], [0.25, 0.25, 0.25, 0.5], 
				[0.25, 0.25, 0.25, 0.5], [0.25, 0.25, 0.25, 0.05], [0.25, 0.25, 0.25, 0]], [0.25], 0.1, 1, "", "", _crate];
_Cone setParticleRandom [2, [1, 1, 30], [1, 1, 30], 0, 0, [0, 0, 0, 0.1], 0, 0];
_Cone setParticleCircle [10, [-10, -10, 20]];
_Cone setDropInterval 0.005;

_top = "#particlesource" createVehicleLocal getpos _crate;
_top setParticleParams [["A3\Data_F\ParticleEffects\Universal\universal.p3d", 16, 3, 48, 0], "", "Billboard", 1, 20, [0, 0, 0],
				[0, 0, 60], 0, 1.7, 1, 0, [60,80,100], [[1, 1, 1, -10],[1, 1, 1, -7],[1, 1, 1, -4],[1, 1, 1, -0.5],[1, 1, 1, 0]], [0.05], 1, 1, "", "", _crate];
_top setParticleRandom [0, [75, 75, 15], [17, 17, 10], 0, 0, [0, 0, 0, 0], 0, 0, 360];
_top setDropInterval 0.002;

_top2 = "#particlesource" createVehicleLocal getpos _crate;
_top2 setParticleParams [["A3\Data_F\ParticleEffects\Universal\universal.p3d", 16, 3, 112, 0], "", "Billboard", 1, 20, [0, 0, 0],
				[0, 0, 60], 0, 1.7, 1, 0, [60,80,100], [[1, 1, 1, 0.5],[1, 1, 1, 0]], [0.07], 1, 1, "", "", _crate];
_top2 setParticleRandom [0, [75, 75, 15], [17, 17, 10], 0, 0, [0, 0, 0, 0], 0, 0, 360];
_top2 setDropInterval 0.002;

_smoke = "#particlesource" createVehicleLocal getpos _crate;
_smoke setParticleParams [["A3\Data_F\ParticleEffects\Universal\universal.p3d", 16, 7, 48, 1], "", "Billboard", 1, 25, [0, 0, 0],
				[0, 0, 60], 0, 1.7, 1, 0, [40,15,120], 
				[[1, 1, 1, 0.4],[1, 1, 1, 0.7],[1, 1, 1, 0.7],[1, 1, 1, 0.7],[1, 1, 1, 0.7],[1, 1, 1, 0.7],[1, 1, 1, 0.7],[1, 1, 1, 0]]
				, [0.5, 0.1], 1, 1, "", "", _crate];
_smoke setParticleRandom [0, [10, 10, 15], [15, 15, 7], 0, 0, [0, 0, 0, 0], 0, 0, 360];
_smoke setDropInterval 0.002;

_Wave = "#particlesource" createVehicleLocal getpos _crate;
_Wave setParticleParams [["A3\Data_F\ParticleEffects\Universal\universal.p3d", 16, 7, 48], "", "Billboard", 1, 20, [0, 0, 0],
				[0, 0, 0], 0, 1.5, 1, 0, [50, 100], [[0.1, 0.1, 0.1, 0.5], 
				[0.5, 0.5, 0.5, 0.5], [1, 1, 1, 0.3], [1, 1, 1, 0]], [1,0.5], 0.1, 1, "", "", _crate];
_Wave setParticleRandom [2, [20, 20, 20], [5, 5, 0], 0, 0, [0, 0, 0, 0.1], 0, 0];
_Wave setParticleCircle [50, [-80, -80, 2.5]];
_Wave setDropInterval 0.0002;


_light = "#lightpoint" createVehicleLocal [((getpos _crate select 0)),(getpos _crate select 1),((getpos _crate select 2)+500)];
_light setLightAmbient[1500, 1200, 1000];
_light setLightColor[1500, 1200, 1000];
_light setLightBrightness 100000.0;


// Color Correction

// "colorCorrections" ppEffectAdjust [2, 30, 0, [0.0, 0.0, 0.0, 0.0], [0.8*2, 0.5*2, 0.0, 0.7], [0.9, 0.9, 0.9, 0.0]];
// "colorCorrections" ppEffectCommit 0;
// "colorCorrections" ppEffectAdjust [1, 0.8, -0.001, [0.0, 0.0, 0.0, 0.0], [0.8*2, 0.5*2, 0.0, 0.7], [0.9, 0.9, 0.9, 0.0]];  
// "colorCorrections" ppEffectCommit 3;
// "colorCorrections" ppEffectEnable true;
"filmGrain" ppEffectEnable true; 
"filmGrain" ppEffectAdjust [0.02, 1, 1, 0.1, 1, false];
"filmGrain" ppEffectCommit 5;

// Flash Effect

"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [1];
"dynamicBlur" ppEffectCommit 1;

// "colorCorrections" ppEffectEnable true;
// "colorCorrections" ppEffectAdjust [0.8, 15, 0, [0.5, 0.5, 0.5, 0], [0.0, 0.0, 0.6, 2],[0.3, 0.3, 0.3, 0.1]];"colorCorrections" ppEffectCommit 0.4;
 
"dynamicBlur" ppEffectAdjust [0.5];
"dynamicBlur" ppEffectCommit 3;

sleep 0.1;

_xHandle = [] spawn
{
	Sleep 1;
	"colorCorrections" ppEffectAdjust [1.0, 0.5, 0, [0.5, 0.5, 0.5, 0], [1.0, 1.0, 0.8, 0.4],[0.3, 0.3, 0.3, 0.1]];
	"colorCorrections" ppEffectCommit 2;
};


"dynamicBlur" ppEffectAdjust [2];
"dynamicBlur" ppEffectCommit 1;

"dynamicBlur" ppEffectAdjust [0.5];
"dynamicBlur" ppEffectCommit 4;

_light setLightBrightness 1000.0;

sleep 1.5;

"colorCorrections" ppEffectAdjust [1, 1, 0, [0.5, 0.5, 0.5, 0], [1.0, 1.0, 0.8, 0.4],[0.3, 0.3, 0.3, 0.1]];"colorCorrections" ppEffectCommit 1; "colorCorrections" ppEffectEnable TRUE;
"dynamicBlur" ppEffectAdjust [0];
"dynamicBlur" ppEffectCommit 1;

_minPower = 80;
_maxPower = 80;
_power = random (_maxPower - _minPower) + _minPower;

_minRange = 600;
_maxRange = 600;
_range = random (_maxRange - _minRange) + _minRange;

if (_dist > _range) then {

	[_vehicle, _crate] spawn {

		params ['_v', '_t'];
		_d = (_v distance _t);

		for "_i" from 0 to (15*(_d / 100)) do {

			addCamShake [1, 0.1, 100];

			_vx = vectorup _v select 0;
			_vy = vectorup _v select 1;
			_vz = vectorup _v select 2;
			_coef = 0.01 - (0.0001 * _i);
			_v setvectorup [
				_vx+(-_coef+random (2*_coef)),
				_vy+(-_coef+random (2*_coef)),
				_vz+(-_coef+random (2*_coef))
			];

			sleep (0.01 + random 0.01);

		};

		[_v, 0, 0] call BIS_fnc_setPitchBank;

		// Get the angle we're getting thrown too
		_dir = [_t, _v] call dirTo;

		_vel = velocity _v;
		_speed = 5;

		for "_i" from 0 to 60 do {

			_v setVelocity [(_vel select 0)+(sin _dir*_speed),(_vel select 1)+(cos _dir*_speed),(_vel select 2) + 0.1];	
			Sleep (0.02 + random 0.01);

		};
		
	};

} else {

	if (_dist < 25) then { _dist = 25; };

	// Get the angle we're getting thrown too
	_dir = [_crate,_vehicle] call dirTo;
	_relPos = [_vehicle, _dist, _dir] call relPos;

	// Use vehicle pos to calculate velocity vector
	_vehPos = getPosATL _vehicle;
	_heading = [_vehPos,_relPos] call BIS_fnc_vectorFromXToY;		

	// Calculate power
	_calcPower = ((_power / (1000 * 0.001)) max 10) + (_dist / 5);
	_vel = [_heading, _calcPower] call BIS_fnc_vectorMultiply; 

	_vehicle setVelocity _vel;

	// Set vehicle on fire
	[_vehicle, 95, 7] spawn setVehicleOnFire;

};

// Ash effect
_vehicle spawn {

	Sleep 10;
	_ash = "#particlesource" createVehicleLocal (getpos _this);  
	_ash setParticleParams  [ ["A3\Data_F\ParticleEffects\Universal\Universal", 16, 12, 8, 1],"","Billboard",1,4,[0,0,0],[0,0,0],1,0.000001,0,1.4,[0.05,0.05],[[0.1,0.1,0.1,1]],[0,1],0.2,1.2,"","",_this];
	_ash setParticleRandom [0, [10, 10, 7], [0, 0, 0], 0, 0.01, [0, 0, 0, 0.1], 0, 0];
	_ash setParticleCircle [0.0, [0, 0, 0]];
	_ash setDropInterval 0.005;
	Sleep 10;
	deleteVehicle _ash;
};


_Wave setDropInterval 0.001;
deletevehicle _top;
deletevehicle _top2;

sleep 1.5;

_i = 0;
while {_i < 100} do
{
	_light setLightBrightness 100.0 - _i;
	_i = _i + 1;
	sleep 0.1;
};
deleteVehicle _light;

sleep 0.5;

_smoke setParticleParams [["A3\Data_F\ParticleEffects\Universal\universal.p3d", 16, 7, 48, 1], "", "Billboard", 1, 25, [0, 0, 0],
				[0, 0, 45], 0, 1.7, 1, 0, [40,25,80], 
				[[1, 1, 1, 0.2],[1, 1, 1, 0.3],[1, 1, 1, 0.3],[1, 1, 1, 0.3],[1, 1, 1, 0.3],[1, 1, 1, 0.3],[1, 1, 1, 0.3],[1, 1, 1, 0]]
				, [0.5, 0.1], 1, 1, "", "", _crate];

_Cone setDropInterval 0.01;
_smoke setDropInterval 0.006;
_Wave setDropInterval 0.001;

sleep 0.5;

_smoke setParticleParams [["A3\Data_F\ParticleEffects\Universal\universal.p3d", 16, 7, 48, 1], "", "Billboard", 1, 25, [0, 0, 0],
				[0, 0, 30], 0, 1.7, 1, 0, [40,25,80], 
				[[1, 1, 1, 0.2],[1, 1, 1, 0.3],[1, 1, 1, 0.3],[1, 1, 1, 0.3],[1, 1, 1, 0.3],[1, 1, 1, 0.3],[1, 1, 1, 0.3],[1, 1, 1, 0]]
				, [0.5, 0.1], 1, 1, "", "", _crate];
_smoke setDropInterval 0.012;
_Cone setDropInterval 0.02;
_Wave setDropInterval 0.01;

sleep 3;

deleteVehicle _Wave;
deleteVehicle _cone;
deleteVehicle _smoke;

