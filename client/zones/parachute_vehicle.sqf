/*

	Deploys vehicle via parachute at selected site

*/

private ['_targetVehicle', '_targetPosition'];

_unit = _this select 0;
_targetVehicle = _this select 1;
_targetPosition = _this select 2;
_ignore = [_this,3, false] call BIS_fnc_param;

if (!_ignore) then {

    _timeout = time + 5;
    waitUntil{    	
    	if ((time > _timeout) || (_unit == (driver _targetVehicle))) exitWith { true };
        false
    };

    if (time > _timeout) exitWith {
    	systemChat 'Deploy aborted';
    };

};

[       
    [
        _targetVehicle,
        ['invulnerable', 'nolock', 'nofire'],
        20
    ],
    "addVehicleStatus",
    _targetVehicle,
    false 
 ] call BIS_fnc_MP;  

// Force a hud refresh to resolve some lag issues
GW_HUD_ACTIVE = false; 

_oldPosition = _targetPosition;

_targetPosition set[0, (_targetPosition select 0) + ( (random 15) - (7.5) )];
_targetPosition set[1, (_targetPosition select 1) + ( (random 15) - (7.5) )];

_targetVehicle setPosATL _targetPosition;
_targetVehicle setDir (random 360);
_targetVehicle setVariable ["newSpawn", true];

_targetVelocity = [(((random 3) -1.5)* -1), (((random 3) -1.5)* -1),-10];

if (!local _targetVehicle) then {

    [       
        [
            _targetVehicle,
            _targetVelocity
        ],
        "setVelocityLocal",
        _targetVehicle,
        false 
    ] call BIS_fnc_MP;  
  
} else {
    _targetVehicle setVelocity _targetVelocity;    
};

_paraAltitude = (random 10) + 30;

_timeout = time + 5;
waitUntil { ( (getPos _targetVehicle select 2 < _paraAltitude) || (time > _timeout) ) };

_currentPosition = _targetVehicle modelToWorldVisual (boundingCenter _targetVehicle);

// Create Parachute
_class = "I_parachute_02_F";

_para = createVehicle [_class, [0,0,0], [], 0, "FLY"];
_para setVelocity (velocity _targetVehicle);
_para setDir getDir _targetVehicle;
_para setPos _currentPosition;
_paras =  [_para];

playSound3D ["a3\sounds_f\sfx\vehicle_drag_end.wss", _targetVehicle, false, _currentPosition, 2, 1, 40]; 
playSound3D ["a3\sounds_f\weapons\smokeshell\smoke_1.wss", _targetVehicle, false, _currentPosition, 2, 1, 40]; 

_height = ([_targetVehicle] call getBoundingBox) select 2;
_para disableCollisionWith _targetVehicle;
_targetVehicle attachTo [_para, [0,0,-(_height / 2)]];

{
	_p = createVehicle [_class, [0,0,0], [], 0, "FLY"];
	_paras set [count _paras, _p];
    _p disableCollisionWith _para;
	_p attachTo [_para, [0,0,0]];
	_p setVectorUp _x;
} count [
	[0.5,0.4,0.6],[-0.5,0.4,0.6],[0.5,-0.4,0.6],[-0.5,-0.4,0.6]
];	

_targetVehicle setVectorUp [0,0,1];

// Cleanup
 _timeout = time + 10; 
0 = [_targetVehicle, _paras, _timeout] spawn {

        _veh = _this select 0;
       
        waitUntil { ( (getPos _veh select 2 < 5) || (isEngineOn _veh) || time > (_this select 2)) };

        _veh setDammage 0;
        { _x setDammage 0; } count (crew _veh) > 0;            

        playSound3D ["a3\sounds_f\weapons\Flare_Gun\flaregun_1_shoot.wss", _veh, false, getPosASL _veh, 1, 1, 40];             
        _vel = velocity _veh;
        detach _veh;
        _veh setVelocity _vel;
       
        {
            detach _x;
            _x disableCollisionWith _veh;   
        } count (_this select 1);

        _timeout = time + 5;
        waitUntil { time > _timeout };

        {
            if (!isNull _x) then {deleteVehicle _x};

        } count (_this select 1);

        // Wait 10 second before removing new spawn tag
        Sleep 5;
        _veh setVariable ["newSpawn", nil];

        [       
            [
                _veh,
                ['invulnerable', 'nolock', 'nofire']
            ],
            "removeVehicleStatus",
            _veh,
            false 
        ] call BIS_fnc_MP;  
 };

