//
//      Name: targetCursor
//      Desc: Handles the look of the cursor target while in a vehicle
//      Return: None
//

private ['_pos', '_col', '_scale', '_icon', '_limit', '_vehDir', '_vehicle'];

// Not in a race/battle
if (GW_CURRENTZONE == "workshopZone") exitWith {};
	
// Dialogs open, abort
if (GW_SETTINGS_ACTIVE || GW_SPECTATOR_ACTIVE || GW_TITLE_ACTIVE) exitWith {};

// Source vehicle isn't available
if (isNull GW_CURRENTVEHICLE) exitWith {};
if (!alive GW_CURRENTVEHICLE) exitWith {};

_vehicle = GW_CURRENTVEHICLE;
_unit = player;

IF (vectorUp _vehicle distance [0,0,1] > 1) exitWith {};

// Get all the camera information we need
_cameraPosition = positionCameraToWorld [0,0,0];
// GW_TARGET_DIRECTION = [(_cameraPosition), (positionCameraToWorld [0,0,4])] call dirTo;

GW_TARGET_DIRECTION = [GW_CURRENTPOS, screenToWorld [0.5, 0.5]] call dirTo;

GW_CAMERA_HEADING = [ATLtoASL  positionCameraToWorld[0,0,-4], ATLtoASL positionCameraToWorld[0,0,10]] call BIS_fnc_vectorFromXToY;
GW_VEHICLE_HEADING = [(GW_CURRENTVEHICLE modelToWorldVisual [0,0,0]), (GW_CURRENTVEHICLE modelToWorldVisual [0,4,0])] call bis_fnc_vectorFromXToY;

GW_TARGET = positionCameraToWorld [0,0,1000];
GW_ORIGIN = positionCameraToWorld [0,0,0];

_intersects = lineIntersectsSurfaces [ATLtoASL GW_ORIGIN, ATLtoASL GW_TARGET, (vehicle player), objNull, FALSE, 1];
if (count _intersects > 0) then { GW_TARGET = ASLtoATL ((_intersects select 0) select 0); };

if (GW_DEBUG) then { [GW_ORIGIN, GW_TARGET, 0.1] spawn debugLine; };

// Determine available weapons from camera direction
_weaponsList = _vehicle getVariable ["weapons", []];

_icon = noTargetIcon;
_col = [0.99,0.14,0.09,1];
_col set[3, 0.5];
_scale = 1.7;

_count = 0;
_lastWeapon = "";
_hasFired = false;

if ('cloak' in GW_VEHICLE_STATUS || 'noshoot' in GW_VEHICLE_STATUS) exitWith {

	_pos = _vehicle modelToWorldVisual [0,40,0];
	drawIcon3D [vehicleTargetIcon, [1,1,1,0.5], _pos, 1.25, 1.25, 0];	
	_icon = if ('cloak' in GW_VEHICLE_STATUS) then { hiddenIcon } else { _icon };
	drawIcon3D [_icon, _col, GW_TARGET, _scale, _scale, 0];	
};

// Reset the available weapons each pass
GW_AVAIL_WEAPONS = [];


{

	if (GW_WAITFIRE) exitWith {};

	_type = _x select 0;

	if ( !(_type in GW_FIREABLE_WEAPONS) ) exitWith {};		

	_obj = _x select 1;	

	if (true) then {
		
		// Angle difference between camera and weapon
		_defaultDir = _obj getVariable ["GW_defaultDirection", 0];
		_actualDir = [GW_TARGET_DIRECTION - GW_CURRENTDIR] call normalizeAngle;	
		if (abs ( [_actualDir - _defaultDir] call flattenAngle ) > 30 ) exitWith {};

		_col = [1,1,1,0.7];
		_count = _count + 1;	
		_lastWeapon = _type;	

		_bind = _obj getVariable ['GW_KeyBind', ["-1", "1"]];
		_bind = if (_bind isEqualType []) then { (_bind select 1) } else { _bind };	
		GW_AVAIL_WEAPONS pushback [_obj, _type, _bind];

		// Only fire mouse bound weapons
		if (GW_LMBDOWN) exitWith {

			if (_bind != "1") exitWith {};

			_hasFired = true;
			[_type, _vehicle, _obj] call fireAttached;

		};	

	};

	false
} count _weaponsList > 0;

// For multiple weapons, just use the default
_icon = if (_count > 1) then {
	targetIcon;
} else {
	(_lastWeapon call getWeaponIcon)
};

['Can Shoot', true] call logDebug;

// Mouse shooting
if (_hasFired) then {
	_scale = 1.5;
	_col = [1,1,1,1];	
};

_pos = _vehicle modelToWorldVisual [0,40,0];
drawIcon3D [vehicleTargetIcon, [1,1,1,0.5], _pos, 1.25, 1.25, 0];	
drawIcon3D [_icon, _col, GW_TARGET, _scale, _scale, 0];	