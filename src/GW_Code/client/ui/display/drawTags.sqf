//
//      Name: drawTags
//      Desc: Drag health bars and names for nearby vehicles and players
//      Return: None
//

params ['_arr'];
private ['_arr'];

// Reset target icons if radar status has finished
if (!('radar' in GW_VEHICLE_STATUS)) then { GW_TARGETICON_ARRAY = []; };	

// Show player/vehicle tags for nearby units
_vehicleRendered = false;
{	
	
	// Target must be in a vehicle
	_inVehicle = if (_x == (vehicle _x)) then { false } else { true };	

	// Draw health tags for players in vehicle
	if (_inVehicle) then {

		// If not driver of current vehicle
		if (_x != (driver (vehicle _x)))  exitWith {};	
		
		// Valid vehicle?
		_isVehicle = (vehicle _x) getVariable ['isVehicle', false];
		if (!_isVehicle) exitWith {};

		_x = (vehicle _x);

		// Dont render vehicles without owners
		_owner = _x getVariable ["GW_Owner",''];
		if (_owner isEqualTo '') exitWith {};		

		// Not currently in workshop
		if (GW_CURRENTZONE == "workshopZone") exitWith {};		

		// Push to radar array if we have that powerup
		if ('radar' in GW_VEHICLE_STATUS && !(_x in GW_TARGETICON_ARRAY) && _x != GW_CURRENTVEHICLE) then { GW_TARGETICON_ARRAY pushback _x; };			

		// Only render first vehicle captured by this loop that's in scope
		_inScope = if (GW_CURRENTVEHICLE == _x) then { true } else { ([GW_TARGET_DIRECTION, _x, 12.5] call checkScope) };		

		if (!_inScope) exitWith {};

		[_x] call vehicleTag;

	} else {

		// Draw name tags for players
		if (!isPlayer _x) exitWith {};
		if ( (_x == player || !alive _x) && !GW_DEBUG  ) exitWith {};

		_name = (name _x);
		_pos = _x modelToWorldVisual [0, 0, 2.2];
		_dist = GW_CURRENTPOS distance _pos;
		
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

	false
} count _arr > 0;

// systemchat str _arr;