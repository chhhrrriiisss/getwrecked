//
//      Name: targetCursor
//      Desc: Handles the look of the cursor target while in a vehicle
//      Return: None
//

private ['_pos', '_col', '_scale', '_icon', '_limit', '_vehDir', '_vehicle'];

if (isNull GW_CURRENTVEHICLE) exitWith {};
if (!alive GW_CURRENTVEHICLE) exitWith {};

_vehicle = GW_CURRENTVEHICLE;

_unit = player;

IF (vectorUp _vehicle distance [0,0,1] > 1) exitWith {};

// Get all the camera information we need
GW_CAMERA_HEADING = [(positionCameraToWorld [0,0,0]), (positionCameraToWorld [0,0,1])] call BIS_fnc_vectorDiff;
GW_TARGET_DIRECTION = [(positionCameraToWorld [0,0,0]), (positionCameraToWorld [0,0,4])] call dirTo;
GW_MAX = positionCameraToWorld [0,0,2000];
GW_MIN = positionCameraToWorld [0,0,500];
GW_ORIGIN = (ASLtoATL visiblePositionASL _vehicle);
GW_SCREEN = screenToWorld [0.5, 0.5];

// Determine which target marker to use
// Resolution of aim and ballistics is still very much a WIP
GW_TARGET = GW_MIN;
_terrainIntersect = terrainIntersect [(positionCameraToWorld [0,0,0]), GW_MIN];
_heightAboveTerrain = (GW_ORIGIN) select 2;

if (_terrainIntersect || _heightAboveTerrain > 3) then { GW_TARGET = GW_SCREEN; };
if (GW_DEBUG) then { [GW_ORIGIN, GW_TARGET, 0.1] spawn debugLine; };

GW_TARGET = positionCameraToWorld [0,0,200];
// _terrainIntersect = terrainIntersect [(positionCameraToWorld [0,0,0]), GW_TARGET];
// if (_terrainIntersect) then { GW_TARGET = positionCameraToWorld [0,0,300]; };

_vehDir = getDir _vehicle;

// Determine available weapons from camera direction
_weaponsList = _vehicle getVariable ["weapons", []];
_availWeapons = [];
_limit = 30;
_icon = noTargetIcon;
_col = [0.99,0.14,0.09,1];
_col set[3, 0.5];
_scale = 1.7;

// Reset the available weapons each pass
GW_AVAIL_WEAPONS = [];

// List of weapons that are fired when left clicking
_allowedWeapons = [
	'HMG',
	'MOR',
	'GMG',
	'MIS',
	'RPG',
	'LSR',
	'RLG',
	'FLM',
	'HAR',
	'GUD',
	'LMG',
	'RPD'
];

_count = 0;
{

	_type = _x select 0;
	_obj = _x select 1;

	_defaultDir = _obj getVariable ["GW_defaultDirection", 0];

	// Custom target offsets for different items
	_defaultDir = [_type, _defaultDir] call {
		params ['_tag'];
		if (_tag == "LSR" || _tag == "FLM") exitWith { ([(_this select 1) + 180] call normalizeAngle) };
		if (_tag == "RPD") exitWith { ([(_this select 1) -90] call normalizeAngle) };
		(_this select 1)
	};

	// Corrected angle based off of vehicle direction
	_actualDir = [GW_TARGET_DIRECTION - _vehDir] call normalizeAngle;	

	// Difference between these two
	_dif = abs ( [_actualDir - _defaultDir] call flattenAngle );

	if ( (_dif < _limit) && _type in _allowedWeapons || (_type in GW_LOCKONWEAPONS)) then {	

		// Only add weapons that are mouse bound to active weapons list
		_bind = _obj getVariable ['GW_KeyBind', ["-1", "1"]];
		_bind = if (typename _bind == "ARRAY") then { (_bind select 1) } else { _bind };

		GW_AVAIL_WEAPONS pushback [_obj, _type, _bind];
		_col = [1,1,1,0.75];

		// Decide on the icon to use for each weapon
		_icon = _type call {

			if (_this == "HMG") exitWith { hmgTargetIcon };
			if (_this == "RLG") exitWith { hmgTargetIcon };
			if (_this == "LSR") exitWith { hmgTargetIcon };
			if (_this == "RPG") exitWith { rpgTargetIcon };
			if (_this == "MIS") exitWith { rpgTargetIcon };
			if (_this == "GUD") exitWith { rpgTargetIcon };
			if (_this == "MOR") exitWith { rangeTargetIcon };
			if (_this == "GMG") exitWith { rangeTargetIcon };
			if (_this == "FLM") exitWith { rpgTargetIcon };
			if (_this == "HAR") exitWith { rangeTargetIcon };
			if (_this == "LMG") exitWith { hmgTargetIcon };
			if (_this == "RPD") exitWith { rpgTargetIcon };
			noTargetIcon
		};
		
		_count = _count + 1;		

	};
	false
} count _weaponsList > 0;

// For multiple weapons, just use the default
if (_count > 1) then {
	_icon = targetIcon;
};

// Weapons that can be fired
GW_ACTIVE_WEAPONS = [];

// Are we actually able to shoot?
_status = _vehicle getVariable ["status", []];
_canShoot = if (!GW_SETTINGS_ACTIVE && (count GW_AVAIL_WEAPONS > 0) && !GW_WAITFIRE && !('cloak' in _status) && GW_CURRENTZONE != "workshopZone") then { true } else { false };

['Can Shoot', true] call logDebug;

// Mouse shooting
if (GW_LMBDOWN && _canShoot && !GW_WAITFIRE) then {

	_scale = 1.5;
	_col = [1,1,1,1];	

	{
		if (format['%1', (_x select 2)] == "1") then {
			[(_x select 1), _vehicle, (_x select 0)] spawn fireAttached;
		};

		false
	} count GW_AVAIL_WEAPONS > 0;
};

_pos = _vehicle modelToWorldVisual [0,40,0];
drawIcon3D [vehicleTargetIcon, [1,1,1,0.5], _pos, 1.25, 1.25, 0];	
drawIcon3D [_icon, _col, GW_TARGET, _scale, _scale, 0];	