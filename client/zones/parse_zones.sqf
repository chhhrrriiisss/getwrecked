parsePoints = {
	
	private ['_zone', '_mP'];

	_zoneName = _this select 0; // zone to parse
	_array = _this select 1; // array to parse into

	_zoneData = [];
	_pointData = [];

	for "_i" from 0 to 999 step 1 do {	

		_str =  format['%1_%2', _zoneName, _i];
		_point = getMarkerPos _str;

		if (_point distance [0,0,0] <= 0) exitWith {};

		_point set [2, 0];
		_zoneData set [_i, [_point, 0, 0]];
		_pointData set[count _pointData, _point];
		
	};

	GW_ZONE_BOUNDARIES set[count GW_ZONE_BOUNDARIES, [_zoneName, _pointData]];

	// Calculate point dirs
	_count = 0;
	_size = (count _zoneData)- 1;
	_prevDir = 0;
	{

		_p = (_x select 0);
		_pData = _x;

		_prev = if (_count == 0) then { _size } else { _count - 1 };
		_next = if (_count >= _size) then { 0 } else { _count + 1 };

		_startDir = [_p, ((_zoneData select _prev) select 0) ] call BIS_fnc_dirTo;
		_endDir = [_p, ((_zoneData select _next) select 0) ] call BIS_fnc_dirTo;

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

	} ForEach _zoneData;

	_zoneContainer = [];
	_zoneContainer set[0, _zoneName];
	_zoneContainer set[1, _zoneData];

	_array set[(count _array), _zoneContainer];

	true

};

GW_ZONE_LIST = [
	'airfieldZone',
	'swampZone',
	'downtownZone',
	'wastelandZone',
	'saltflatZone',
	'workshopZone'
];

GW_ZONES = [];
GW_ZONE_BOUNDARIES = [];

// Calculate point data for each in zone list
{
	[_x, GW_ZONES] call parsePoints;
} ForEach GW_ZONE_LIST;

// Calculate deploy positions for all zones

GW_ZONE_DEPLOY_TARGETS = call {
	
	_arr = [];

	{

		_str = _x;
		_strDeploy = format['%1_deploy', _str];
		_markers = [_strDeploy, false] call findAllMarkers;		

		if (count _markers > 0) then {
			_arr set[count _arr, [_str, _markers]];
		};

	} ForEach GW_ZONE_LIST;

	_arr

};



