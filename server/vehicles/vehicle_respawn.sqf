private ["_veh", "_abandonDelay", "_deadDelay", "_create", "_dir", "_pos", "_vehType", "_active"];

_veh = _this select 0;
_abandonDelay = (_this select 1) * 60;
_deadDelay = (_this select 2) * 60;
_create = [_this, 3, false] call BIS_fnc_param;

_dir = getDir _veh; 
_pos = getPos _veh; 
_vehtype = typeOf _veh; 

_active = true;

if (isServer) then {

    While { _active } do {

        Sleep 1;

        if ((alive _veh) && (canMove _veh) && {{alive _x} count crew _veh == 0}) then {

            _abandoned = true;

            for "_i" from 0 to _abandonDelay do {  

                // Keep getting its position, because otherwise it'll use the original load position
                _position = getPos _veh;
                _nearby = _position nearEntities [["Man"], 10];               

                if (({alive _x} count (crew _veh) > 0) || (!alive _veh) || (!canMove _veh) || count _nearby > 0) exitWith {
                    _abandoned = false;
                };
                sleep 1;  


            };
             
            if ((_abandoned) && {_veh distance _pos > 10}) then {

                { deleteVehicle _x; } count (attachedObjects _veh) > 0;
                deleteVehicle _veh;

                sleep 1;

                if (!_create) exitWith { _active = false };

                if (_create) then {                   

                    _veh = createVehicle [_vehtype, _pos, [], 0, "NONE"];
                    _veh setDir _dir;    

                    [_veh, '', false, false] call setupVehicle;
                };
            };
        };


        if ((!alive _veh) || (!canMove _veh)) then {
            _dead = true;

                for "_i" from 0 to _deadDelay do {  
                    if (({alive _x} count (crew _veh) > 0) || (canMove _veh)) exitWith {_dead = false;};
                    sleep 1;  
                };
             
            if (_dead) then {

                { deleteVehicle _x; } count (attachedObjects _veh) > 0;
                deleteVehicle _veh;

                sleep 1;
                
                if (!_create) exitWith { _active = false };

                if (_create) then {

                    _veh = createVehicle [_vehtype, _pos, [], 0, "NONE"];
                    _veh setDir _dir;

                    [_veh, '', false, false] call setupVehicle;
                };
            };
        };     
    };
};