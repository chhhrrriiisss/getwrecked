//
//      Name: destroyObj
//      Desc: Remove an object from a vehicle
//      Return: None
//

private ["_obj", "_veh"];

_obj = [_this,0, objNull, [objNull]] call filterParam;
_effect = [_this,1, false, [false]] call filterParam;

if (isNull _obj) exitWith {};

if (_effect) then {

	[
		[
			_obj,
			0.5
		],
		"muzzleEffect"
	] call gw_fnc_mp;

};

// If its attached to something
_obj setDammage 1;
deleteVehicle _obj;



