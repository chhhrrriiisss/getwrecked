parsePoints = {
	
	private ['_zone', '_mP'];

	_zoneName = _this select 0; // zone to parse
	_array = _this select 1; // array to parse into

	_zoneData = [];
	_pointData = [];

	for "_i" from 0 to 500 step 1 do {	

		_point = getMarkerPos format['%1_%2', _zoneName, _i];

		if (_point distance [0,0,0] <= 0) exitWith {};

		_point set [2, 0];
		_zoneData set [_i, [_point, 0, 0]];
		_pointData pushback _point;
		
	};

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
	[format['%1Zone', (_x select 0)], GW_ZONES] call parsePoints;
	false
} count GW_VALID_ZONES;

GW_ZONE_DEPLOY_TARGETS = [];

{

	_str = (_x select 0);	
	_type = (_x select 1);

	_markers = [format['%1Zone_deploy', _str], false] call findAllMarkers;
	_checkpoints = if (_type == "race") then { [format['%1Zone_checkpoint', _str], false] call findAllMarkers; } else { [] };

	if (count _markers > 0) then {
		GW_ZONE_DEPLOY_TARGETS pushBack [format['%1Zone', _str], _markers, _checkpoints];
	};

	false

} count GW_VALID_ZONES;
