//
//      Name: mortarImpact
//      Desc: Creates a mortar explosion at the target point, delayed slightly by distance
//      Return: None
//

private ['_pos', '_ground', '_speed', '_dist', '_delay'];

_p = _this select 0;
_speed = _this select 1;

// Vary the accuracy slightly
_p = [_p, 1.5, 1.5] call setVariance;

// Distance from local vehicle
_dist = (vehicle player) distance _p;
_delay = (_dist / 200);

_ground = _p;
_ground set [2,0];

// Tag nearby players as killed by
[_ground, 4] call markNearby;

Sleep _delay;

_ex = createVehicle ["R_TBG32V_F",_p,[],0,"FLY"];
_ex setVectorDirAndUp [[0,0,1],[0,-1,0]];
_ex setVelocity [0,0,_speed];

