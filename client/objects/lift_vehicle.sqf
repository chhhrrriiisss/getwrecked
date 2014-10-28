//
//      Name: liftVehicle
//      Desc: Allows a vehicle to be raised above the pad so items can be added below (such as the vertical thruster)
//      Return: None
//

private ['_obj', '_unit', '_type'];

_vehicle = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_unit = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _vehicle || isNull _unit) exitWith {};

GW_LIFT_ACTIVE = true;
GW_EDITING = false;

[		
	[
		_vehicle,
		true
	],
	"setObjectSimulation",
	false,
	false 
] call BIS_fnc_MP;

// Add the drop vehicle action
removeAllActions player;
player addAction [dropVehicleFormat, {
	GW_LIFT_ACTIVE = false;
}, [], 0, true, false, "", "( (GW_CURRENTZONE == 'workshopZone') && GW_LIFT_ACTIVE )"];

_origPosition = getPosATL _vehicle;

while {alive _vehicle && alive _unit && GW_LIFT_ACTIVE && !GW_EDITING && !(player in _vehicle)} do {

	// Use the camera height to determine how far we should lift the vehicle
	_cameraHeight = (positionCameraToWorld [0,0,0]) select 2;
	_height = (4 - _cameraHeight);
	if (_height < 0) then {	_height = 0; };

	_origPosition set[2, _height];
	_vehicle setPos _origPosition;

	Sleep 0.1;

};

_height = (ASLtoATL (getPosASL _vehicle)) select 2;
_simulation = (simulationEnabled _vehicle);

// If the vehicle is far enough of the deck, disable everything!
if (_height > 1) then {

	if (_simulation) then {

		[		
			[
				_vehicle,
				false
			],
			"setObjectSimulation",
			false,
			false 
		] call BIS_fnc_MP;

	};

	if (!(lockedDriver _vehicle)) then {
		_vehicle lockDriver true;
	};

	if (!(_vehicle lockedCargo 0)) then {
		_vehicle lockCargo true;
	};
};

// If the vehicle is basically on the ground, re-enable everything!
if (_height <= 1) then {

	if (!_simulation) then {

		[		
			[
				_vehicle,
				true
			],
			"setObjectSimulation",
			false,
			false 
		] call BIS_fnc_MP;

	};

	if (lockedDriver _vehicle) then {
		_vehicle lockDriver false;
	};

	if (_vehicle lockedCargo 0) then {
		_vehicle lockCargo false;
	};
	
};

