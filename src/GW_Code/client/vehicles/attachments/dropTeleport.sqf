//
//      Name: dropTeleport
//      Desc: Drops a teleport pad
//      Return: None
//

private ["_obj", "_vehicle", "_o"];

if (isNull ( _this select 0) || isNull (_this select 1)) exitWith { false };

[] spawn cleanDeployList;

params ['_obj', '_vehicle'];

// Ok, let's position it behind the vehicle
_maxLength = ([_vehicle] call getBoundingBox) select 1;
_pos = _vehicle modelToWorldVisual [0, (-1 * ((_maxLength/2) + 2)), 0];
_pos set [2, 0];

playSound3D ["a3\sounds_f\sfx\missions\vehicle_drag_end.wss",_vehicle, false, visiblePositionASL _vehicle, 10, 1, 50];
deleteVehicle _obj;

_obj = createVehicle ["containmentArea_02_forest_F", _pos, [], 0, 'CAN_COLLIDE']; // So it doesnt collide when spawned in]
_obj setVectorUp (surfaceNormal _pos);
_obj setDir (random 360);

_obj disableCollisionWith _vehicle;
_obj enableSimulation false;
	
// Disable simulation
[		
	[
		_obj,
		false
	],
	"setObjectSimulation",
	false,
	false 
] call bis_fnc_mp;

_obj disableCollisionWith _vehicle;

// Recompile the vehicle to account for dropping one bag
[_this select 2] call compileAttached;

// Refresh hud bars
GW_HUD_REFRESH = true;

_releaseTime = time;
_timer = 300;
_timeout = time + _timer;

// Handlers to trigger effect early
_obj addEventHandler['HandleDamage', { (_this select 0) setDammage 1; false }];
_obj addEventHandler['Explosion', {	(_this select 0) setDammage 1; false }];

// Add to targets array
_existingTargets = _vehicle getVariable ["GW_teleportTargets", []];
_newTargets = _existingTargets + [_obj];
_vehicle setVariable ["GW_teleportTargets", _newTargets];

GW_WARNINGICON_ARRAY = GW_WARNINGICON_ARRAY + [_obj];
GW_DEPLOYLIST = GW_DEPLOYLIST + [_obj];

[_obj, _timeout, _vehicle] spawn {

	params ['_o', '_t', '_v'];

	Sleep 3;

	waitUntil {	
	
		_nearby = (ASLtoATL visiblePositionASL _o) nearEntities [["Car", "Tank"], 5];

		{
			_isVehicle = _x getVariable ['isVehicle', false];
			_status = _x getVariable ['status', []];
			if (alive _x && _isVehicle && (_x != GW_CURRENTVEHICLE) && { !('teleport' in _status) } ) exitWith {	

				playSound3D ["a3\sounds_f\sfx\beep_target.wss", _o, false, (ASLtoATL visiblePositionASL _o), 10, 1, 50];

				[_x, 'TPD'] call markAsKilledBy;
				
				[
					[
						_x, 
						"['teleport']",
						3
					],
					'addVehicleStatus',
					_x,
					false
				] call bis_fnc_mp;

				false
			};
			false
		} count _nearby;		

		Sleep 0.75;

		(!alive _o || time >= _t)
	};	

	// Cleanup
	_o removeAllEventHandlers "Explosion";
	_o removeAllEventHandlers "HandleDamage";

	_teleportTargets = _v getVariable ["GW_teleportTargets", []];
	_newTargets = _teleportTargets - [_o];
	_v setVariable ["GW_teleportTargets", _newTargets];	

	GW_WARNINGICON_ARRAY = GW_WARNINGICON_ARRAY - [_o];
	GW_DEPLOYLIST = GW_DEPLOYLIST - [_o];

	deleteVehicle _o;

};

true