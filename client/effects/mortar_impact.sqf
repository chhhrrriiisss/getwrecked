//
//      Name: mortarImpact
//      Desc: Creates a mortar explosion at the target point, delayed slightly by distance
//      Return: None
//

private ['_pos', '_ground', '_speed', '_dist', '_delay'];

params ['_p', '_speed'];

// Vary the accuracy slightly
_p = [_p, 1, 1] call setVariance;

// Distance from local vehicle
_dist = (vehicle player) distance _p;
_delay = (_dist / 200);

_ground = _p;
_ground set [2,0];

// Tag nearby players as killed by
[_ground, 4, "MOR"] call markNearby;

Sleep _delay;

_ex = createVehicle ["R_TBG32V_F",_p,[],0,"FLY"];
_ex setVectorDirAndUp [[0,0,1],[0,-1,0]];
_ex setVelocity [0,0,_speed];

[_p, 25, 10] call shockwaveEffect;

_nearby = _p nearEntities [["Car", "Tank"], 10];
if (count _nearby == 0) exitWith {};



{

	_isVehicle = _x getVariable ["isVehicle", false];
	_chance = random 100;

	if (_isVehicle && _chance > 60) then {

		[       
	        [
	            _x,
	            "['tyresPopped']",
	            4
	        ],
	        "addVehicleStatus",
	        _x,
	        false 
		] call bis_fnc_mp;  

	};

	false
} count _nearby;

