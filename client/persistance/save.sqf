//
//      Name: saveVehicle
//      Desc: Gathers all information about a vehicle and saves to profileNameSpace
//      Return: None
//

private['_saveTarget'];

if (GW_SETTINGS_ACTIVE || GW_PREVIEW_CAM_ACTIVE) exitWith {};
if (GW_WAITSAVE) exitWith {  systemChat 'Save currently in progress. Please wait.'; };
GW_WAITSAVE = true;

_startTime = time;

_saveTarget = [_this,0, "", [""]] call BIS_fnc_param;

// Prevent abuse
if (_saveTarget == 'default' || _saveTarget == 'last' || _saveTarget == 'GW_LASTLOAD' || _saveTarget == 'GW_LIBRARY') exitWith {
    systemChat 'Sorry that name is reserved.';
    GW_WAITSAVE = false;
};

// Find the closest pad and abort if we're too far away
_pos = (ASLtoATL getPosASL player); 
_closest = [saveAreas, _pos] call findClosest; 
_distance = (_closest distance player);

if (_distance > 15) exitWith {
    systemChat 'You need to be closer to use that.';
    GW_WAITSAVE = false;
};

_isOwner = [_closest, player, true] call checkOwner; 
if (!_isOwner) exitWith {
    systemChat 'This terminal is already in use.';
};

_target = _closest;

// Find the closest valid vehicle on pad
_targetPos = getPosASL _target;
_nearby = (position _target) nearEntities [["Car"], 8];

if ( count _nearby == 0) exitWith {
    systemChat 'No vehicle to save';
    GW_WAITSAVE = false;
};

if ( (count _nearby) > 1) exitWith {
    systemChat 'Too many vehicles on the pad. Please clear it first.';
    GW_WAITSAVE = false;
};

_closest = _nearby select 0;

// Check it's a valid vehicle
_allowUpgrade = _closest getVariable ['isVehicle', false];
_simulated = simulationEnabled _closest;

if (!(_allowUpgrade) || !_simulated) exitWith {
    systemChat 'Not a valid vehicle.';
    GW_WAITSAVE = false;
};

_vehicle = _closest;

// Kick out anyone who is inside
_crew =  (crew _vehicle);
if ( (count _crew) > 0) then {
    {
        _x action ["eject", _vehicle];
    } ForEach _crew;   
};

// Wait for them to get kicked out
_timeout = time + 5;
waitUntil{ 
    _crew =  (crew _vehicle);
    if ( (time > _timeout) || ((count _crew) <= 0) ) exitWith { true };
    false
};

if (time > _timeout) exitWith {
    systemChat 'Error saving... you must exit the vehicle first.';
    GW_WAITSAVE = false;
};

// Actuall saving now
systemChat 'Saving...';

// Find a temporary area to park our vehicle
_temp = [tempAreas, nil, nil] call findEmpty;
if (_temp distance [0,0,0] <= 200) exitWith {
    systemChat 'Error saving. Try again in a few seconds.';
    GW_WAITSAVE = false;
};

// Store the vehicle location for reference and align to new location
_tempPos = getPosASL _temp;
_vehicle setDir 0;
_vehicle setPosASL _tempPos;

// Wait for the vehicle to align
_timeout = time + 5;
waitUntil {     
    _vel = [0,0,0] distance (velocity _vehicle);
    _dist = ((getPosASL _vehicle) distance _tempPos);
    _dir = floor( getDir _vehicle );

    if ( time > _timeout || (_vel == 0 && _dist < 1 && _dir == 0)  ) exitWith { true };
    false
};

// Took too long to align, abort to avoid errors
if (time > _timeout) exitWith {
    systemChat 'Error saving.';
    GW_WAITSAVE = false;
    _vehicle setPosASL _targetPos;
};


_class = typeOf _vehicle;
_name = _vehicle getVariable ["name", 'Untitled'];
if (isNil "_name") then {  _name = 'Untitled'; };

// Check the name and save target is valid
_len = (count toArray(_name));
if ( _len == 0 || _name == ' ') then {
    _name = 'Untitled';
};

