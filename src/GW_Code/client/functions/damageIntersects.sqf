//
//      Name: damageIntersects
//      Desc: Instantly  damages valid vehicles between source and destination points
//      Return: None
//

private ['_source', '_destination', '_ignore'];

_source = [_this, 0, [0,0,0], [[]]] call filterParam;
_destination = [_this, 1, [0,0,0], [[]]] call filterParam;
_ignore = [_this, 2, objNull, [objNull]] call filterParam;
_modifier = [_this, 3, 1, [0]] call filterParam;
_tag = [_this, 4, "", [""]] call filterParam;

if (_source isEqualTo [0,0,0] || _destination isEqualTo [0,0,0]) exitWith {};

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

		_armor = _x getVariable ['GW_Armor', 1];
		_modifier = [(_modifier / (_armor / 4)), 0, _modifier] call limitToRange;	

		// Apply the damage, or destroy if we're going to KO it
		if ( (_dmg + _modifier) > 1) then {		
			_x call destroyInstantly;
		} else {
			_x setDamage ((getDammage _x) + (_dmg + _modifier));

			[
				_x,
				"updateVehicleDamage",
				_x,
				false
			] call bis_fnc_mp;

		};
	};

	false

} count _objects > 0;