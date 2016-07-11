/*

    Lists all vehicles in library

*/

private['_raw'];

_raw = [] call getVehicleLibrary;

if (count _raw == 0) exitWith {
	systemChat 'You have no saved vehicles.';
};

_string = 'VEHICLE LIBRARY: \n \n';

{
	if (!(isNil "_x")) then {
		_string = format['%1 %2 \n', _string, _x];
	};

} ForEach _raw;

hint _string;