_len = (count toArray(_saveTarget));
if ( _len == 0 || _saveTarget == ' ') then {
    _saveTarget = _name;
} else {
    _name = _saveTarget;
};

_abort = false;

// If no save target specified, see if the user wants to give it one
if (_name == "Untitled") then {

    _result = ['SAVE', _name, 'INPUT'] call createMessage;

    if (count toArray _result > 0) then {
        _name = _result;
        _saveTarget = _result;
    } else {
        _abort = true;
    };    
};

if (_abort) exitWith {
    systemChat 'Save aborted.';
    GW_WAITSAVE = false;
    _vehicle setPosASL _targetPos;
};

_paint = _vehicle getVariable ["paint",""];

// Grab position
_pos = (ASLtoATL getPosASL _vehicle);
_oldPos = _pos call positionToString;
_oldDir = getDir _vehicle;

_attachments = attachedObjects _vehicle;

_attachArray = [];

// Items that are old and should be removed
_pruneList = [
    'Land_PenBlack_F',
    'Land_Barrel_F', // old emp
    'B_HMG_01_F', // old hmg model
    'Land_BarrelTrash_F'
];


// Get information about each attached item
if (count _attachments > 0) then {

    _timeout = time + 5;
    _tempPos set[2,0];

    // Wait for those items to get to the vehicle's location
    waitUntil {
        _dist = (ASLtoATL getPosASL (_attachments select 0)) distance _tempPos;
        if ( time > _timeout || (_dist < 100) ) exitWith { true };
        false
    };
   
    {     
        _p = (ASLtoATL getPosASL _x);

        // If its a static weapon, or just wierd, correctly get the reference position
        if (_x isKindOf "StaticWeapon" || typeOf _x == "groundWeaponHolder") then { 
            _boundingCenter = boundingCenter _x;
            _actualCenter = [-(_boundingCenter select 0), -(_boundingCenter select 1), -(_boundingCenter select 2)];
            _pos = (_x modelToWorld _actualCenter);
            _p = _pos;
        };
                
        _p = _vehicle worldToModel _p;
        
        // Delete the object if we're having issues with it (or its old)
        if (!alive _x || (_p distance _pos) > 999999 || (typeOf _x) in _pruneList ) then {

           deleteVehicle _x;

        } else {   

            _p =  _p call positionToString;
            _c = typeOf _x;   
            _k = _x getVariable ["bind", -1];  

            if (_c == 'groundWeaponHolder') then { _c = _x getVariable "type"; };

            _pitchBank = _x call BIS_fnc_getPitchBank;
            _dir = [(_pitchBank select 0), (_pitchBank select 1), getDir _x];

            _element = [_c, _p, _dir, _k];
            _attachArray pushBack _element;

        };

    } ForEach _attachments;
};

// Get various meta and random data about the vehicle
_creator = _vehicle getVariable ['creator', GW_PLAYERNAME];
_prevAmmo = _vehicle getVariable ["ammo", 1];
_prevFuel = (fuel _vehicle) + (_vehicle getVariable ["fuel", 0]);

_meta = [
    GW_VERSION, // Current version of GW
    _creator, // Original author of vehicle
    _prevFuel, // Prior Fuel
    _prevAmmo  // Prior Ammo
    // Stats would go here, but they are handled locally and seperately  
];

_data = [_class, _name, _paint, _oldPos, _oldDir, _attachArray, _meta];    
_success = [_saveTarget, _data] call registerVehicle;

// Force a sync of the vehicles stats
['', _vehicle, '', true] spawn logStat;  

if (_success) then {
    _totalTime = time - _startTime;
    systemChat format['Vehicle saved: %1 in %2.', _saveTarget, _totalTime];
    ['VEHICLE SAVED!', 2, successIcon, nil, "slideDown"] spawn createAlert; 
} else {
    systemChat format['Error saving %1 to library.', _saveTarget];
};

// Return the vehicle to the pad
_vehicle setVariable ["isSaved", true];
_vehicle setPosASL _targetPos;
_vehicle setDammage 0;

GW_WAITSAVE = false;

// Make it so other people can use the pad
_closest setVariable ["owner", "", true];
