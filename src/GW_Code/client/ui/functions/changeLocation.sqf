//
//      Name: changeLocation
//      Desc: Cycle through available locations via next/prev
//      Return: None
//
private ['_allZones', '_currentIndex', '_type'];
params ['_value'];

disableSerialization;

_currentIndex = 0;
{
    if ((_x select 0) == GW_SPAWN_LOCATION) exitWith { _currentIndex = _foreachindex; };
} Foreach GW_VALID_ZONES;

_newIndex = [_currentIndex + _this, 0, (count GW_VALID_ZONES) - 1, true] call limitToRange;

_typeOfZone = (GW_VALID_ZONES select _newIndex) select 1;
if (_typeOfZone == "safe") exitWith {
	_newIndex+_this call changeLocation;
};

disableSerialization;
_list = ((findDisplay 52000) displayCtrl 52002);	
_list lbSetCurSel _newIndex;

_newIndex call previewLocation;




