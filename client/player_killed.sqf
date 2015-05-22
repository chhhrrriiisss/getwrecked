//
//      Name: playerKilled
//      Desc: Handles respawn and 'killed by' for dead player
//      Return: None
//

_victim = [_this,0, objNull, [objNull]] call filterParam;
if (isNull _victim) exitWith {};

// Disable hud
GW_HUD_ACTIVE = false;

9999 cutText ["", "BLACK OUT", 0.5];  

_prevVehicle = _victim getVariable ["GW_prevVeh", nil];

// Log the death for the last vehicle we were in
if (!isNil "_prevVehicle") then {
    ['death', _prevVehicle, 1, true] call logStat;
};

// // Player killed by tag
// if (!isNil "_killedBy") then {
//     _r = [_killedBy] call findUnit;
//     _killer = _r;
// };

// // Check vehicle killed by tag
// if (isNil "_killer" && isNil "_killedBy" && !isNil "_prevVehicle") then {

//     _vehKilledBy = _prevVehicle getVariable ["killedBy", nil];

//     if (!isNil "_vehKilledBy") then {

//         _r = [_vehKilledBy] call findUnit;
//         _killer = _r;
//     };
// };

// // Still no luck finding killer? Go old school and search nearby area
// if(isNil "_killer") then {

// 	_location = getPos _victim;
//     _vehs = _location nearEntities["Car", 150];
//     _suspects = [];

//     {
//         if((count crew _x > 0) && !isNull(driver _x) && (_x getVariable ["isVehicle", true]) ) then {     
// 			_suspects = _suspects + [_x];		
//         };
//         false
//     } count _vehs > 0;

//     if(count(_suspects) > 0) then {
//         _closest = 9999;
//         {   
//             _distance = _location distance _x;
//             if (_distance < _closest) then {
//                 _killer = driver( _x );
//             };
//         } count _suspects > 0;
//     };
// };

// if (!isNil "_killer") then {
//     profileNamespace setVariable ['killedBy', _killer];
//     saveProfileNamespace;
// };


if(true) exitWith{};