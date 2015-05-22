//
//      Name: vehicleForks
//      Desc: Impale and attach hostile vehicles to the spikes
//      Return: None
//

private ["_targets", "_vehicle"];

_vehicle = _this select 0;
_target = _this select 1;
_power = _this select 4;

// Need a little bit of power to attempt attach
if (_power <= 10) exitWith {};

// Maximum 10 second fork effect, min 2
_power = ([_power, 20, 100] call limitToRange) / 10; 

{
	if ("Land_PalletTrolley_01_khaki_F" isEqualTo (typeOf _x)) then {

		_forkObject = _x;
		_objs = lineIntersectsWith [ATLtoASL (_x modelToWorldVisual [0,0,-0.5]),ATLtoASL (_x modelToWorldVisual [3,0,-0.5]), GW_CURRENTVEHICLE, _forkObject];
		[_x modelToWorldVisual [0,0,-0.5],_x modelToWorldVisual [3,0,-0.5], 0.1] spawn debugLine;
		if (count _objs == 0) exitWith {};

		{
			if (_x == _target) exitWith {

				_status = _x getVariable ['status', []];
				if ('invulnerable' in _status || 'cloak' in _status || 'forked' in _status || 'nofork' in _status) exitWith {};

				[       
				    [
				        _target,
				        _vehicle,
				        _power
				    ],
				    "forkEffect",
				    _target,
				    false 
				] call gw_fnc_mp; 

			};
			false
		} count _objs;	
	};	
	false
} count (attachedObjects _vehicle) > 0;
