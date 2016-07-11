private ["_veh", "_abandonDelay", "_deadDelay", "_create", "_dir", "_pos", "_vehType", "_active"];
params ['_veh', '_del'];

_abandonDelay = _del * 60;

_dir = getDir _veh; 
_pos = getPos _veh; 
_vehtype = typeOf _veh; 

_active = true;

if (isServer) then {

     for "_i" from 0 to 1 step 0 do {

        if (!_active) exitWith {};

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

                _active = false;
            };
        };      
    };
};