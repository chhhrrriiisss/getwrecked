//
//      Name: prepareVehicleDeploy
//      Desc: Prepares vehicle for deployment, resetting actions, wanted value, simulation
//      Return: None
//

params ['_vehicle'];
private ['_vehicle', '_unit'];

//
//      Name: initVehicleDeploy
//      Desc: Initialize vehicle once deployed
//      Return: None
//

_unit = driver _vehicle;
_unit action ["engineoff", _vehicle];

_stripActions = {
	removeAllActions _this;
	_this setVariable ['tag', nil];
	_this setVariable ['hasActions', false];
	true	
};

// Clean vehicle of invalid parts
_vehicle call cleanAttached;

// Get rid of excess addActions
{ 
	_x call _stripActions;

	// Disable fuel on napalm bombs
	if (typeof _x == "FlexibleTank_01_forest_F") then { _x setFuelCargo 0; };

	false
} count (attachedObjects _vehicle) > 0;

// Clear/Unsimulate unnecessary items near workshop
{
	_x call _stripActions;
	if (simulationEnabled _x) then { _x enableSimulation false; };
	false
} count (nearestObjects [ (getMarkerPos "workshopZone_camera"), [], 200]) > 0;

// Trigger get-in event handler
[_vehicle, 'driver', _unit] call handleGetIn;

// Add handlers for vehicle
_hasHandlers = _vehicle getVariable ['hasHandlers', false];
if (!_hasHandlers) then { [_vehicle] call setVehicleHandlers; };

// Unhide vehicle and all attachments
pubVar_setHidden = [_vehicle, false];
publicVariable "pubVar_setHidden";
_vehicle hideObject false;
_vehicle setVariable ['GW_HIDDEN', nil, true];

// Update simulation for all clients
[		
	[
		_vehicle,
		true
	],
	"setObjectSimulation",
	false,
	false 
] call bis_fnc_mp;

// Set wanted value
_vehicle setVariable ['GW_WantedValue', 0];

// Unlock driver, apply temp invulnerable status
_vehicle setVehicleLock "UNLOCKED";
[_vehicle, 2] spawn dustCircle;
[_vehicle, ['invulnerable', 'nolock', 'nofire', 'nofork'], 10] call addVehicleStatus;
