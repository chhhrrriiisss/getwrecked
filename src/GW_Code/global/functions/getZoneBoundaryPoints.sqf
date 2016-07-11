//
//      Name: getZoneBoundary
//      Desc: Gather position and dir information for zone boundaries for use in detecting out of zone
//      Return: None
//

_parsePoints = {
	
	private ['_zone', '_mP'];
	params ['_zoneName', '_array'];

	// Get all boundary markers for this zone
	_pointData = [format['%1', _zoneName], false] call findAllMarkers;

	_zoneData = [];
	
	// Push marker point information into prefab array
	{ _zoneData set [_forEachIndex, [_x, 0, 0]]; } foreach _pointData;

	// Push point data to zone
	GW_ZONE_BOUNDARIES pushBack [_zoneName, _pointData];

	// Calculate point dirs
	_count = 0;
	_size = (count _zoneData)- 1;
	_prevDir = 0;
	{

		_p = (_x select 0);
		_pData = _x;

		_prev = if (_count == 0) then { _size } else { _count - 1 };
		_next = if (_count >= _size) then { 0 } else { _count + 1 };

		_startDir = [_p, ((_zoneData select _prev) select 0) ] call dirTo;
		_endDir = [_p, ((_zoneData select _next) select 0) ] call dirTo;

		_dif = [_startDir - _endDir] call flattenAngle;
		_dif = abs (_dif);

		_prevDif = [_prevDir - _endDir] call flattenAngle;

		if (_prevDif > 0) then {
			_dif = [360 - _dif] call normalizeAngle; 
		};

		_prevDir = _endDir;

		_pData set [1, _startDir];
		_pData set [2, _dif];

		_count = _count + 1;

		false
	} count _zoneData;

	_array pushback [_zoneName, _zoneData];

	true

};

GW_ZONES = [];
GW_ZONE_BOUNDARIES = [];

// Calculate point data for each in zone list
{
	[format['%1Zone', (_x select 0)], GW_ZONES] call _parsePoints;
	false
} count GW_VALID_ZONES;

GW_ZONE_DEPLOY_TARGETS = [];

// Parse deploy markers
{

	_str = (_x select 0);	
	_markers = [format['%1Zone_deploy', _str], false] call findAllMarkers;
	if (count _markers > 0) then {	GW_ZONE_DEPLOY_TARGETS pushBack [format['%1Zone', _str], _markers]; };
	false

} count GW_VALID_ZONES;

GW_ZONE_BOUNDARIES_COMPILED = compileFinal "true";