//
//      Name: inventoryMenu
//      Desc: Used for removing items from supply boxes
//      Return: None
//

if (GW_INVENTORY_ACTIVE) exitWith {};
GW_INVENTORY_ACTIVE = true;

GW_INVENTORY_BOX = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull GW_INVENTORY_BOX) exitWith {};

disableSerialization;
if(!(createDialog "GW_Inventory")) exitWith { GW_INVENTORY_ACTIVE = false; }; //Couldn't create the menu

[GW_INVENTORY_BOX] spawn generateInventoryList;

"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [0.3]; 
"dynamicBlur" ppEffectCommit 0.25; 

// Menu has been closed, kill everything!
waitUntil { isNull (findDisplay 98000) };

"dynamicBlur" ppEffectAdjust [0]; 
"dynamicBlur" ppEffectCommit 0.1; 

GW_INVENTORY_ACTIVE = false;

