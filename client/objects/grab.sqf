//
//      Name: grabObj
//      Desc: Pick up an item and carry it with the player
//      Return: Bool
//

private ['_obj', '_unit', '_type'];

_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_unit = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _obj || isNull _unit) exitWith {};

// If the object isn't local, make it local so all this jazz runs better
if ( !local _obj ) then {

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
	_newObj = [_pos, _dir, _type, nil, "CAN_COLLIDE", false] call createObject; 	

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

		// Make sure we cant hop in static turrets
		_newObj lockDriver true;
		_obj lockTurret [[0], true];
   		_obj lockTurret [[0,0], true];
	};

    _obj = _newObj;

};


_unit setVariable['editingObject', _obj];

// If a snapping state hasnt been set, default to false
if (isNil { _unit getVariable 'snapping' }) then {	_unit setVariable ['snapping', false]; };

GW_EDITING = true;

// Disable simulation server side if its active
if (simulationEnabled _obj) then {

	_obj enableSimulation false;

	[		
		[
			_obj,
			false
		],
		"setObjectSimulation",
		false,
		false 
	] call BIS_fnc_MP;  

};

Sleep 0.5;

// Wait for simulation to be enabled on the item before moving it
_timeout = time + 5;
waitUntil{	
	if ( (time > _timeout) || !(simulationEnabled _obj) ) exitWith { true };
	false
};

// Used to dynamically change the loop period depending if snapping is active
_moveInterval = 0.01;
_snappingInterval = 0.1;

while {alive _unit && alive _obj && GW_EDITING && _unit == (vehicle player)} do {

	// Continually prevent damage and simulation (wierd stuff happens otherwise...)
	if (simulationEnabled _obj) then { _obj enableSimulation false; };
	_obj setDammage 0;

	// Use the camera height as a tool to manipulate the object height
	_cameraHeight = (positionCameraToWorld [0,0,0]) select 2;
	_height = [(3.5 - _cameraHeight), 0, 4] call limitToRange;	
	_pos = _unit modelToWorld [0, 2.5, _height];
	_pos = ATLtoASL _pos;

	_snapping = _unit getVariable ['snapping', false];	
	
	// If snapping is enabled, snap! Else, just set the new position.
	if (_snapping && GW_EDITING) then { [_pos, _obj] spawn snapObj; };
	if (!_snapping && GW_EDITING) then { _obj setPosASL _pos; };	

	// Dynamically adjust the sleep time to reduce errors during snapping
	_interval = if (_snapping) then { _snappingInterval } else { _moveInterval };
	Sleep _interval;

};

true