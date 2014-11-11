//
//      Name: generateCategoryList
//      Desc: Creates a list of selectable categories on the buy menu
//      Return: None
//

private ['_startIndex'];

_startIndex = _this select 0;

disableSerialization;
_catList = ((findDisplay 97000) displayCtrl 97012);

lnbClear _catList;

GW_CATEGORY_INDEX = [

	['All', []],
	["Building", GW_LOOT_BUILDING],
	["Weapons", GW_LOOT_WEAPONS],
	["Performance", GW_LOOT_PERFORMANCE],
	["Deployables", GW_LOOT_DEPLOYABLES],
	["Incendiary", GW_LOOT_INCENDIARY],
	["Defence", GW_LOOT_DEFENCE],
	["Evasion", GW_LOOT_EVASION],
	["Electronics", GW_LOOT_ELECTRONICS]

];

_count = 0;
{
	_string = _x select 0;	
	_name = format['      %1', _string];
	
	lbAdd[97012, _name ];	
	lbSetData[97012, 0, _count];

	_count = _count + 1;

	false		

} count GW_CATEGORY_INDEX > 0;

if (!isNil "_startIndex") then {
	lbSetCurSel[97012,_startIndex];
};
