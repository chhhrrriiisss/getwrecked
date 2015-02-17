//
//      Name: deployVehicle
//      Desc: Prepares vehicle for deployment, checks for empty areas and fail conditions
//      Return: None
//

if (GW_DEPLOY_ACTIVE) exitWith {
	systemChat 'Cant deploy more than one vehicle at once.';
	false
};

GW_DEPLOY_ACTIVE = true;

private ['_pad', '_unit', '_location'];

_targetVehicle = _this select 0;
_targetName = _targetVehicle getVariable ['name', ''];

GW_LASTLOAD = _targetName;

_unit = _this select 1;
_location = _this select 2;

_zoneType = "battle";
_deployData = [];

// Determine the deploy locations and properties
_targetPosition = if (typename _location == "ARRAY") then { _location } else {

	{
		if ((_x select 0) == GW_SPAWN_LOCATION) exitWith {
			_zoneType = (_x select 1);
		};
		false
	} count GW_VALID_ZONES > 0;

	// Get the list of deployment locations	
	{
		if ((_x select 0) == format['%1Zone', GW_SPAWN_LOCATION]) exitWith {	
			_deployData = (_x select 1);
		};
		false
	} count GW_ZONE_DEPLOY_TARGETS > 0;		

	_rangeCheck = _zoneType call {
		if (_this == "battle") exitWith { 150 };
		if (_this == "race") exitWith { 4 };
		5
	};

	// Find a new, empty location from that data
	_targetPosition = [_deployData, ["Car", "Man"], _rangeCheck] call findEmpty;
	_targetPosition set [2, _rangeCheck];
	_targetPosition
};

// If location is null (debug) dont deploy 
if ( (_targetPosition distance [0,0,0]) <= 1000) exitWith {
	systemChat 'No deploy locations available.';
	GW_DEPLOY_ACTIVE = false;
	false
};

_unit action ["engineoff", _targetVehicle];

[_targetVehicle, ['invulnerable', 'nolock', 'nofire'], 20] call addVehicleStatus;

_targetPosition set [2, 5];
_targetVehicle setPos _targetPosition;
_targetVehicle setDir (random 360);
[format['%1Zone', GW_SPAWN_LOCATION]] call setCurrentZone;

_stripActions = {
	removeAllActions _this;
	_this setVariable ['tag', nil];
	_this setVariable ['hasActions', false];
	true	
};
// Get rid of excess addActions
{ 
	_x call _stripActions;
	false
} count (attachedObjects _targetVehicle) > 0;

// Clear/Unsimulate unnecessary items near workshop
{
	_x call _stripActions;
	if (simulationEnabled _x) then {
		_x enableSimulation false;
	};

	false
} count (nearestObjects [ (getMarkerPos "workshopZone_camera"), [], 250]) > 0;

// Add handlers for vehicle
_hasHandlers = _targetVehicle getVariable ['hasHandlers', false];
if (!_hasHandlers) then {
	[_targetVehicle] call setVehicleHandlers;
};

// Add handlers for objects
{
	_h = _x getVariable ['hasHandlers', false];
	if (!_h) then {
		[_x] call setObjectHandlers;
	};
	false
} count (attachedObjects _targetVehicle) > 0;

// Update simulation for all clients
[		
	[
		_targetVehicle,
		true
	],
	"setObjectSimulation",
	false,
	false 
] call BIS_fnc_MP;

// Set wanted value
_targetVehicle setVariable ['GW_WantedValue', 0];

_targetVehicle lockDriver false;
[_targetVehicle, 2] spawn dustCircle;
[_targetVehicle, ['invulnerable', 'nolock', 'nofire'], 10] call addVehicleStatus;

// Everything is ok, return true
GW_DEPLOY_ACTIVE = false;

// Tell everyone else where we've gone
_str = if (GW_SPAWN_LOCATION == "downtown") then { "" } else { "the "};
systemChat format['You deployed to %1%2.', _str, GW_SPAWN_LOCATION];

_strBroadcast = format['%1 deployed to %2%3', GW_PLAYERNAME, _str, GW_SPAWN_LOCATION];
pubVar_systemChat = _strBroadcast;
publicVariable "pubVar_systemChat";

pubVar_logDiag = _strBroadcast;
publicVariableServer "pubVar_logDiag";

true