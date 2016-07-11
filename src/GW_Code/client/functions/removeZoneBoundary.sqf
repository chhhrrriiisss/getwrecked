if (!GW_BOUNDARIES_ENABLED) exitWith { false };

private ['_zoneName'];

_zoneName = [_this, 0, "", [""]] call filterParam;

_onExit = {
	if (!GW_DEBUG) exitWith {};
    systemChat (_this select 0);    
    false
};

// Bad zone name
if (count toArray _zoneName == 0) exitWith { ['Bad zone name specified.'] call _onExit; };

// Global zone doesn't need a boundary
if (_zoneName == "globalZone") exitWith { FALSE };

// Retrieve boundary data for zone
_boundaries = [];
_index = -1;
{

	if ((_x select 0) == _zoneName && count (_x select 3) > 0) exitWith { _index = _forEachIndex; _boundaries = (_x select 3); };
} foreach GW_ZONE_BOUNDARIES;

if (count _boundaries == 0 || _index == -1) exitWith { ['Bad zone index or object array.'] call _onExit; };

{
	deleteVehicle _x;	
} foreach _boundaries;

(GW_ZONE_BOUNDARIES select _index) set [3, []];

if (GW_DEBUG) then { systemchat format['Deleted boundaries at %1', _zoneName]; };

false
