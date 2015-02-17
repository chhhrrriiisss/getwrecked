//
//      Name: sendVehicleHit
//      Return: None
//

if (isNil "GW_LASTDAMAGE_UPDATE") then { GW_LASTHIT_UPDATE = time; };
if (time - GW_LASTHIT_UPDATE < 0.1) exitWith { true };	
GW_LASTHIT_UPDATE = time;

_vOwner = (owner (_this select 0));
_pOwner = (owner (_this select 1));

pubVar_status = [3, []];    
_pOwner publicVariableClient "pubVar_status";
if (_pOwner == _vOwner) then { systemchat 'Hit!'; };