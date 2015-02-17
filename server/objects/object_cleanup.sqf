/*

    Object Tidy-up Script

*/

private ["_veh", "_abandonDelay", "_deadDelay", "_create", "_dir", "_pos", "_vehType", "_active"];

_obj = _this select 0;
_abandonDelay = GW_OBJECT_ABANDON_DELAY * 60;
_deadDelay = GW_OBJECT_DEAD_DELAY * 60;

_dir = getDir _obj; 
_pos = getPos _obj; 
_objType = typeOf _obj; 

_active = true;

if (isServer) then {

    for "_i" from 0 to 1 step 0 do {

        if (!_active) exitWith {};

        Sleep 1;

        // While it's alive and nothing attached to it
        if (alive _obj && isNull attachedTo _obj) then {

            _abandoned = true;

            for "_i" from 0 to _abandonDelay do {  

                // Keep getting its position, because otherwise it'll use the original load position
                _position = getPos _obj;
                _nearby = _position nearEntities [["Man"], 10];               

                if (!alive _obj || !isNull attachedTo _obj || count _nearby > 0) exitWith {  _abandoned = false; };

                sleep 1;  

            };
             
            if (_abandoned) exitWith {           
                deleteVehicle _obj;       
                _active = false;        
            };
        };

        // If its been destroyed
        if (!alive _obj) exitWith {   
            deleteVehicle _obj;
            _active = false;
        };     
    };
};
