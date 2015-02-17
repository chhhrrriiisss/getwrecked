//
//      Name: damageIntersects
//      Desc: Instantly  damages valid vehicles between source and destination points
//      Return: None
//

private ['_source', '_destination', '_ignore'];

_source = _this select 0;
_destination = _this select 1;
_ignore = if (isNil { _this select 2 }) then { objNull } else { (_this select 2) };
_modifier = if (isNil { _this select 3 }) then { 1 } else { (_this select 3) };
_tag = if (isNil { _this select 4 }) then { "" } else { (_this select 4) };


if (count _source == 0 || count _destination == 0) exitWith {};

_objects = lineIntersectsWith [_source, _destination, _ignore, objNull, false];

if (count _objects == 0) exitWith {};

{
	_isVehicle = _x getVariable ["isVehicle", false];
	_status = _x getVariable ['status', []];

	// If its not invulnerable, damage it
	if ( !('invulnerable' in _status) && _isVehicle && _x != (vehicle player)) then {
		if (_x != (vehicle player) && count toArray _tag > 0) then { [_x, _tag] call markAsKilledBy; };

		_dmg = getDammage _x;

		_modifier = if ("nanoarmor" in _status) then { 0.01 } else { _modifier };

		// Apply the damage, or destroy if we're going to KO it
		if ( (_dmg + _modifier) > 1) then {		
			_x call destroyInstantly;
		} else {
			_x setDamage ((getDammage _x) + (_dmg + _modifier));
			_x call updateVehicleDamage;
		};
	};

	false

} count _objects > 0;