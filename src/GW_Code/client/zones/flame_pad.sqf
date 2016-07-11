//
//      Name: flamePad
//      Desc: Makes a wee bbq for any vehicles in range of the pad
//      Return: None
//

params ["_pad"];

if (isNull _pad) exitWith {};

_lastTrigger = _pad getVariable ['GW_LastTrigger', (time - 15)];
if (time - _lastTrigger < 15) exitWith {};
_pad setVariable ['GW_LastTrigger', time];

_pad spawn {
	
	_duration = 5;
	_pos = (ASLtoATL visiblePositionASL _this);
	[_this, 0.5, 0.35] spawn magnetEffect;

	_bomb = createVehicle ["R_TBG32V_F", _pos, [], 0, "FLY"];		
	_bomb setVelocity [0,0,-10];
	[_pos, 40, 15] call shockwaveEffect;	

	// Trigger particle effect remotely
	[
		[
			_this,
			_duration
		],
		"infernoEffect",
		true,
		false
	] call bis_fnc_mp;

	// Flamethrower sound effect
	[		
		[
			_this,
			"flamethrower",
			50
		],
		"playSoundAll",
		true,
		false
	] call bis_fnc_mp;	

	// Local damage repeat-trigger
	_this spawn {

		_timeout = time + 5;
		waitUntil {

			_nearby = (ASLtoATL visiblePositionASL _this) nearEntities[["Car", "Tank"], 8];
			{ 				
				_null = [_x, 100, 6] call setVehicleOnFire;

				_x setDammage ((getdammage _x) + (random 0.25));
				[       
					_x,
					"updateVehicleDamage",
					_x,
					false
				] call bis_fnc_mp; 

				false
			} count _nearby > 0;

			Sleep 0.1;

			(time > _timeout)
		};

	};

};

