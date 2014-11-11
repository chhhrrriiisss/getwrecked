/*

    Loads a vehicle with given data

*/

private['_class', '_name', '_camo', '_source'];

_player = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_target = [_this,1, [], [[]]] call BIS_fnc_param;
_raw = [_this,2, [], [[]]] call BIS_fnc_param;

if (isNull _player || (count _target == 0) || (count _raw == 0)) exitWith {};

_source = owner _player;

// Everything's ok, reassure the client
pubVar_systemChat = "Recieved request.";
_source publicVariableClient "pubVar_systemChat";

_data = _raw;
if (count _data == 0) exitWith {
    pubVar_systemChat = 'Bad data, could not load.';
    _source publicVariableClient "pubVar_systemChat";
};

_savedAttachments = [_data,5, [], [[]]] call BIS_fnc_param;
_startTime = time;

[_target, false] call clearPad;

pubVar_systemChat = format['Loading... %1', (_data select 1)];
_source publicVariableClient "pubVar_systemChat";

// Create it
_vehPos = [_data,3, [], ["", []]] call BIS_fnc_param;

if (typeName _vehPos == "STRING") then {
    _vehPos = call compile _vehPos; 
};

_heightAboveTerrain = 1;
_vehPosATL = (ASLtoATL _vehPos);
_vehPosATL set[2, _heightAboveTerrain];

_newVehicle = createVehicle [(_data select 0), _vehPosATL, [], 0, "FLY"];

_newVehicle enableSimulationGlobal false;

// Apply default attributes
[_newVehicle, (_data select 1), true, false] call setupVehicle;

_errors = 0;

// Loop through and create attached objects
{

    if (!isNil "_x") then {

        // Retrieve position (and convert if needed)
        _p = _x select 1;
        if (typename _p == "STRING") then {
            _p = call compile _p;
        };               

        _p = _newVehicle modelToWorld _p;
        
        // Spawn the object
        _o = [_p, 0, (_x select 0), 0, "CAN_COLLIDE", false] call createObject;
        _o disableCollisionWith _newVehicle;
        _o setPos _p;                     
        _o attachTo [_newVehicle];
        _o setDammage 0;

        _dir = (_x select 2);
        _rotation = if (typename _dir == "ARRAY") then {

            ((_x select 2) select 2)
            // if (count _dir > 0) then {
            //     [_o, (_x select 2)] call setPitchBankYaw;
            // };
        } else {

            (_x select 2)
            
        };

        _o setDir _rotation;
        pubVar_setDir = [_o, _rotation];
        publicVariable "pubVar_setDir";

        // Add key bind
        _k = (_x select 3);
        _k = if (isNil "_k") then { -1 } else { (_x select 3) };            
        _o setVariable ['bind', _k, true];    

    };

    false
    
} count _savedAttachments > 0;

// Set paint (if exists)
_paint = (_raw select 2);
if (!isNil "_paint") then {
    [[_newVehicle,_paint],"setVehicleTexture",true,false] call BIS_fnc_MP;
};
    
// Set simulation
_newVehicle enableSimulationGlobal true;
_newVehicle lockCargo true;
_newVehicle setDammage 0;
{  _x setDammage 0; false } count (attachedObjects _newVehicle) > 0;

if (!isNil "_target") then {
    _newVehicle setPos _target;
};

_endTime = time;
_totalTime = round ((_endTime - _startTime) * (10 ^ 3)) / (10 ^ 3);
pubVar_status = [1, [_newVehicle, (_endTime - _startTime)]]; 
_source publicVariableClient "pubVar_status";

