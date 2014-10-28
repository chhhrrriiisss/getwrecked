//
//      Name: cleanDeployList
//      Desc: Prunes the deployable items list to improve performance
//      Return: None
//

// If the current deploy list is greater than the maximum
if ((count GW_DEPLOYLIST) <= GW_MAXDEPLOYABLES) exitWith {};

private ['_count', '_dif'];

// Get the number we need to prune
_dif = ((count GW_DEPLOYLIST) - GW_MAXDEPLOYABLES) -1;

{
	if (_foreachindex > _dif) exitWith {};
	if (!isNil '_x') then {	deleteVehicle _x; };
	GW_DEPLOYLIST set[_foreachindex, 'x'];	
} ForEach GW_DEPLOYLIST;

GW_DEPLOYLIST = GW_DEPLOYLIST - ['x'];

