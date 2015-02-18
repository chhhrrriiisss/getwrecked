//
//      Name: saveVehicle
//      Desc: Gathers all information about a vehicle and saves to profileNameSpace
//      Return: None
//

private['_saveTarget'];

if (GW_SETTINGS_ACTIVE || GW_PREVIEW_CAM_ACTIVE) exitWith {};
if (GW_WAITSAVE) exitWith {  systemChat 'Save currently in progress. Please wait.'; };
GW_WAITSAVE = true;

_saveTarget = _this select 0;

_onExit = {
    systemChat (_this select 0);
    GW_WAITSAVE = false;
};

// Prevent abuse
if (_saveTarget == 'default' || _saveTarget == 'last' || _saveTarget == 'GW_LASTLOAD' || _saveTarget == 'GW_LIBRARY' || _saveTarget == 'VEHICLE') exitWith {
    ['Sorry that name is reserved, try saving as something else!'] call _onExit;
};

// Find the closest pad and abort if we're too far away
_pos = (ASLtoATL getPosASL player); 
_closest = [saveAreas, _pos] call findClosest; 
_distance = (_closest distance player);

if (_distance > 15) exitWith {
    ['You need to be a bit closer to use this!'] spawn _onExit;
};

_target = _closest;

_owner = ( [_target, 8] call checkNearbyOwnership);

if (!_owner) exitWith {
     ["You don't own this vehicle."] spawn _onExit;
};

// Find the closest valid vehicle on pad
_targetPos = getPosASL _target;
_nearby = (position _target) nearEntities [["Car"], 8];

if ( count _nearby == 0) exitWith {
    ['No vehicle to save!'] call _onExit;
    GW_WAITSAVE = false;
};

if ( (count _nearby) > 1) exitWith {
    ['Too many vehicles on the pad, please clear it!'] spawn _onExit;
};

GW_SAVE_VEHICLE = _nearby select 0;

_isOwner = [GW_SAVE_VEHICLE, player, true] call checkOwner;
if (!_isOwner) exitWith {
    ["You don't own this vehicle!"] spawn _onExit;
};

// Check it's a valid vehicle and if not wait for it to be compiled
_allowUpgrade = GW_SAVE_VEHICLE getVariable ['isVehicle', false];

if (!_allowUpgrade) then {
    [GW_SAVE_VEHICLE] call compileAttached;    
};

// Disable simulation on vehicle
if (!simulationEnabled GW_SAVE_VEHICLE) then {
    [       
        [
            GW_SAVE_VEHICLE,
            true
        ],
        "setObjectSimulation",
        false,
        false 
    ] call BIS_fnc_MP;
};

// Wait for simulation enabled and vehicle compiled
_timeout = time + 3;
waitUntil{ 
    Sleep 0.1;
    if ( (time > _timeout) || (simulationEnabled GW_SAVE_VEHICLE && { ((getPos GW_SAVE_VEHICLE) select 2 < 1) } && {GW_SAVE_VEHICLE getVariable ['isVehicle', false]} ) ) exitWith { true };
    false
};

if (time > _timeout) exitWith {
    ['Error saving, simulation not enabled or vehicle not compiled properly!'] spawn _onExit;
};


// Wait just a second
Sleep 0.01;

// Kick out anyone who is inside
_crew =  (crew GW_SAVE_VEHICLE);
if ( (count _crew) > 0) then {
    {
        _x action ["eject", GW_SAVE_VEHICLE];
    } ForEach _crew;   
};

// Wait for them to get kicked out
_timeout = time + 5;
waitUntil{ 
    Sleep 0.1;
    _crew =  (crew GW_SAVE_VEHICLE);
    if ( (time > _timeout) || ((count _crew) <= 0) ) exitWith { true };
    false
};

if (time > _timeout) exitWith {
    ['Error saving, you have to exit the vehicle first!'] spawn _onExit;
};

// Actuall saving now
systemChat 'Saving...';

// Find a temporary area to park our vehicle
_temp = [tempAreas, nil, nil] call findEmpty;
if (_temp distance [0,0,0] <= 200) exitWith {
    ['Error saving, try again maybe?'] spawn _onExit;
};

// Store the vehicle location for reference and align to new location
_tempPos = getPosASL _temp;
GW_SAVE_VEHICLE setDir 0;
GW_SAVE_VEHICLE setPosASL _tempPos;

// Wait for the vehicle to align
_timeout = time + 5;
waitUntil {
    _vel = [0,0,0] distance (velocity GW_SAVE_VEHICLE);
    _dist = ((getPosASL GW_SAVE_VEHICLE) distance _tempPos);
    _dir = floor( getDir GW_SAVE_VEHICLE );

    if ( time > _timeout || (_vel == 0 && _dist < 1 && _dir == 0)  ) exitWith { true };
    false
};

