//
//      Name: buildZoneBoundary
//      Desc: Generate walls using pre-cached zone point data
//      Return: None
//

if (!GW_BOUNDARIES_ENABLED) exitWith {};
if (isNil "GW_ZONE_BOUNDARIES_CACHED") exitWith { systemchat 'Boundaries have not been cached yet, aborting...'; false };

private ['_zoneName', '_pointsArray', '_bA'];

_zoneName = [_this, 0, "", [""]] call filterParam;
_pointsArray = [_this, 1, [], [[]]] call filterParam;

GW_BOUNDARY_BUILD = nil;

_onExit = {
	GW_BOUNDARY_BUILD = false;
	if (!GW_DEBUG) exitWith {};
    systemChat (_this select 0);    
    false
};

// Bad zone name
if (count toArray _zoneName == 0) exitWith { ['Not a valid zone.'] call _onExit; };

// Global zone doesn't need a boundary
if (_zoneName == "globalZone") exitWith { ['Global zone does not require boundaries.'] call _onExit; };
if (_zoneName == "workshopZone") exitWith { ['Workshop zone does not require boundaries.'] call _onExit; };


_exists = false;
_index = -1;
// If no zone data specified, find it
if (count _pointsArray == 0) then {
	{
		if (isNIl { (_x select 3) }) then { _x set [3, []]; };
		if ((_x select 0) == _zoneName && count (_x select 3) > 0) exitWith { _exists = true; };
		if ((_x select 0) == _zoneName && count (_x select 3) == 0) exitWith { _index = _forEachIndex; _pointsArray = (_x select 2); };		
	} foreach GW_ZONE_BOUNDARIES;
};

// Bad Zone Data
if (_exists) exitWith { ['Boundary exists...'] call _onExit; };
if (isNil "_pointsArray") exitWith { ['Bad point data...'] call _onExit; };
if (count _pointsArray == 0) exitWith { ['Bad point data...'] call _onExit; };
if (_index == -1) exitWith { ['Bad zone index...'] call _onExit; };

// Build the boundaries using supplied point data
_bA = [];
{
	_pos = _x select 0;
	_dirAndUp = _x select 1;

	_wallInside = "UserTexture10m_F" createVehicleLocal _pos; 

	// If we're over water, ensure the wall is placed correctly
	if (surfaceIsWater _pos) then { _wallInside setPosASL _pos; };
	_wallInside setVectorDirAndUp _dirAndUp;
	_wallInside setObjectTexture [0,"client\images\stripes_fade.paa"];
	_wallInside enableSimulation false;

	// Ignore flag for cleanup script (doesnt apply in dedicated since these are only spawned client side)
	_wallInside setVariable ['GW_CU_IGNORE', true];

	_bA pushBack _wallInside;

	false
} foreach _pointsArray;

// Store objects so removeZoneBoundary can delete them later
(GW_ZONE_BOUNDARIES select _index) set [3, _bA];

GW_BOUNDARY_BUILD = true;

if (GW_DEBUG) then { systemchat format['%1 boundaries added.', _zonename]; };

true