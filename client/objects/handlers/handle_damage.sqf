//
//      Name: handleDamageObject
//      Desc: Damage event handler for objects
//      Return: Bool (False, as health handled independently)
//

// Currently disabled

// private ["_obj", "_damage", "_projectile"];

// _obj = _this select 0;
// _damage = _this select 2;
// _projectile = _this select 4;

// _health = _obj getVariable ["health", 0];

// // Only handle damage outside of the workshop
// if (GW_CURRENTZONE != "workshopZone") then {   

//     if (_health > 0) then  {

//         if (_projectile == "") then {

//             _damage = (_damage * OBJ_COLLISION_DMG_SCALE);

//         } else {

//             _scale = switch (_projectile) do
//             {
//                 case ("R_PG32V_F"): { OBJ_RPG_DMG_SCALE };
//                 case ("M_Titan_AT"): { OBJ_TITAN_AT_DMG_SCALE };
//                 case ("M_NLAW_AT_F"): { OBJ_GUD_DMG_SCALE };
//                 case ("B_127x99_Ball_Tracer_Red"): { OBJ_LSR_DMG_SCALE };
//                 case ("B_127x99_Ball_Tracer_Yellow"): { OBJ_HMG_DMG_SCALE };
//                 case ("B_35mm_AA_Tracer_Yellow"): { OBJ_HMG_HE_DMG_SCALE };
//                 case ("R_TBG32V_F"): { OBJ_MORTAR_DMG_SCALE };
//                 case ("G_40mm_HEDP"): { OBJ_GMG_DMG_SCALE };
//                 case ("Bo_GBU12_LGB"): { OBJ_EXP_DMG_SCALE };          
//                 default                                { 1 };
//             };

//             _damage = (_damage * _scale);

//         };
        
       
//     };

//     _health = _health - _damage;

//     _obj setVariable["health", _health, true];

//     if (_health < 0) then {

//         _obj spawn {

//             playSound3D ["a3\sounds_f\sfx\explosion2.wss", _this, false, getPosASL _this, 1, 1, 40];   
            
//             [_this] spawn destroyObj;

//         };

//     };

// } else {    
//     _obj setVariable ["health", _health];
//     _obj setDammage 0;
// };


false
