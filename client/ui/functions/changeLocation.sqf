//
//      Name: changeLocation
//      Desc: Cycle through available locations via next/prev
//      Return: None
//
private ['_allZones', '_currentIndex', '_type'];
params ['_value'];

disableSerialization;

_newValue = 0;

_allZones = GW_VALID_ZONES;

_currentIndex = 0;
{
    if ((_x select 0) == GW_SPAWN_LOCATION) exitWith {_currentIndex = _foreachindex; };
} Foreach _allZones;

_length = ((count _allZones) - 1);
_type = typename _value;

if (_type == "STRING") then {

	switch (_value) do {
		case "null": { _newValue = _currentIndex; };
		case "next": { _newValue = _currentIndex + 1; };
		case "prev": { _newValue = _currentIndex - 1; };
		default { _newValue = _currentIndex; };
	};

} else {
	_newValue = _value;
};

_currentIndex = [_newValue, 0, (count _allZones - 1), true] call limitToRange;

GW_SPAWN_LOCATION = (_allZones select _currentIndex) select 0;
_typeOfZone = (_allZones select _currentIndex) select 1;
_displayName = (_allZones select _currentIndex) select 2;

if (_typeOfZone == "safe") exitWith {
	[_value] spawn changeLocation;
};

[GW_SPAWN_LOCATION, _displayName, _typeOfZone] spawn previewLocation;



