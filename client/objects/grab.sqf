//
//      Name: grabObj
//      Desc: Pick up an item and carry it with the player
//      Return: Bool
//

private ['_obj', '_unit', '_type'];

_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_unit = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _obj || isNull _unit) exitWith {};

// If the object isn't local and isn't attached to anything, make it local so all this jazz runs better
if ( !local _obj && isNull attachedTo _obj) then {

	// Store prev location and hide current object
	_obj hideObject true;

	_pos = getPos _obj;
	_dir = getDir _obj;
	_type = typeOf _obj;

	// Determine the class for the object
	_subType = _obj getVariable ["type", ''];
	_isHolder = if (_subType in GW_HOLDERARRAY) then { _type = _subType; true } else { false };

	// If its a supply box, grab its object info
	_isSupply = _obj getVariable ["isSupply", false];
	_supplyData = if (_isSupply) then { 

		([			
			['GW_Inventory', _obj getVariable ["GW_Inventory", []] ],
			['owner', _obj getVariable ["owner", ""] ],
			['mass', _obj getVariable ["mass", 40] ],
			['name', _obj getVariable ["name", ""] ],
			['isSupply', true]
		])

	} else { [] };

	// Remove the previous object as its no longer needed
	deleteVehicle _obj;

	// Create a new one, locally
	_newObj = nil;
	_newObj = [_pos, _dir, _type, nil, "CAN_COLLIDE", true] call createObject; 	

	// Re-add the object properties depending on if its a supply box, or normal object
	if (_isSupply) then {

		_newObj call setupSupplyBox;

		// Iterate and re-add supply box data
		{	
			_key = _x select 0;
			_value = _x select 1;

			if (!isNil "_key") then {
				_newObj setVariable[_key, _value, true];
			};

			false

		} count _supplyData > 0;

	} else {
		
		// Request the server adds these properties
		[		
			[
				_newObj
			],
			"setObjectProperties",
			false,
			false 
		] call BIS_fnc_MP;   
		
		// Special event handler to prevent launching vehicles
		_newObj addEventHandler['EpeContactStart', {

		 	if ((_this select 0) distance (getMarkerPos "workshopZone_camera") < 300) then {
		 		_v = _this select 1;
		 		_isVehicle = _v getVariable ["isVehicle", false];
		 		if (_isVehicle) then {
		 			[[_v,[0,0,0]],"setVelocityLocal",_v,false ] call BIS_fnc_MP;  
		 		};
		 	};
 		}];

		// Make sure we cant hop in static turrets
		_newObj lockDriver true;
		_obj lockTurret [[0], true];
   		_obj lockTurret [[0,0], true];
	};


    _obj = _newObj;

};


// Disable simulation server side as a default
[		
	[
		_obj,
		false
	],
	"setObjectSimulation",
	false,
	false 
] call BIS_fnc_MP;  
	
_unit setVariable['editingObject', _obj];

// If a snapping state hasnt been set, default to false
if (isNil { _unit getVariable 'snapping' }) then {	_unit setVariable ['snapping', false]; };

GW_EDITING = true;

// Wait for simulation to be disabled on the item before moving it
_timeout = time + 5;
waitUntil{	
	if ( (time > _timeout) || !(simulationEnabled _obj) ) exitWith { true };
	false
};

Sleep 0.5;

// Used to dynamically change the loop period depending if snapping is active
_moveInterval = 0.01;
_snappingInterval = 0.1;

GW_HOLD_ROTATE_POS = [];
_startAngle = 360;

for "_i" from 0 to 1 step 0 do {

	if (!alive _unit || !alive _obj || !GW_EDITING || _unit != (vehicle player)) exitWith {};

	// Continually prevent damage and simulation (wierd stuff happens otherwise...)
	if (simulationEnabled _obj) then { _obj enableSimulation false; };
	_obj setDammage 0;
	_obj setVectorUp [0,0,1];

	// Use the camera height as a tool to manipulate the object height
	_cameraHeight = (positionCameraToWorld [0,0,0]) select 2;
	_height = [(3.5 - _cameraHeight), 0, 4] call limitToRange;	
	_pos = _unit modelToWorld [0, 2.5, _height];
	_pos = ATLtoASL _pos;

	_snapping = _unit getVariable ['snapping', false];	

	// Use the camera yaw to spin the vehicle when toggle key is down
	if (GW_HOLD_ROTATE) then {

		if (count GW_HOLD_ROTATE_POS > 0) then {

			['ROTATE USING CAMERA', 3, cameraRotateIcon, nil, "flash"] spawn createAlert;   

			_center = worldToScreen getPos _obj;
			_adjustedCenter = ((_center select 0)+1);
			if (isNil "_adjustedCenter") then { _adjustedCenter = 0; };

			_obj setDir ([(360 * _adjustedCenter) + (_startAngle)] call normalizeAngle);			

		} else { _startAngle = getDir _obj; };

		GW_HOLD_ROTATE_POS = (ASLtoATL getPosASL _obj);

	} else {

		// Reset player's direction post hold rotate
		if (count GW_HOLD_ROTATE_POS > 0) then {			

			_dirTo = [_unit, _obj] call dirTo;	
			_unit setDir _dirTo;
			_obj setPos GW_HOLD_ROTATE_POS;

			GW_HOLD_ROTATE_POS = [];

		} else {

	 		// If snapping is enabled, snap! Else, just set the new position.
			if (_snapping && GW_EDITING) then { [_pos, _obj] spawn snapObj; };
			if (!_snapping && GW_EDITING) then { _obj setPosASL _pos; };	

		};

	};

	// Dynamically adjust the sleep time to reduce errors during snapping
	_interval = if (_snapping) then { _snappingInterval } else { _moveInterval };
	Sleep _interval;

};

if (!alive _obj) then {

	removeAllActions _unit;
	_unit spawn setPlayerActions;
	GW_EDITING = false;
	_unit setVariable['editingObject', nil];
};

true