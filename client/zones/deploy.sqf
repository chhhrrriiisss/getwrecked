//
//      Name: deployVehicle
//      Desc: Prepares vehicle for deployment, checks for empty areas and fail conditions
//      Return: None
//

if (GW_DEPLOY_ACTIVE) exitWith {
	systemChat 'Cant deploy more than one vehicle at once.';
};

GW_DEPLOY_ACTIVE = true;

private ['_pad', '_unit', '_location'];

_targetVehicle = _this select 0;
_unit = _this select 1;
_location = _this select 2;

// Determine the deploy locations
_targetPosition = if (typename _location == "ARRAY") then { _location } else {

	// Get the list of deployment locations
	_deployData = [];
	{
		if ((_x select 0) == format['%1Zone', GW_SPAWN_LOCATION]) exitWith {
			_deployData = _x select 1;
		};
		false
	} count GW_ZONE_DEPLOY_TARGETS > 0;		

	// Find a new, empty location from that data
	_targetPosition = [_deployData, ["Car", "Man"], 150] call findEmpty;
	_targetPosition set [2, 100];
	_targetPosition
};

// If location is null (debug) dont deploy 
if ( (_targetPosition distance [0,0,0]) <= 1000) exitWith {
	systemChat 'No deploy locations available.';
	GW_DEPLOY_ACTIVE = false;
	false
};

[format['%1Zone', GW_SPAWN_LOCATION]] call setCurrentZone;
_unit action ["engineoff", _targetVehicle];

[_unit, _targetVehicle, _targetPosition] spawn parachuteVehicle;

// Everything is ok, return true
GW_DEPLOY_ACTIVE = false;

// Make sure we record a successful deploy
['deploy', _targetVehicle, 1] spawn logStat; 

true