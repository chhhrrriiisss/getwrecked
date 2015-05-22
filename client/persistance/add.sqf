//
//      Name: registerVehicle
//      Desc: Add a vehicle to the vehicle library (if it doesnt already exist)
//      Return: Bool (Success)
//

_string = [_this,0, "", [""]] call filterParam;
_data = [_this,1, [], [[]]] call filterParam;

if (_string == "" || count _data == 0) exitWith { false };

// Save that data to an open slot
profileNameSpace setVariable[_string,[_data]];
saveProfileNamespace;

// Save to reference library
_lib = profileNamespace getVariable [ 'GW_LIBRARY', nil];

// If the library does exist
if (!isNil "_lib") then {

    _exists = false;

    {
        if (_x == _string) then {
            _exists = true;
        };

    } ForEach _lib;

    // If the name doesnt already exist
    if (!_exists) then {
        _lib = _lib + [_string];
    };   

}  else {

    _lib = [];
};

// Save that data to an open slot
profileNameSpace setVariable['GW_LIBRARY', _lib];
saveProfileNamespace;

true