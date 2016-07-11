//
//      Name: generateFilterList
//      Desc: Updates the list of available vehicles on the preview menu
//      Return: None
//

params ['_startIndex'];

disableSerialization;
_filterList = ((findDisplay 42000) displayCtrl 42003);

lnbClear _filterList;

GW_LIBRARY = [] call getVehicleLibrary;

_count = 0;
{
	
	_data = [_x] call getVehicleData;
	_data = _data select 0;
	_error = false;
	_name = 'NOT AVAILABLE';

	// If data is properly formatted
	if (count _data > 0) then {		

		// Name is valid
		if (count toArray (_data select 1) > 0) then {

			_name = [toUpper (_data select 1), 28, ''] call cropString;
			
			lbAdd[42003, format[' %1', _name] ];	
			lbSetData[42003, (lbSize 42003)-1, _count];

			_count = _count + 1;	

		} else {
			_error = true;		
		};

	} else {
		_error = true;		
	};

	// if (_error) then {
	// 	['delete', _x] spawn listFunctions;
	// };				



	false		

} count GW_LIBRARY >0;

if (!isNil "_startIndex") then {
	lbSetCurSel[42003,_startIndex];
};