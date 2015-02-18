//
//      Name: loadVehicle
//      Desc:  Generate a vehicle on server side using raw data
//      Return: None
//

private['_class', '_name', '_camo', '_source', '_o', '_k'];

_player = _this select 0;
_target = _this select 1;
_raw = _this select 2;
_ai = if (isNil {_this select 3}) then { false } else { (_this select 3) };

if (isNull _player || (count _target == 0) || (count _raw == 0)) exitWith {};
if (GW_DEBUG) then { copyToClipboard str _raw; };

_source = if (!_ai) then { (owner _player) } else { nil };

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

if (!_ai && GW_DEBUG) then {
    // Everything's ok, reassure the client
    pubVar_systemChat = "Received request.";
    _source publicVariableClient "pubVar_systemChat";
};

if (count _data == 0) exitWith {
    pubVar_systemChat = 'Bad data, could not load.';
    _source publicVariableClient "pubVar_systemChat";
};

_savedAttachments = if (isNil { _data select 4}) then { [] } else { (_data select 5) };
_startTime = time;

[_target, false] call clearPad;

if (!_ai) then {
    pubVar_systemChat = format['Loading... %1', (_data select 1)];
    _source publicVariableClient "pubVar_systemChat";
};

// Create it
_vehPos = if (isNil {_data select 3}) then { [0,0,0] } else { (_data select 3) }; 

if (typeName _vehPos == "STRING") then {
    _vehPos = call compile _vehPos; 
};

_heightAboveTerrain = 1;
_vehPosATL = (ASLtoATL _vehPos);
_vehPosATL set[2, _heightAboveTerrain];

_newVehicle = createVehicle [(_data select 0), _vehPosATL, [], 0, "FLY"];

_newVehicle enableSimulationGlobal false;

// Apply default attributes
[_newVehicle, (_data select 1), true, false, true] call setupVehicle;

_errors = 0;

_deletedItems = [
    'Land_PenBlack_F',
    'Land_Barrel_F', // old emp
    'B_HMG_01_F', // old hmg model
    'Land_BarrelTrash_F',
    'Land_New_WiredFence_5m_F',
    "Land_Sack_F", 
    "Land_CnCBarrierMedium4_F", 
    "Land_WaterTank_F" 
];

// Loop through and create attached objects
{

    if (!isNil "_x") then {

        if ((_x select 0) in _deletedItems) then {} else {

            // Retrieve position (and convert if needed)
            _p = _x select 1;
            if (typename _p == "STRING") then {
                _p = call compile _p;
            };               

            _p = _newVehicle modelToWorld _p;
            
            // Spawn the object
            _o = [_p, 0, (_x select 0), 0, "CAN_COLLIDE", true] call createObject;
            _o disableCollisionWith _newVehicle;
            _o setPos _p;                     
            _o attachTo [_newVehicle];
            
            _dir = (_x select 2);
            _rotation = if (typename _dir == "ARRAY") then {

                [_o, (_x select 2)] call setPitchBankYaw;            
                ((_x select 2) select 2)

            } else {

                _o setDir _rotation;
                pubVar_setDir = [_o, _rotation];
                publicVariable "pubVar_setDir";  

                (_x select 2)            
            };      

            _o setDammage 0;        

            // Add key bind
            _k = (_x select 3);
            _k = if (isNil "_k") then { ["-1", "1"] } else { _k };            
            _o setVariable ['GW_KeyBind', _k, true];             

        };
    };

    false
    
} count _savedAttachments > 0;

// Set paint (if exists)
_paint = (_data select 2);

if (!isNil "_paint") then {
    [[_newVehicle,_paint],"setVehicleTexture",true,false] call BIS_fnc_MP;
};
    
// Set simulation
_newVehicle enableSimulationGlobal true;
_newVehicle lockDriver true;
_newVehicle lockCargo true;
_newVehicle setDammage 0;
{  _x setDammage 0; false } count (attachedObjects _newVehicle) > 0;

if (!isNil "_target") then {
    _newVehicle setPos _target;
};

_endTime = time;
_totalTime = round ((_endTime - _startTime) * (10 ^ 3)) / (10 ^ 3);
pubVar_status = [1, [_newVehicle, (_endTime - _startTime)]]; 

if (!_ai) then { _source publicVariableClient "pubVar_status"; } else {
    _newVehicle setVariable ["isBot", true, true];
    GW_BOT_ACTIVE = _newVehicle;
};