//
//      Name: setVehicleOnFire
//      Desc: Attempts to set light to target vehicle (Checks for conditions not to and % chance)
//      Return: None
//

private ['_target', '_chance'];

_target = [_this, 0, objNull, [objNull]] call filterParam;
_chance = [_this, 1, 15, [0]] call filterParam; // Chance of setting something alight default 15%  
_minDuration = [_this, 2, 3, [0]] call filterParam; // Default minimum duration of fire

if (isNull _target) exitWith {};

_rnd = random 100;
if (_rnd > _chance) exitWith { false };

_isVehicle = _target getVariable ["isVehicle", false];
if (!_isVehicle) exitWith { false };

_status = _target getVariable ["status", []];
if ( 'inferno' in _status || 'nofire' in _status) exitWith { false };

_statusToAdd = if ('fire' in _status) then { ['inferno'] } else { ['fire'] };

// Fire duration
_rnd = random 6 + _minDuration;

// if (_target != (vehicle player) ) then { [_target] call markAsKilledBy;  };

[       
    [
        _target,
        str _statusToAdd,
        _rnd
    ],
    "addVehicleStatus",
    _target,
    false 
] call bis_fnc_mp;  

[
	[
		_target,
		_rnd
	],
	"burnEffect"
] call bis_fnc_mp;

