//
//      Name: liftVehicle
//      Desc: Allows a vehicle to be raised above the pad so items can be added below (such as the vertical thruster)
//      Return: None
//

private ['_obj', '_unit', '_type'];

_vehicle = [_this,0, objNull, [objNull]] call filterParam;
_unit = [_this,1, objNull, [objNull]] call filterParam;

if (isNull _vehicle || isNull _unit) exitWith {};

GW_LIFT_ACTIVE = true;
GW_LIFT_VEHICLE = _vehicle;
GW_EDITING = false;

[		
	[
		_vehicle,
		true
	],
	"setObjectSimulation",
	false,
	false 
] call gw_fnc_mp;

// Add the drop vehicle action
removeAllActions _unit;
_unit call setPlayerActions;

_unit addAction [suspendVehicleFormat, {
	GW_LIFT_VEHICLE setVariable ['GW_suspend', true];
	GW_LIFT_ACTIVE = false;
}, [], 0, true, false, "", "( (GW_CURRENTZONE == 'workshopZone') && GW_LIFT_ACTIVE )"];

_unit addAction [dropVehicleFormat, {
	GW_LIFT_VEHICLE setVariable ['GW_suspend', false];
	GW_LIFT_ACTIVE = false;
}, [], 0, true, false, "", "( (GW_CURRENTZONE == 'workshopZone') && GW_LIFT_ACTIVE )"];

_origPosition = (ASLtoATL getPosASL _vehicle);

GW_HOLD_ROTATE_POS = [];
_startAngle = 360;

for "_i" from 0 to 1 step 0 do {

	if ( !alive _vehicle ||  !alive _unit || !GW_LIFT_ACTIVE || GW_EDITING || (_unit in _vehicle) ) exitWith {};

	// Use the camera height to determine how far we should lift the vehicle
	_cameraHeight = (positionCameraToWorld [0,0,0]) select 2;
	_height = (4 - _cameraHeight);
	if (_height < 0) then {	_height = 0; };

	// Use the camera yaw to spin the vehicle when toggle key is down
	if (GW_HOLD_ROTATE) then {

		if (count GW_HOLD_ROTATE_POS > 0) then {

			['ROTATE USING CAMERA', 3, cameraRotateIcon, nil, "flash"] spawn createAlert;   

			_center = worldToScreen getPos _vehicle;
			_adjustedCenter = ((_center select 0)+1);
			if (isNil "_adjustedCenter") then { _adjustedCenter = 0; };

			_vehicle setDir ([(360 * _adjustedCenter) + (_startAngle)] call normalizeAngle);			

		} else { _startAngle = getDir _vehicle; };

		GW_HOLD_ROTATE_POS = (ASLtoATL getPosASL _vehicle);

	} else {
		GW_HOLD_ROTATE_POS = []; 
	};

	_origPosition set[2, _height];
	_vehicle setPos _origPosition;

	Sleep 0.1;

};

if ( GW_LIFT_VEHICLE getVariable ['GW_suspend', true] ) then {

	_vehicle setVariable ['GW_IGNORE_SIM', true];
	[		
		[
			_vehicle,
			false
		],
		"setObjectSimulation",
		false,
		false 
	] call gw_fnc_mp;

} else {

	_vehicle setVariable ['GW_IGNORE_SIM', false];
	
	[		
		[
			_vehicle,
			true
		],
		"setObjectSimulation",
		false,
		false 
	] call gw_fnc_mp;

};

GW_LIFT_ACTIVE = false;