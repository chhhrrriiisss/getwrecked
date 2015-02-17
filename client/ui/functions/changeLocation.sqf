//
//      Name: changeLocation
//      Desc: Cycle through available locations via next/prev
//      Return: None
//

disableSerialization;

_value = _this select 0;
_newValue = 0;

_currentIndex = 0;
{
    if ((_x select 0) == GW_SPAWN_LOCATION) exitWith { _currentIndex = _foreachindex; };
} Foreach GW_VALID_ZONES;

_length = ((count GW_VALID_ZONES) - 1);
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

_currentIndex = [_newValue, 0, (count GW_VALID_ZONES - 1), true] call limitToRange;

GW_SPAWN_LOCATION = (GW_VALID_ZONES select _currentIndex) select 0;

if (((GW_VALID_ZONES select _currentIndex) select 1) == "safe") exitWith {
	[_value] spawn changeLocation;
};

[GW_SPAWN_LOCATION] spawn previewLocation;



