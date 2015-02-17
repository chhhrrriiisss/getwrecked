//
//      Name: setVehicleOnFire
//      Desc: Attempts to set light to target vehicle (Checks for conditions not to and % chance)
//      Return: None
//

private ['_target', '_chance'];

_target = _this select 0;
_chance = if (isNil {_this select 1}) then { 15 } else { (_this select 1) }; // Chance of setting something alight default 15%
_minDuration = if (isNil {_this select 2}) then { 3 } else { (_this select 2) }; // Default minimum duration of fire

if (isNull _target) exitWith {};

_isVehicle = _target getVariable ["isVehicle", false];
_status = _target getVariable ["status", []];
_rnd = random 100;

if ( !('inferno' in _status) && !('nofire' in _status) && _isVehicle && _rnd < _chance) then {

	_statusToAdd = if ('fire' in _status) then { ['inferno'] } else { ['fire'] };

	// Fire duration
	_rnd = random 6 + _minDuration;

	if (_target != (vehicle player) ) then { [_target] call markAsKilledBy;  };

	[       
        [
            _target,
            str _statusToAdd,
            _rnd
        ],
        "addVehicleStatus",
        _target,
        false 
	] call BIS_fnc_MP;  

	[
		[
			_target,
			_rnd
		],
		"burnEffect"
	] call BIS_fnc_MP;

};