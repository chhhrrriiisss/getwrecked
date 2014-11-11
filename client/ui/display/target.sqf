//
//      Name: targetCursor
//      Desc: Handles the look of the cursor target while in a vehicle
//      Return: None
//

private ['_pos', '_col', '_scale', '_icon', '_limit', '_vehDir'];

_vehicle = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _vehicle) exitWith {};
if (!alive _vehicle) exitWith {};

_unit = player;

// Get all the camera information we need
GW_CAMERA_HEADING = [(positionCameraToWorld [0,0,0]), (positionCameraToWorld [0,0,1])] call BIS_fnc_vectorDiff;
GW_TARGET_DIRECTION = [(positionCameraToWorld [0,0,0]), (positionCameraToWorld [0,0,4])] call BIS_fnc_dirTo;
GW_MAX = positionCameraToWorld [0,0,2000];
GW_MIN = positionCameraToWorld [0,0,500];
GW_ORIGIN = (ASLtoATL getPosASL _vehicle);
GW_SCREEN = screenToWorld [0.5, 0.5];

// Determine which target marker to use
// Resolution of aim and ballistics is still very much a WIP
GW_TARGET = GW_MIN;
_terrainIntersect = terrainIntersect [(positionCameraToWorld [0,0,0]), GW_MIN];
_heightAboveTerrain = (GW_ORIGIN) select 2;

if (GW_DEBUG) then { [GW_ORIGIN, GW_SCREEN, 0.1] spawn debugLine; };

if (_terrainIntersect || _heightAboveTerrain > 3) then { GW_TARGET = GW_SCREEN; };

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
	'FLM'
];

_count = 0;
{

	_type = _x select 0;
	_obj = _x select 1;

	_defaultDir = _obj getVariable ["defaultDirection", 0];

	// Flip it around to the correct side if laser
	_defaultDir = if (_type == "LSR" || _type == "FLM") then { ([_defaultDir + 180] call normalizeAngle) } else { _defaultDir };

	// Corrected angle based off of vehicle direction
	_actualDir = [GW_TARGET_DIRECTION - _vehDir] call normalizeAngle;	

	// Difference between these two
	_dif = abs ( [_actualDir - _defaultDir] call flattenAngle );

	if ( (_dif < _limit) && _type in _allowedWeapons) then {		

		if (true) then {

			GW_AVAIL_WEAPONS pushback [_obj, _type];
			_col = [1,1,1,0.75];

			// Decide on the icon to use for each weapon
			_icon = switch (_type) do {
				case "HMG":	{ hmgTargetIcon };
				case "RLG":	{ hmgTargetIcon };			
				case "LSR":	{ hmgTargetIcon };				
				case "RPG":	{ rpgTargetIcon };				
				case "MIS":	{ rpgTargetIcon };				
				case "MOR":	{ rangeTargetIcon };				
				case "GMG":	{ rangeTargetIcon };	
				case "FLM":	{ rpgTargetIcon };				
				default	{ noTargetIcon };			
			};

			_count = _count + 1;

		};

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
if (GW_DEBUG) then {_canShoot = true; };

// Mouse shooting
if (GW_LMBDOWN && _canShoot && !GW_WAITFIRE) then {

	_scale = 1.5;
	_col = [1,1,1,1];	
	_availTypes = [];
	
	{
		_type = _x select 1;
		if ( !(_type in _availTypes) ) then { _availTypes pushBack _type; };
		GW_ACTIVE_WEAPONS pushback (_x select 0);
		false
	} count GW_AVAIL_WEAPONS > 0;

	{
		[_x, _vehicle, "AUTO"] spawn fireAttached;
		false
	} count _availTypes > 0;
};

_pos = _vehicle modelToWorld [0,40,0];
drawIcon3D [vehicleTargetIcon, [1,1,1,0.5], _pos, 1.25, 1.25, 0];	
drawIcon3D [_icon, _col, GW_TARGET, _scale, _scale, 0];	