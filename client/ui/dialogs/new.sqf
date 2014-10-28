//
//      Name: newMenu
//      Desc: Used for purchasing and unlocked vehicles
//      Return: None
//

private ['_vehicle', '_unit'];

if (GW_NEW_ACTIVE) exitWith {};
GW_NEW_ACTIVE = true;

_pad = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _pad) exitWith {};

disableSerialization;
if(!(createDialog "GW_New")) exitWith { GW_NEW_ACTIVE = false; }; //Couldn't create the menu

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerStatic cutRsc ["RscStatic", "PLAIN" , 0.5];

[] spawn generateVehiclesList;

// Choose the vehicle at the top of the list by default
[(GW_VEHICLE_LIST select 0) select 0] spawn generateAttributesList;

"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [0.3]; 
"dynamicBlur" ppEffectCommit 0.25; 

// Menu has been closed, kill everything!
waitUntil { isNull (findDisplay 96000) };

"dynamicBlur" ppEffectAdjust [0]; 
"dynamicBlur" ppEffectCommit 0.1; 

GW_NEW_ACTIVE = false;

