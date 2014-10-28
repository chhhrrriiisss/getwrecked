//
//      Name: destroyIntersects
//      Desc: Instantly destroys valid vehicles between source and destination points
//      Return: None
//

private ['_source', '_destination', '_ignore'];

_source =  [_this,0, [], [[]]] call BIS_fnc_param;
_destination = [_this,1, [], [[]]] call BIS_fnc_param;	
_ignore = [_this,2, objNull, [objNull]] call BIS_fnc_param;

if (count _source == 0 || count _destination == 0) exitWith {};

_objects = lineIntersectsWith [_source, _destination, _ignore, objNull, false];

if (count _objects == 0) exitWith {};

{
	_isVehicle = _x getVariable ["isVehicle", false];
	_status = _x getVariable ['status', []];

	// If its not invulnerable, destroy it
	if ( !('invulnerable' in _status) && _isVehicle) then {
		[_x] call markAsKilledBy;
		_x setDammage 1;
	};

	false

} count _objects > 0;