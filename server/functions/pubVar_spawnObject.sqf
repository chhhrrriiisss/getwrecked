//
//      Name: pubVar_spawnObject
//      Desc: Spawn an object at the desired location
//      Return: None
//

_this spawn {

	private["_type", "_pos"];
	
	_type = [_this,0, "", [""]] call BIS_fnc_param;	
	_pos = [_this,1, [], [[]]] call BIS_fnc_param;
	_exact = [_this,2, false, [false]] call BIS_fnc_param;

	if (_type == "" || count _pos == 0) exitWith {};

	_frame = if (_exact) then { "CAN_COLLIDE" } else { "NONE" };

	_newObj = [_pos, 0, _type, 0, "NONE", false] call createObject;

	[_newObj] spawn setObjectCleanup;

};