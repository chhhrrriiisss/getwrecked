//
//      Name: registerVehicle
//      Desc: Add a vehicle to the vehicle library (if it doesnt already exist)
//      Return: Bool (Success)
//

private ['_string', '_data'];

_string = [_this,0, "", [""]] call filterParam;
_data = [_this,1, [], [[]]] call filterParam;

if (_string == "" || count _data == 0) exitWith { false };

// Save vehicle data
[_string, _data] call setVehicleData;

// Save to reference library
_lib = [] call getVehicleLibrary;

_exists = false;

{
    if (_x == _string) exitWith {
        _exists = true;
    };
} ForEach _lib;

// If the name doesnt already exist
if (!_exists) then {
    _lib pushback _string;
};   

// Save that data to an open slot
profileNameSpace setVariable[GW_LIBRARY_LOCATION, _lib];
saveProfileNamespace;

true