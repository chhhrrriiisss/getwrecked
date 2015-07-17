//
//      Name: handleKilledVehicle
//      Desc: Killed event handler on vehicles
//     

private ["_veh", "_name", "_value", "_totalValue", "_actualValue", "_owner", "_newSpawn", "_crew", "_name"];

_veh = [_this,0, objNull, [objNull]] call filterParam;

if (isNull _veh) exitWith {};
if (!local _veh) exitWith {};

_processed = _veh getVariable ['GW_killProcessed', false];
if (_processed) exitWith {};
_veh setVariable ['GW_killProcessed', true];

_veh removeEventHandler ["handleDamage", 0];
_veh removeEventHandler ["killed", 0];
_veh removeEventHandler ["getIn", 0];
_veh removeEventHandler ["getOut", 0];
_veh removeEventHandler ["hit", 0];
_veh removeEventHandler ["epecontact", 0];
_veh removeEventHandler ["explosion", 0];

if (isNil "GW_LASTMESSAGELOGGED") then { GW_LASTMESSAGELOGGED = time - 5; };
if (time - GW_LASTMESSAGELOGGED < 5) exitWith {};
GW_LASTMESSAGELOGGED = time;

_veh spawn {


    _veh = _this;   
    _name = _veh getVariable ['name', ""];

    // Log a death for this vehicle
    if (!isServer) then { ['death', _name, 1] call logStat;  };

    // Kill the crew & nearby players  
    _crew = crew _veh;
    { _x setDammage 1; false } count _crew > 0;
    _nearby = (ASLtoATL getPosASL _veh) nearEntities[["Man"], 5];
    { if ((vehicle _x) == _x) then { _x setDammage 1; }; false  } count _nearby > 0;
    _collateral = attachedObjects _veh;

    if (count _collateral > 0) then {

        {         
            detach _x;
            deleteVehicle _x;
        } foreach _collateral;

    };

    // Wait for killedBy to be populated...
    _timeout = time + 3;
    waitUntil{          
        ( (!isNil { _veh getVariable ["killedBy", nil] }) || (time > _timeout) ) 
    };

    _killedBy = _veh getVariable ["killedBy", nil];    
    if (isNil "_killedBy") exitWith {};    
    
    _owner = _veh getVariable ["GW_Owner", ""];  
    _veh setVariable ["GW_Owner", '', true];     

    _killedBy = if (typename _killedBy == "STRING") then { (call compile _killedBy) } else { _killedBy };       
    profileNamespace setVariable ['killedBy',_killedBy];
     
    _newSpawn = _veh getVariable ["newSpawn", false];

    // No money for killing new spawns
    _rawValue = _veh getVariable ['GW_Value', 200];
    _wanted = _veh getVariable ['GW_WantedValue', 0];
    _valueOfKill =  if (_newSpawn) then { 0 } else { ((_rawValue + _wanted) * GW_KILL_VALUE) };
    _crew = crew _veh;    
    
    // No money for destroying own vehicle
    _valueOfKill = if (_owner == (_killedBy select 0)) then { 0 } else { _valueOfKill }; 

    if (_name == "") then { _name = 'A vehicle'; };                
        
    [       
        [
            _name,
            (_killedBy select 0), // Killer
            [(_killedBy select 2), (_killedBy select 3)], // Killer's vehicle
            _valueOfKill,
            (_killedBy select 1) // Method
        ],
        "logKill",
        false,
        false 
    ] call bis_fnc_mp;       
  
};
