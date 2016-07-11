//
//      Name: loadVehicle
//      Desc:  Generate a vehicle on server using raw data
//      Return: None
//

private['_class', '_name', '_camo', '_source', '_o', '_k', '_raw'];
params ['_player', '_target', '_raw'];

_ai = [_this, 3, false, [false]] call filterParam;

if (isNull _player || (count _target == 0) || (count _raw == 0)) exitWith {};

diag_log format['%1 request to load %2 [ %3 ]', name _player, _target, (count _raw)];

_source = if (!_ai) then { (owner _player) } else { nil };

// Check the packet size is within tolerance
if (count _raw > GW_MAX_DATA_SIZE) exitWith {
    hint format['%1 / %2', _raw, count _raw];
    pubVar_systemChat = 'Vehicle is too large to load.';
    _source publicVariableClient "pubVar_systemChat";
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

_data = call compile _raw;

if (count _data == 0) exitWith {
    pubVar_systemChat = 'Bad data, could not load.';
    _source publicVariableClient "pubVar_systemChat";
};

_savedAttachments = [_data, 5, [], [[]]] call filterParam;
_startTime = time;

[_target, false] call clearPad;

if (!_ai) then {
    pubVar_systemChat = format['Loading... %1', (_data select 1)];
    _source publicVariableClient "pubVar_systemChat";
};

// Create it
_vehPos = tempArea_1;
// _vehPos = [tempAreas, nil, nil] call findEmpty;
// if (_vehPos distance [0,0,0] <= 200) exitWith { 
//      pubVar_systemChat = 'Load areas full, try again in a second.';
//     _source publicVariableClient "pubVar_systemChat";
// };

_heightAboveTerrain = 2;
_vehPosATL = (ASLtoATL getPosASL _vehPos);
_vehPosATL set[2, _heightAboveTerrain];

_newVehicle = createVehicle [(_data select 0), _vehPosATL, [], 0, "CAN_COLLIDE"];
_newVehicle setPos _vehPosATL;
_newVehicle setDir 0;
_newVehicle setVectorUp [0,0,1];
_newVehicle enableSimulationGlobal false;

// Get paint (if exists)
_paint = (_data select 2);

// Loop through and create attached objects
{

    if (!isNil "_x") then {     

        // Retrieve position (and convert if needed)
        _p = _x select 1;
        if (typename _p == "STRING") then {
            _p = call compile _p;
        };               

        _wP = _newVehicle modelToWorldVisual _p;
        _dir = (_x select 2);

        // Spawn the object
        _o = [_wP, (_x select 0), (_x select 2), 0, "CAN_COLLIDE", true] call createObject; 

        _o attachTo [_newVehicle, [random 20, random 20, random 20]];
        _o attachTo [_newVehicle, (_p vectorAdd (boundingCenter _o))];
       
        _rotation = if (typename _dir == "ARRAY") then {
            [_o, (_x select 2)] call setPitchBankYaw;   
            ((_x select 2) select 2)

        } else {
            _o setDir _dir;
            _o setDir _dir;
            (_x select 2)            
        };      
  
        _o setDammage 0;      
        pubVar_setDir = [_o, _rotation];
        publicVariable "pubVar_setDir";    

        // Add key bind
        _k = (_x select 3);
        _k = if (isNil "_k") then { ["-1", "1"] } else { _k };            
        _o setVariable ['GW_KeyBind', _k, true]; 
        //_o enableSimulationGlobal false;     

    };

    false
    
} count _savedAttachments > 0;

// Set simulation
_newVehicle enableSimulationGlobal true;

// Apply default attributes
[_newVehicle, (_data select 1), true, false, true] call setupVehicle;

if (!isNil "_paint") then {
    [[_newVehicle,_paint],"setVehicleTexture",true,false] call bis_fnc_mp;
};

_timeout = time + 2;
waitUntil { Sleep 0.1; ((time > _timeout) || (simulationEnabled _newVehicle)) };

// Set Vehicle Texture
[[_newVehicle,_paint],"setVehicleTexture",true,false] call bis_fnc_mp;

// Check for bad weapons/too many parts
_newVehicle call cleanAttached;

_targetPos = if (!isNil "_target") then { _target } else { (ASLtoATL getPosASL _newVehicle) };
_newVehicle setPos _targetPos;

_newVehicle lock true;
_newVehicle lockCargo true;
_newVehicle setDammage 0;
{  _x setDammage 0; false } count (attachedObjects _newVehicle) > 0;

_endTime = time;
_totalTime = round ((_endTime - _startTime) * (10 ^ 3)) / (10 ^ 3);
pubVar_status = [1, [_newVehicle, (_endTime - _startTime)]]; 

if (!_ai) then { _source publicVariableClient "pubVar_status"; } else {
    _newVehicle setVariable ["isBot", true, true];
    GW_BOT_ACTIVE = _newVehicle;
};
