//
//      Name: burnIntersects
//      Desc: Sets on fire any vehicles between two ASL points
//      Return: None
//

private ['_source', '_destination', '_ignore'];

_source = [_this,0, [], [[]]] call BIS_fnc_param;
_destination = [_this,1, [], [[]]] call BIS_fnc_param;	
_ignore = [_this,2, objNull, [objNull]] call BIS_fnc_param;	
_chance = [_this,3, 85, [0]] call BIS_fnc_param; // Chance of setting something alight

if (count _source == 0 || count _destination == 0) exitWith {};

_objects = lineIntersectsWith [_source, _destination, _ignore, objNull, false];

if (count _objects == 0) exitWith {};

{
	_isVehicle = _x getVariable ["isVehicle", false];
	_status = _x getVariable ['status', []];
	_rnd = random 100;

	// If its not already on fire, set light to the first vehicle it hits
	if ( !('fire' in _status) && { !('nofire' in _status) } && { _isVehicle } && {_rnd > _chance} ) exitWith { 

		if (GW_DEBUG) then { systemchat format['Set %1 on fire', typeOf _x]; };
			
		// Fire duration 3 - 8
		_rnd = (random 5) + 3;
		
		// Send add status request
		[       
            [
                _x,
                ['fire'],
                _rnd
            ],
            "addVehicleStatus",
            _x,
            false 
    	] call BIS_fnc_MP;  

    	// Tag as killed by
    	if (_x != (vehicle player)) then { [_x] call markAsKilledBy; };

    	// Apply particle effect
		[
			[
			_x,
			_rnd
			],
		"burnEffect"
		] call BIS_fnc_MP;
	};

} Foreach _objects;

