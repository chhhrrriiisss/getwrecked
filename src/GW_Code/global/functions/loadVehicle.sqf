//
//      Name: loadVehicle
//      Desc:  Generate a vehicle on server using raw data
//      Return: None
//

private['_class', '_name', '_camo', '_source', '_o', '_k', '_raw'];
params ['_player', '_target', '_raw'];

_ai = [_this, 3, false, [false]] call filterParam;

if ( (isNull _player && !_ai) || (count _target == 0) || (count _raw == 0)) exitWith {};

diag_log format['%1 request to load %2 [ %3 ]', name _player, _target, (count _raw)];

_source = if (!_ai) then { (owner _player) } else { nil };

// Check the packet size is within tolerance
if (count _raw > GW_MAX_DATA_SIZE) exitWith {
    systemChat = 'Vehicle is too large to load.';
    false
};

// Check the current target isn't the same as the previous, if so clear the pad first
_waitUntilClear = false;

if (isNil "GW_LASTTARGET") then { 
    GW_LASTTARGET = [_target, diag_tickTime];        
} else {
    _timeSince = (diag_tickTime - (GW_LASTTARGET select 1));
    if ( (GW_LASTTARGET select 0) distance _target < 12 && _timeSince < 3) exitWith {        
        [(GW_LASTTARGET select 0), false] call clearPad;
        _waitUntilClear = true;
    };
};

_timeout = diag_tickTime + 3;

waitUntil{    
    _nearby = if (!isNil "GW_LASTTARGET") then { (GW_LASTTARGET select 0) nearEntities 8;  } else { [] };
    ( (_nearby isEqualTo []) || diag_tickTime > _timeout || !_waitUntilClear)
};

GW_LASTTARGET = [_target, diag_tickTime];

_data = _raw;

if (count _data == 0) exitWith {
    systemChat 'Bad data, could not load.';
    false
};

_class  = [_data, 0, _raw, [""]] call filterParam;
_name  = [_data, 1, "UNTITLED", [""]] call filterParam;
_paint  = [_data, 2, "", [""]] call filterParam;
_savedAttachments = [_data, 5, [], [[]]] call filterParam;
_startTime = time;

[_target, false] call clearPad;

if (!_ai) then {
    systemChat format['Loading... %1', _name];
};

// Create it
_vehPos = [tempAreas, nil, nil] call findEmpty;
if (_vehPos distance [0,0,0] <= 200) exitWith { 
    systemChat 'Load areas full, try again in a second.';
    false
};

_heightAboveTerrain = 3;
_vehPosATL = _vehPos;
_vehPosATL set[2, _heightAboveTerrain];

_newVehicle = createVehicle [_class, _vehPosATL, [], 0, "CAN_COLLIDE"];
_newVehicle setPos _vehPosATL;
_newVehicle setDir 0;
_newVehicle setVectorUp [0,0,1];

// If the vehicle has been loaded from a library (not freshly spawned)
if !(_class isEqualType _raw) then {
    _newVehicle setVariable ['isSaved', true];
};

// Setup vehicle on server
[       
    [
        _newVehicle,
        _name
    ],
    "setupVehicle",
    false,
    false 
] call bis_fnc_mp;

// Wait for it to be configured properly
_timeout = time + 5;
waitUntil {
	((time > _timeout) || { _newVehicle getVariable ['isVehicle', false]; })	
};

// Set simulation
[       
    [
        _newVehicle,
        false
    ],
    "setObjectSimulation",
    false,
    false 
] call bis_fnc_mp;

// Loop through and create attached objects
{

    if (!isNil "_x") then {     

        // Retrieve position (and convert if needed)
        _p = _x select 1;
        if (_p isEqualType "") then {
            _p = call compile _p;
        };               

        _dir = (_x select 2);

        // Spawn the object
        _o = [[0,0,100], (_x select 0), (_x select 2), 0, "CAN_COLLIDE", true] call createObject; 
        _o allowDamage false;

        // Add key bind before attach
        _k = if (isNil { (_x select 3) }) then { ["-1", "1"] } else { (_x select 3) };            
        _o setVariable ['GW_KeyBind', _k, true];  

        // _p = (getPosASL _newVehicle) vectorAdd _p;
        // _aP = _newVehicle worldToModel (ASLtoAGL _p);

        _o attachTo [_newVehicle, [0,0,20]];
        _o attachTo [_newVehicle, _p];
       
        if (_dir isEqualType []) then {
            [_o, (_x select 2)] call setPitchBankYaw;   
        } else {
            [_o, _dir] call setDirTo;          
        };      
              
        _o allowDamage true;

    };

    false
    
} count _savedAttachments > 0;

// Set simulation
[       
    [
        _newVehicle,
        true
    ],
    "setObjectSimulation",
    false,
    false 
] call bis_fnc_mp;

_timeout = time + 2;
waitUntil { Sleep 0.1; ((time > _timeout) || (simulationEnabled _newVehicle)) };

// Setup vehicle on client
[       
    [
        _newVehicle
    ],
    "setupLocalVehicle",
    _newVehicle,
    false 
] call bis_fnc_mp;

// Apply texture
if (!isNil "_paint") then {

    // Don't apply blank paints to vehicles
    if (count toArray _paint == 0) exitWith {};
        
    [[_newVehicle,_paint],"setVehicleTexture",true,false] call bis_fnc_mp;
};

_targetPos = if (!isNil "_target") then { _target } else { (ASLtoATL getPosASL _newVehicle) };
_newVehicle setPos _targetPos;

if (GW_PREVIEW_CAM_ACTIVE) then { GW_PREVIEW_CAM_TARGET = _newVehicle; GW_PREVIEW_VEHICLE = _newVehicle; };

_newVehicle lock true;
_newVehicle lockCargo true;
_newVehicle setDammage 0;
{  _x setDammage 0; _x enableSimulationGlobal true; false } count (attachedObjects _newVehicle) > 0;

_endTime = time;
_totalTime = round ((_endTime - _startTime) * (10 ^ 3)) / (10 ^ 3);
systemchat format['Vehicle loaded in %1.',  (_endTime - _startTime)];

GW_LOADEDVEHICLE = _newVehicle;

true