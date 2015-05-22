// Show player/vehicle tags for nearby units
{
	_isVehicle = _x getVariable ['isVehicle', false];
	_name = _x getVariable ["name", ''];
	_owner = _x getVariable ["GW_Owner",''];		
	_newSpawn = _x getVariable ["newSpawn", false];	

	if (!_isVehicle && _x != player && (_x == (vehicle _x)) && (alive _x) && isPlayer _x) then { // (isPlayer _x)

		_name = (name _x);
		_pos = _x modelToWorldVisual [0, 0, 2.2];
		_dist = _currentPos distance _pos;
		
		drawIcon3D [
			blankIcon,
			[1,1,1,( (1 - (_dist/150)) max 0 )],
			_pos,
			1,
			1,
			0,
			_name,
			0,
			0.03,
			"PuristaMedium"
		];

	};

	// Only render tags we can see
	if ( !(_owner isEqualTo '') && _isVehicle && !_newSpawn && GW_CURRENTZONE != "workshopZone") then {

		if ('radar' in GW_VEHICLE_STATUS && !(_x in GW_TARGETICON_ARRAY) && _x != GW_CURRENTVEHICLE) then { 
			GW_TARGETICON_ARRAY pushback _x;
		};

		IF (!('radar' in GW_VEHICLE_STATUS)) then {
			GW_TARGETICON_ARRAY = [];
		};	

		[_x] call vehicleTag;
	};	

	false
} count _targets > 0;