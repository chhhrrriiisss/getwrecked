//
//      Name: handleDisassembledObject
//      Desc: Handle items being disassembled
//      Return: None
//

deleteVehicle (_this select 1);
deleteVehicle (_this select 2);

_pos = getPosATL _unit;
_type = if ((typeOf _unit) == "groundWeaponHolder") then { _unit getVariable "type" } else { typeOf _unit };

if (!isServer) then {

	pubVar_spawnObject = [_type, _pos];
	publicVariableServer "pubVar_spawnObject"; 	

} else {	
	[_pos, 0, _type, 0, "NONE", false] call createObject;
};