// Took too long to align, abort to avoid errors
if (time > _timeout) exitWith {
    ['Error saving, try again maybe?'] spawn _onExit;
    GW_SAVE_VEHICLE setPosASL _targetPos;
};


_class = typeOf GW_SAVE_VEHICLE;
_name = GW_SAVE_VEHICLE getVariable ["name", 'Untitled'];
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

    if (typename _result == "STRING") then {

        if (count toArray _result > 0) then {
            _name = _result;
            _saveTarget = _result;
        };
        
    } else {
        _abort = true;
    };    
};

if (_abort) exitWith {
    ['Save aborted by user.'] spawn _onExit;
    GW_SAVE_VEHICLE setPosASL _targetPos;
};

_startTime = time;

_paint = GW_SAVE_VEHICLE getVariable ["paint",""];

// Grab position
_pos = (ASLtoATL getPosASL GW_SAVE_VEHICLE);
_oldPos = _pos call positionToString;
_oldDir = getDir GW_SAVE_VEHICLE;

_attachments = attachedObjects GW_SAVE_VEHICLE;

_attachArray = [];

// Items that are old and should be removed
_pruneList = [
    'Land_PenBlack_F',
    'Land_Barrel_F', // old emp
    'B_HMG_01_F', // old hmg model
    'Land_BarrelTrash_F',
    'Land_New_WiredFence_5m_F',
    "Land_Sack_F", 
    "Land_CnCBarrierMedium4_F", 
    "Land_WaterTank_F" 
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
        if (_x isKindOf "StaticWeapon") then { 
            _boundingCenter = boundingCenter _x;
            _actualCenter = [-(_boundingCenter select 0), -(_boundingCenter select 1), -(_boundingCenter select 2)];
            _pos = (_x modelToWorld _actualCenter);

            _p = _pos;
        };
        
         _p = GW_SAVE_VEHICLE worldToModel _p;


        
        // Delete the object if we're having issues with it (or its old)
        if (!alive _x || (_p distance _pos) > 999999  || (typeOf _x) in _pruneList ) then {

           deleteVehicle _x;

        } else {   

            _p =  _p call positionToString;
            _c = typeOf _x;   
            _k = _x getVariable ["GW_KeyBind",  ["-1", "1"]];

            if (_c == 'groundWeaponHolder') then { _c = _x getVariable "type"; };

            _pitchBank = _x call BIS_fnc_getPitchBank;
            _dir = [(_pitchBank select 0), (_pitchBank select 1), getDir _x];

            _element = [_c, _p, _dir, _k];
            _attachArray pushBack _element;

        };

    } ForEach _attachments;
};

// Get various meta and random data about the vehicle
_creator = GW_SAVE_VEHICLE getVariable ['creator', GW_PLAYERNAME];
_prevAmmo = GW_SAVE_VEHICLE getVariable ["ammo", 1];
_prevFuel = (fuel GW_SAVE_VEHICLE) + (GW_SAVE_VEHICLE getVariable ["fuel", 0]);
_vehicleBinds = GW_SAVE_VEHICLE getVariable ['GW_Binds', GW_BINDS_ORDER];
_taunt = GW_SAVE_VEHICLE getVariable ['GW_Taunt', []];

_meta = [
    GW_VERSION, // Current version of GW
    _creator, // Original author of vehicle
    _prevFuel, // Prior Fuel
    _prevAmmo,  // Prior Ammo
    [], // Stats would go here, but they are handled locally and seperately  
    _vehicleBinds,
    _taunt
];

_data = [_class, _name, _paint, _oldPos, _oldDir, _attachArray, _meta];    

_success = [_saveTarget, _data] call registerVehicle;
GW_LASTLOAD = _saveTarget;

// Force a sync of the vehicles stats
['', GW_SAVE_VEHICLE, '', true] spawn logStat;  

if (_success) then {
    _totalTime = time - _startTime;
    systemChat format['Vehicle saved: %1 in %2.', _saveTarget, _totalTime];
    ['VEHICLE SAVED!', 2, successIcon, nil, "slideDown"] spawn createAlert; 
} else {
    systemChat format['Error saving %1 to library.', _saveTarget];
};

// Return the vehicle to the pad
GW_SAVE_VEHICLE setVariable ["name", _saveTarget, true];
GW_SAVE_VEHICLE setVariable ["isSaved", true];
GW_SAVE_VEHICLE setPosASL _targetPos;
GW_SAVE_VEHICLE setDammage 0;

// Make it so other people can use the pad
_closest setVariable ["owner", "", true];

// Then re-disable simulation
[''] spawn _onExit;
