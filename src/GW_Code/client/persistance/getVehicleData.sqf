params ['_loadTarget'];
private ['_loadTarget', '_raw', '_rawWithTag', '_loadTargetWithTag'];

// Check for a valid GW_ entry
_hasTag = ['GW_', _loadTarget] call inString;

// Has tag, just retrieve as is
if (_hasTag) exitWith { (profileNamespace getVariable [_loadTarget, []]) };

// Check for a valid GW_ entry
_loadTargetWithTag = format['GW_%1', _loadTarget];
_rawWithTag = profileNamespace getVariable [_loadTargetWithTag, nil];

// Also see if there is a old-method entry
_raw = profileNamespace getVariable [ _loadTarget, nil];    

// Rename old entry to new entry (if exists)
if (!isNil "_rawWithTag" && !isNil "_raw") exitWith { 
    profileNameSpace setVariable[_loadTarget, nil]; 
    _rawWithTag
};

// Otherwise use new entry
if (!isNil "_rawWithTag") exitWith { _rawWithTag  };

// Otherwise resave old entry to new format and delete
if (!isNil "_raw") exitWith { 
    profileNameSpace setVariable[_loadTargetWithTag, _raw]; 
    profileNameSpace setVariable[_loadTarget, nil]; 
    _raw
};    

[]