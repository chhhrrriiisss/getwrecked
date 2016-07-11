//
//      Name: setCurrentZone
//      Desc: Sets the target zone and equips the boundary point data for use with outOfBounds checks
//      Return: None
//

params ['_z'];

// Also update server on our location
if (alive player) then {
	pubVar_setZone = [player, _z];
	publicVariableServer "pubVar_setZone";
};

if (isServer) then {
	[player, _z] call pubVar_fnc_setZone;
};

if (_z == "") exitWith {};

{
	IF (_z == "globalZone") exitWith {
		GW_CURRENTZONE = _z;
		GW_CURRENTZONE_DATA = [];
	};
	if ((_x select 0) == _z) exitWith {
		GW_CURRENTZONE = _z;
		GW_CURRENTZONE_DATA = _x select 1;
	};
	false
} count GW_ZONES > 0;
