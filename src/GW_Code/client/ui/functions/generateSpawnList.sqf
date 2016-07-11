//
//      Name: generateSpawnList
//      Desc: Creates a list of available spawn locations, shows number of players in that zone
//      Return: None
//

private ['_startIndex', '_type', '_name'];
params ['_startIndex'];

disableSerialization;
_spawnList = ((findDisplay 52000) displayCtrl 52002);

lnbClear _spawnList;

{		
	_id = _x select 0;	
	_type = _x select 1;
	_name = _x select 2;

	if (_type == 'safe') then {} else {

		_vehs = if (_type == 'race') then { [] } else { ([format['%1%2', _id, 'Zone']] call findAllInZone) };
		_string = if (count _vehs > 0) then { format['[%1]', (count _vehs)] } else { '' };
		_name = toUpper (_name);		

		lbAdd [52002,  format[' %1 %2', _name, _string] ];
		lbSetData [52002, _forEachIndex, _name];	

	};
	
} foreach GW_VALID_ZONES;

if (!isNil "_startIndex") then {
	lbSetCurSel[52002,_startIndex];
};