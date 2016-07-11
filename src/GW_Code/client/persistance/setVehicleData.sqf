params ['_name', '_data'];
private ['_name', '_data', '_nameWithTag'];

// If data nil, we must be deleting something, right?
if (isNil "_data") exitWith {
    profileNamespace setVariable [format['GW_%1', _name], nil];
    profileNamespace setVariable [_name, nil];
};

// Check for a valid GW_ entry
_hasTag = ['GW_', _name] call inString;

// Has tag, just retrieve as is
if (_hasTag) exitWith { 
    profileNamespace setVariable [_name, _data];
};

// Add a tag, save and delete old data
_nameWithTag = format['GW_%1', _name];
profileNamespace setVariable [_nameWithTag, _data];
profileNamespace setVariable [_name, nil];
