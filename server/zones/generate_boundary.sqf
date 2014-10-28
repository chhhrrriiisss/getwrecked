/*

	Generates Walls surrounding all zones

*/

if (!isServer) exitWith {};

if (isNil "spawnedBoundaries") then {
	
    spawnedBoundaries = true;
    spawnedWalls = [];

    createBoundary = {

		_source = +(_this select 0);
		_step = (_this select 1);

		_source set[2, 0];				
		_newDestination = [_source, _step, (_this select 2)] call BIS_fnc_relPos;

		_normal = surfaceNormal _newDestination;
		_isWater = (surfaceIsWater _newDestination);

		if (_isWater) then {

			_newDestination = ATLtoASL (_newDestination);
			_newDestination set[2, 0];
			_normal = [0,0,1];
		};
			
		_wallInside = createVehicle ["UserTexture10m_F", _newDestination, [], 0, 'CAN_COLLIDE']; 
		_wallOutside = createVehicle ["UserTexture10m_F", _newDestination, [], 0, 'CAN_COLLIDE']; 

		if (_isWater) then {
			_wallInside setPosASL _newDestination;
			_wallOutside setPosASL _newDestination;
		};

		_wallInside setVectorUp _normal;
		_wallInside setDir (_this select 3);	
		_wallOutside setVectorUp _normal;	
		_wallOutside setDir (_this select 4);

		_textureIn = "client\images\stripes_fade.paa";

		// This used to be red, but we saved 300kb by dropping it :D
		_textureOut = "client\images\stripes_fade.paa"; 

		_wallInside setObjectTextureGlobal [0,_textureIn];
		_wallOutside setObjectTextureGlobal [0,_textureOut];

		spawnedWalls set [count spawnedWalls, _wallInside];
		spawnedWalls set [count spawnedWalls, _wallOutside];

	};

    {	
		_name = _x select 0;
		_points = _x select 1;
		_c = 0;

		{

			_p1 = ATLtoASL( _x );
			_next = if (_c == (count _points - 1)) then { 0 } else { _c + 1 };
			_p2 = ATLtoASL( _points select _next );

			_dirTo = [_p1, _p2] call BIS_fnc_dirTo;
			_dirIn = [(_dirTo - 90)] call normalizeAngle;
			_dirOut = [(_dirTo + 90)] call normalizeAngle;
			_distance = _p1 distance _p2;

			for "_i" from 0 to _distance step 5 do {
				[_p1, (-2.5 + _i), _dirTo, _dirIn, _dirOut] spawn createBoundary;
			};

			_c = _c + 1;
			false
		} count _points > 0;
		
		false
	} count GW_ZONE_BOUNDARIES > 0;
};
