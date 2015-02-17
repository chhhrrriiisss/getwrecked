//
//      Name: popIntersects
//      Desc: Shreds tyres on any vehicles caught between the two points
//      Return: None
//

_source = [_this,0, [], [[]]] call BIS_fnc_param;
_destination = [_this,1, [], [[]]] call BIS_fnc_param;	

if (count _source == 0 || count _destination == 0) exitWith {};

_objects = lineIntersectsWith [_source, _destination, objNull, objNull, false];

if (count _objects == 0) exitWith {};

{
	_isVehicle = _x getVariable ["isVehicle", false];
	_status = _x getVariable ['status', []];
	_rnd = random 100;

	// If its a vehicle and its tyres arent already popped
	if ( _isVehicle && { !('tyresPopped' in _status) } &&  { !('invTyres' in _status) }) exitWith { 

		_rnd = (random 15) + 15;

		// Send add status request
		[       
            [
                _x,
                "['tyresPopped']",
                _rnd
            ],
            "addVehicleStatus",
            _x,
            false 
    	] call BIS_fnc_MP;  

        // Play tyre burst sound
        [       
            [
                _x,
                'tyreBurst',
                40
            ],
            "playSoundAll",
            true,
            false
        ] call BIS_fnc_MP;   

    	// Tag as killed by
    	[_x] call markAsKilledBy;

	};

    false

} count _objects > 0;
