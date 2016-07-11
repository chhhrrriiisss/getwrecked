//
//      Name: shredTyres
//      Desc: Shreds tyres on vehicle
//      Return: None
//

_target = [_this,0, objNull, [objNull]] call filterParam;

if (isNull _target) exitWith { false };
if (!alive _target) exitWith { false };

_status = _target getVariable ['status', []];
_rnd = random 100;

// If its a vehicle and its tyres arent already popped
if ( !('tyresPopped' in _status) && !('invTyres' in _status) ) exitWith { 

	_rnd = (random 15) + 15;

	// Send add status request
	[       
        [
            _target,
            "['tyresPopped']",
            _rnd
        ],
        "addVehicleStatus",
        _target,
        false 
	] call bis_fnc_mp;  

    // Play tyre burst sound
    [       
        [
            _target,
            'tyreBurst',
            40
        ],
        "playSoundAll",
        true,
        false
    ] call bis_fnc_mp;   

	// Tag as killed by
	[_target] call markAsKilledBy;

    true

};

true