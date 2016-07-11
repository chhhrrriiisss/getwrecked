//
//      Name: findCurrentZone
//      Desc: Find Zone location of player or position 
//      Return: Zone (String)
//

private ['_source', '_zoneString', '_d', '_closestDist', '_closestZone'];

_source = [_this, 0, [], [objNull, []]] call filterParam;

// Default to workshop if we've provided a bad location/object as reference
if (_source isEqualType objNull && { isNull _source }) exitWith { "workshopZone" };	
if (_source isEqualType [] && { (count _source == 0) }) exitWith { "workshopZone" };

// Convert reference to a physical location on map
_source = if (_source isEqualType objNull) then {
	if (GW_Client) exitWith { (ASLtoATL visiblePositionASL _source) };
	(ASLtoATL getPosASL _source)
} else {	
	_source
};

// For each zone, find center marker and compare distance
_closestDist = 999999;
_closestZone = "globalZone";

{
	_zoneString = format['%1Zone', (_x select 0)];
	_zoneCenter = format['%1Zone_camera', (_x select 0)];

	_d = _source distance (getMarkerPos _zoneCenter);
	if (_d <= 2000 && _d < _closestDist) then {
		_closestZone = _zoneString;
		_closestDist = _d;
	};
	false
} count GW_VALID_ZONES;

_closestZone