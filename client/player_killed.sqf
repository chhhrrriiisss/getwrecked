//
//      Name: playerKilled
//      Desc: Handles respawn and 'killed by' for dead player
//      Return: None
//

_victim = [_this,0, objNull, [objNull]] call filterParam;
if (isNull _victim) exitWith {};

// Disable hud
GW_HUD_ACTIVE = false;

9999 cutText ["", "BLACK OUT", 0.3];  

_prevVehicle = _victim getVariable ["GW_prevVeh", nil];

// Log the death for the last vehicle we were in
if (!isNil "_prevVehicle") then {
    ['death', _prevVehicle, 1, true] call logStat;
};



if(true) exitWith{};