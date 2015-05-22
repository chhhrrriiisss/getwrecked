//
//      Name: buyMenu
//      Desc: Used for purchasing vehicle parts from sponsor companies
//      Return: None
//

private ['_obj', '_unit', '_company'];

_obj = [_this,0, objNull, [objNull]] call filterParam;

if (isNull _obj) exitWith {};
	
if (GW_BUY_ACTIVE) exitWith {};
GW_BUY_ACTIVE = true;
GW_BUY_OBJ = _obj;
GW_BUY_CART = [];

disableSerialization;
if(!(createDialog "GW_Buy")) exitWith { GW_BUY_ACTIVE = false; }; 

[_obj] spawn generateSponsorInfo;
[0] spawn generateCategoryList;

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerStatic cutRsc ["RscStatic", "PLAIN" , 0.5];

// Defaults
_total = ((findDisplay 97000) displayCtrl 97005);
_total ctrlSetText 'TOTAL: $0';
_total ctrlCommit 0;

// Generate a shopping list with prices for the company

"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [0.3]; 
"dynamicBlur" ppEffectCommit 0.25; 

// Menu has been closed, kill everything!
waitUntil { isNull (findDisplay 97000) };

GW_BUY_ACTIVE = false;

"dynamicBlur" ppEffectAdjust [0]; 
"dynamicBlur" ppEffectCommit 0.1; 



