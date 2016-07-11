//
//      Name: parseZoneBoundary
//      Desc: Create position and dir information for zone boundaries ready for building
//      Return: None
//

_createBoundary = {
	
	private ['_t', '_pos', '_dirAndUp'];
	params ['_pos', '_dirAndUp'];

	_t = createVehicle ["UserTexture10m_F", _pos, [], 0, "CAN_COLLIDE"];		
	
	// If we're over water, ensure the wall is placed correctly
	if (surfaceIsWater _pos) then { _t setPosASL _pos; };
	_t setVectorDirAndUp _dirAndUp;

	// Ignore flag for cleanup script (doesnt apply in dedicated since these are only spawned client side)
	_t setVariable ['GW_CU_IGNORE', true];

	_t setObjectTextureGlobal [0,"client\images\stripes_fade.paa"];
	_t enableSimulationGlobal false;

	_t

};

GW_ZONE_BOUNDARIES_ARRAY = [];

{

	// Abort if no point data to work with
	_zoneName = _x select 0;
	_pointsArray = _x select 1;

	_c = 0;
	_bA = [];

	{
		_p1 = ATLtoASL( _x );
		_next = if (_c == (count _pointsArray - 1)) then { 0 } else { _c + 1 };
		_p2 = ATLtoASL( _pointsArray select _next );

		_dirTo = [_p1, _p2] call dirTo;
		_dirIn = [(_dirTo - 90)] call normalizeAngle;
		_dirOut = [(_dirTo + 90)] call normalizeAngle;

		_distance = _p1 distance _p2;

		for "_i" from 0 to _distance step 5 do {
			

			_p = [_p1, (-2.5 + _i), _dirTo, ([_dirIn,0,0] call dirToVector)] call {

				_source = +(_this select 0);
				_step = (_this select 1);

				_source set[2, 0];				
				_newDestination = [_source, _step, (_this select 2)] call relPos;	
				_isWater = (surfaceIsWater _newDestination);			

				_normal = if (_isWater) then {
					_newDestination = ATLtoASL (_newDestination);	
					_newDestination set[2, 0];
					[0,0,1]
				} else {
				 	(surfaceNormal _newDestination)
				};
				
				([_newDestination, [(_this select 3), _normal]] call _createBoundary)

			};

			_bA pushback _p;

		};	

		_c = _c + 1;

		false
	} count _pointsArray > 0;

	_x set [2, _bA];
	_x set [3, []];

	false

} count GW_ZONE_BOUNDARIES;

GW_ZONE_BOUNDARIES_CACHED = compileFinal "true";

true