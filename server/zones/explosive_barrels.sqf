if (!isServer) exitWith {};

explosiveBarrelLocations = ['explosiveBarrels'] call findAllMarkers;

barrelExplosion = compileFinal '
        _ex = createVehicle [
            "R_TBG32V_F",
            _this modeltoworld [0,0,0],
            [],
            0,
            "CAN_COLLIDE"
        ];
        _ex setVectorDirAndUp [[0,0,1],[0,-1,0]];
        _ex setVelocity [0,0,-1000];
        deleteVehicle _this;
';

createBarrels = {
    
    _rnd = round ((random 5) + 3);
    
    _bars = [];

    for "_i" from 0 to _rnd step 1 do {
    
        _b = createVehicle [
            "Land_MetalBarrel_F",
            [0,0,0],
            [],
            0,
            "NONE"
        ];

        _b setDir (_this select 0);
        _p = (_this select 1);
        _p set [0, (_p select 0) + (random 1.5)];
        _p set [1, (_p select 1) + (random 1.5)];
        _b setPosASL _p;
        _b setDamage 0.99;
        _b allowDamage false;
        _b addEventHandler ["Hit", {
            _b = _this select 0;
            if (alive _b) then {_b setDamage 0.99};
        }];
        _bars set [_i, _b];

    };

    sleep 1;

    {
        _x setVariable ["#PosASL", getPosASL _x];
        _x addEventHandler ["EpeContact", {
            _b = _x;
            if (
                (getPosASL _b) distance (_b getVariable "#PosASL") > 0.1
            ) then {_b call barrelExplosion};
        }];
        _x addEventHandler ["Killed", {_this select 0 call barrelExplosion}];
        _x allowDamage true;
        false
    } count _bars;

};

spawnExplosiveBarrels = {

    {    
        _pos = (ATLtoASL _x);
        [(random 360), _pos] spawn createBarrels;
    } ForEach explosiveBarrelLocations;

};