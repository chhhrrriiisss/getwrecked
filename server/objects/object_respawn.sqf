/*
        
    Object Respawn Script

*/

private["_obj"];

_obj = _this select 0;
_abandonDelay = (_this select 1) * 60;
_deadDelay = (_this select 2) * 60;
_dir = getDir _obj; 
_pos = getPos _obj; 
_objType = typeOf _obj; 

if (isServer) then {
    While {true} Do {
        sleep 1;

        if (alive _obj) then {

            _abandoned = true;
            _position = getPos _obj;

            for "_i" from 0 to _abandonDelay do {  

                _nearby = _position nearEntities [["Man"], 10];
  
                if ((!alive _obj) || count _nearby > 0 || !(isNull attachedTo _obj) ) exitWith {

                    _abandoned = false;

                };

                sleep 1;  

            };
             
            if (_abandoned && {_obj distance _pos > 10}) then {

                //[format['abandoned object detected [ %1 ]', _objType], "systemChatMP"] call BIS_fnc_MP;

                deleteVehicle _obj;
                sleep 1;   
                
                // Abandoned loot has a higher chance of cycling
                _obj = [_pos, _dir, _objType, 85, "NONE", true] call createObject; 
            };

        };
   
        if ((!alive _obj)) then {

            _dead = true;

            for "_i" from 0 to _deadDelay do {  

                if (alive _obj) exitWith {
                    _dead = false;
                };
                sleep 1;  
            };

            sleep 1;

            if (_dead) then {

                //[format['dead object detected [ %1 ]', _objType], "systemChatMP"] call BIS_fnc_MP;

                if (!isNull _obj) then {

                    deleteVehicle _obj;

                };

                sleep 1;   

                _obj = [_pos, _dir, _objType, 50, "NONE", true] call createObject;        
     
            };
        };
    };
};