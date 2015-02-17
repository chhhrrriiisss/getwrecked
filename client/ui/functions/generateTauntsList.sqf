//
//      Name: generateTauntsList
//      Desc: Creates a list of available taunts for the vehicle settings dialog
//      Return: None
//

disableSerialization;
_tauntsList = (findDisplay 92000) displayCtrl 92006;
lnbClear _tauntsList;

_currentTaunt = GW_SETTINGS_VEHICLE getVariable ['GW_Taunt', ''];
_currentTaunt = if (typename _currentTaunt == "ARRAY") then { '' } else { _currentTaunt };

_index = 0;

lbAdd [92006,  format[' %1', 'NONE'] ];	
lbSetData [92006, 0, 'none'];

{
	_name = _x;
	if (_name == _currentTaunt) then { _index = (_foreachindex + 1); };
	lbAdd [92006,  format[' %1', toUpper(_name)] ];	
	lbSetData [92006, _foreachindex, _name];

} Foreach GW_TAUNTS_LIST;

lbSetCurSel[92006,_index];