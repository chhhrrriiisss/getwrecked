//
//      Name: generateAttributesList
//      Desc: Creates a list of information about a vehicle in the new/create menu
//      Return: None
//

private ['_display', '_control', '_v', '_vehicleStats', '_dist'];
params ['_target'];

disableSerialization;
_statsList = ((findDisplay 96000) displayCtrl 96002);
_description  = ((findDisplay 96000) displayCtrl 96005);

// Make sure we're starting from scratch
lnbClear _statsList;

_vehicleInfo = [_target, GW_VEHICLE_LIST] call getData;
if (isNil "_vehicleInfo") exitWith {};
	
_data = _vehicleInfo select 2;
_cost = _target call getCost;

{	

	_colA = (_x select 0);
	_colB = (_x select 1);
	_statsList lnbAddRow['', (_colA select 0), '', (_colB select 0)];
	_statsList lnbSetPicture[[((((lnbSize 96002) select 0)) -1),0], (_colA select 1)];
	_statsList lnbSetPicture[[((((lnbSize 96002) select 0)) -1),2], (_colB select 1)];
	false

} count [
	// For each entry, create two columns and a row
	[ [(format['%1 weapons', (_data select 1)]),  hmgTargetIcon], [(format['%1 modules', (_data select 2)]), nitroIcon] ],
	[ [(format['%1%2', (_data select 3) * 100, '%']), ammoIcon], [(format['%1L', (_data select 4) * 100]), fuelIcon] ],
	[ [(format['%1', (_data select 5)]),armourIcon], [(format['%1', (_data select 7)]), radarIcon] ]		

] > 0;

_description ctrlSetStructuredText parseText ( format["<t size='1' align='left'>%1</t>", (_vehicleInfo select 3)] );
_description ctrlCommit 0;