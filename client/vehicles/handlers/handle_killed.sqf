/*
        
    Handle Killed Vehicle

*/

private ["_veh", "_name", "_value", "_totalValue", "_actualValue", "_owner", "_newSpawn", "_crew", "_name"];

_veh = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _veh) exitWith {};

_processed = _veh getVariable ['processedDeath', false];

_veh removeAllEventHandlers "handleDamage";
_veh removeAllEventHandlers "killed";
_veh removeAllEventHandlers "getIn";
_veh removeAllEventHandlers "getOut";
_veh removeAllEventHandlers "hit";
_veh removeAllEventHandlers "epecontact";
_veh removeAllEventHandlers "explosion";

if (!_processed) then {
    
    _veh setVariable ['processedDeath', true];    

    _veh spawn {

        _veh = _this;

        _timeout = time + 3;

        waitUntil{

            Sleep 0.1;
            
            _killedBy = _veh getVariable ["killedBy", nil];

            if ( (!isNil "_killedBy") || (time > _timeout) ) exitWith { true };

            false
        };

        _killedBy = _veh getVariable ["killedBy", nil];

        if (!isNil "_killedBy") then {  
                
            _owner = _veh getVariable ["owner", ""];  
            _name = _veh getVariable ['name', ""];
            _newSpawn = _veh getVariable ["newSpawn", false];

            // No money for killing new spawns
            _value =  if (_newSpawn) then { 0 } else { ((_veh getVariable ['GW_Value', 200]) + (_veh getVariable ['GW_WantedValue', 0])) };
            _crew = crew _veh;    

            // No money for destroying own vehicle
            _value = if (_owner == _killedBy) then { 0 } else { _value }; 

            // Reduce value if the vehicle is empty 
            _value = if (count _crew > 0) then { (_value * GW_KILL_VALUE) } else { (_value * GW_KILL_EMPTY_VALUE) };

            if (_name == "") then {   
                _name = 'A vehicle';     
            };                

            // Prevent spamming the server with kill messages
            if (time > (GW_LASTMESSAGELOGGED + 3)) then {

                GW_LASTMESSAGELOGGED = time;
                
                [       
                    [
                        _name,
                        _killedBy,
                        _value
                    ],
                    "logKill",
                    false,
                    false 
                ] call BIS_fnc_MP;    

                ['destroyed', _veh, 1, true] call logStat;

            };

            // Kill the crew      
            { _x setDammage 1; false } count _crew > 0;

        };

    };

    _collateral = attachedObjects _veh;

    if (count _collateral > 0) then {

        {
            _rnd = floor (random 100);

            _type = typeOf _x;

            if (_rnd > 50 || _type == 'Land_Device_assembled_F') then {

            	detach _x;
            	
                [_x, _veh] spawn destroyObj;
            };        

        } ForEach _collateral;

    };

    _veh setVariable ["owner", '', true];

};
