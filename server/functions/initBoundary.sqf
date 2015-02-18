//
//      Name: initBoundary
//      Desc: Creates virtual boundary surrounding all pre-designated zones
//      Return: None
//

if (!isServer) exitWith {};

if (isNil "GW_boundariesSpawned") then {
	
	GW_boundariesSpawned = true;	  

    {	
		_points = _x select 1;
		_c = 0;

		{

			_p1 = ATLtoASL( _x );
			_next = if (_c == (count _points - 1)) then { 0 } else { _c + 1 };
			_p2 = ATLtoASL( _points select _next );

			_dirTo = [_p1, _p2] call dirTo;

			_dirIn = [(_dirTo - 90)] call normalizeAngle;
			_dirOut = [(_dirTo + 90)] call normalizeAngle;

			_distance = _p1 distance _p2;

			for "_i" from 0 to _distance step 5 do {
				[_p1, (-2.5 + _i), _dirTo, ([_dirIn,0,0] call dirToVector), ([_dirOut, 0,0] call dirToVector)] call GWS_fnc_createBoundary;
			};

			_c = _c + 1;
			false
		} count _points > 0;
		
		false
	} count GW_ZONE_BOUNDARIES;
};