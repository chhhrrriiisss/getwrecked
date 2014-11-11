//
//      Name: damageIntersects
//      Desc: Instantly  damages valid vehicles between source and destination points
//      Return: None
//

private ['_source', '_destination', '_ignore'];

_source =  [_this,0, [], [[]]] call BIS_fnc_param;
_destination = [_this,1, [], [[]]] call BIS_fnc_param;	
_ignore = [_this,2, objNull, [objNull]] call BIS_fnc_param;
_modifier = [_this,3, 1, [0]] call BIS_fnc_param;

if (count _source == 0 || count _destination == 0) exitWith {};

_objects = lineIntersectsWith [_source, _destination, _ignore, objNull, false];

if (count _objects == 0) exitWith {};

{
	_isVehicle = _x getVariable ["isVehicle", false];
	_status = _x getVariable ['status', []];

	// If its not invulnerable, damage it
	if ( !('invulnerable' in _status) && _isVehicle && _x != (vehicle player)) then {
		if (_x != (vehicle player)) then { [_x] call markAsKilledBy; };

		_dmg = getDammage _x;

		// Apply the damage, or destroy if we're going to KO it
		if ( (_dmg + _modifier) > 1) then {		
			_x call destroyInstantly;
		} else {
			_x setDammage (_dmg + _modifier);
		};
	};

	false

} count _objects > 0;