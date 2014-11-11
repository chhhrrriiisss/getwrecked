//
//      Name: dropExplosives
//      Desc: Drops a bag of explosives that can be remotely detonated
//      Return: None
//

private ["_obj", "_vehicle", "_o"];

_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_vehicle = [_this,1, objNull, [objNull]] call BIS_fnc_param;

[] spawn cleanDeployList;

playSound3D ["a3\sounds_f\sfx\vehicle_drag_end.wss",_vehicle, false, getPosATL _vehicle, 2, 1, 50];

_type = typeOf _obj;
detach _obj;
deleteVehicle _obj;

// Ok, let's position it behind the vehicle
_maxLength = ([_vehicle] call getBoundingBox) select 1;
_pos = _vehicle modelToWorldVisual [0, (-1 * ((_maxLength/2) + 2)), 0];
_pos set[2,0];

// Spawn it
_obj = nil;
_obj = createVehicle [_type, _pos, [], 0, 'CAN_COLLIDE']; // So it doesnt collide when spawned in]
_obj disableCollisionWith _vehicle;
_obj allowDamage false;
_obj enableSimulation false;

[		
	[
		_obj,
		false
	],
	"setObjectSimulation",
	false,
	false 
] call BIS_fnc_MP;

_releaseTime = time;
_timer = 60;
_timeout = time + _timer;

Sleep 0.25;

// Handlers to trigger effect early
_obj addEventHandler['HandleDamage', {	(_this select 0) setVariable ["triggered", true]; }];
_obj addEventHandler['killed', {	(_this select 0) setVariable ["triggered", true]; }];
_obj addEventHandler['Explosion', {	(_this select 0) setVariable ["triggered", true]; }];
_obj addEventHandler['Hit', { (_this select 0) setVariable ["triggered", true]; }];

// Add to targets array
_existingTargets = _vehicle getVariable ["GW_detonateTargets", []];
_newTargets = _existingTargets + [_obj];
_vehicle setVariable ["GW_detonateTargets", _newTargets];

GW_WARNINGICON_ARRAY = GW_WARNINGICON_ARRAY + [_obj];
GW_DEPLOYLIST = GW_DEPLOYLIST + [_obj];

// Recompile the vehicle to account for dropping one bag
[_vehicle] call compileAttached;

_triggered = false;
while {alive _obj && time < _timeout && !_triggered} do {
	_triggered = _obj getVariable ["triggered", false];
	playSound3D ["a3\sounds_f\sfx\beep_target.wss", _obj, false, getPos _obj, 2, 1, 25]; 
	Sleep 0.5;
};

// If the object is still alive, let's go boom
if (alive _obj) then {

	_pos = (ASLtoATL visiblePositionASL _obj);

	playSound3D ["a3\sounds_f\weapons\mines\electron_trigger_1.wss", _obj, false, _pos, 2, 1, 150]; 
	
	_pos set [2,2];
	_bomb = createVehicle ["Bo_GBU12_LGB", _pos, [], 0, "CAN_COLLIDE"];
	_bomb setVelocity [0,0,-100];

	_nearby = _pos nearEntities [["Car"], 14];	

	if (count _nearby > 0) then {
		// To be extra badass, lets spawn a bomb for each vehicle nearby
		{
			if (_x != (_vehicle)) then { [_x] call markAsKilledBy; };

			_tPos =  (ASLtoATL getPosASL _x);
			_tPos set [2, 2];			
			_bomb = createVehicle ["Bo_GBU12_LGB", _tPos, [], 0, "CAN_COLLIDE"];
			_bomb setVelocity [0,0,-100];	
			_x call destroyInstantly;		

			false
			
		} count _nearby > 0;
	};

	deleteVehicle _obj;
};

// Cleanup
_obj removeAllEventHandlers "Hit";
_obj removeAllEventHandlers "Explosion";
_obj removeAllEventHandlers "HandleDamage";

_detonateTargets = _vehicle getVariable ["GW_detonateTargets", []];
_newTargets = _detonateTargets - [_obj];
_vehicle setVariable ["GW_detonateTargets", _newTargets];

GW_WARNINGICON_ARRAY = GW_WARNINGICON_ARRAY - [_obj];
GW_DEPLOYLIST = GW_DEPLOYLIST - [_obj];

