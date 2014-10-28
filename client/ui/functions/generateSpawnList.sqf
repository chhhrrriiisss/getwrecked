//
//      Name: generateSpawnList
//      Desc: Creates a list of available spawn locations, shows number of players in that zone
//      Return: None
//

private ['_startIndex'];

_startIndex = _this select 0;

disableSerialization;
_spawnList = ((findDisplay 52000) displayCtrl 52002);

lnbClear _spawnList;

{		
	_name = _x;	
	_vehs = [format['%1%2', _name, 'Zone']] call findAllInZone;
	_string = if (count _vehs > 0) then { format['[%1]', (count _vehs)] } else { '' };
	_name = toUpper (_name);		

	lbAdd [52002,  format[' %1 %2', _name, _string] ];	
	false
} count GW_VALID_ZONES > 0;

if (!isNil "_startIndex") then {
	lbSetCurSel[52002,_startIndex];
};