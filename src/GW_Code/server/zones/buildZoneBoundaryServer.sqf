//
//      Name: buildZoneBoundary
//      Desc: Generate walls using pre-cached zone point data
//      Return: None
//


private ['_zoneName', '_pointsArray', '_bA'];
private ['_bA', '_c', '_zoneName', '_pointsArray'];

_createBoundary	 = compileFinal "
	
	params ['_pos', '_dirAndUp', '_w'];
	_w = createVehicle ['UserTexture10m_F', _pos, [], 0, 'CAN_COLLIDE'];	
	if (surfaceIsWater _pos) then { _w setPosASL _pos; };
	_w setVectorDirAndUp _dirAndUp;
	_w setObjectTexture [0,'client\images\stripes_fade.paa'];
	_w setVariable ['GW_CU_IGNORE', true];
	_w enableSimulationGlobal false;
";


{

	// Abort if no point data to work with
	_zoneName = _x select 0;

	// Don't build workshop zone boundaries
	if (_zoneName == "workshopZone") then {} else {

		_pointsArray = _x select 1;

		_c = 0;

		{


			_p1 = ATLtoASL( _x );
			_next = if (_c == (count _pointsArray - 1)) then { 0 } else { _c + 1 };
			_p2 = ATLtoASL( _pointsArray select _next );

			_dirTo = [_p1, _p2] call dirTo;
			_dirIn = [(_dirTo - 90)] call normalizeAngle;
			_dirOut = [(_dirTo + 90)] call normalizeAngle;

			_distance = _p1 distance _p2;

			for "_i" from 0 to _distance step 5 do {
				[_p1, (-2.5 + _i), _dirTo, ([_dirIn,0,0] call dirToVector)] call {

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
			
					[_newDestination, [(_this select 3), _normal]] call _createBoundary;

				};			

			};	

			_c = _c + 1;

			false
		} count _pointsArray > 0;
		
	};

	false

} count GW_ZONE_BOUNDARIES;

GW_BOUNDARY_BUILT = compileFinal "true";

true


