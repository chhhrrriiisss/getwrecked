//
//      Name: findVehicle
//      Desc: Finds a vehicle (unit) object from a string (name of vehicle)
//      Return: Object (the unit)
//

private ['_target', '_result'];

_target = [_this,0, "", [""]] call filterParam;

if (_target == "") exitWith { objNull };

_result = objNull;
_exit = false;
{
	
	if (alive _x) then {
		_name = _x getVariable ['name', ''];
		if (_name isEqualTo _target) exitWith {	_result = _x; _exit = true; }; 
	};
	if (_exit) exitWith {};
	false
}  count allMissionObjects "Car" > 0;

_result