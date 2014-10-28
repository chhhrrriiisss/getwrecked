//
//      Name: destroyObj
//      Desc: Remove an object from a vehicle
//      Return: None
//

private ["_obj", "_veh"];

_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;
if (isNull _obj) exitWith {};

// If its attached to something
if (!isNull attachedTo _obj) then {	

		removeAllActions _obj;
		detach _obj;
		waitUntil { Sleep 0.5; isNull attachedTo _obj; };
		_obj setDammage 1;
		deleteVehicle _obj;

} else {

	_obj setDammage 1;
	deleteVehicle _obj;
};


