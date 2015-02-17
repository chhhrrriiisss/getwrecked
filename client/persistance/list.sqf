/*

    Loads a vehicle with specified name

*/
private['_raw'];

_raw = profileNamespace getVariable ['GW_LIBRARY', []];

if (count _raw > 0) then {	
	
	_string = 'Available vehicles: ';

	{
		if (!(isNil "_x")) then {
			_string = format['%1 %2', _string, _x];
		};

	} ForEach _raw;

	hint _string;
	
} else {

	systemChat 'You have no saved vehicles.';

};
