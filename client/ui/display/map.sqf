//
//      Name: drawMap
//      Desc: Main loop for boundaries and markers to map
//      Return: None
//

// Map Icons
// waitUntil{sleep 0.22; !isNull ((findDisplay 12) displayCtrl 51)};

if (!isNil "GW_MAP_EH") then {
	((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw", GW_MAP_EH];
	GW_MAP_EH = nil;
};

GW_MAP_EH = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", {
	
	if (GW_GENERATOR_ACTIVE) exitWith {};
		
	_vehicle = (vehicle player);
	_scale = 1;

	// Draw current vehicle
	(_this select 0) drawIcon [
        getText (configFile/"CfgVehicles"/typeOf _vehicle/"Icon"),
        [0.99,0.85,0.23,1],
        (ASLtoATL visiblePositionASL _vehicle),
        0.5/ctrlMapScale (_this select 0),
        0.5/ctrlMapScale (_this select 0),
        direction _vehicle
	]; 

	// Draw service point icons
	{	
		_areas = _x select 0;
		_icon = _x select 1;

		{

			(_this select 0) drawIcon [
			    _icon,
			    [1,1,1,1],
			    (ASLtoATL visiblePositionASL _x),
			    _scale/ctrlMapScale (_this select 0),
			    _scale/ctrlMapScale (_this select 0),
			    0
			]; 
			false
		} count _areas > 0;

		false
	} count [	
		[reloadAreas, rearmIcon],
		[repairAreas, repairIcon],
		[refuelAreas, refuelIcon]
	] > 0;

	// Draw map boundaries, provided they exist
	if (!isNil "GW_ZONE_BOUNDARIES") then {

		{	
			_name = _x select 0;
			_points = _x select 1;
			_c = 0;

			{

				_p1 = ATLtoASL(_x);
				_next = if (_c == (count _points - 1)) then { 0 } else { _c + 1 };
				_p2 = ATLtoASL(_points select _next);

				_dirTo = [_p1, _p2] call dirTo;
				_distance = _p1 distance _p2;
				_thickness = 1;

				_repeats = 3;

				for "_i" from _repeats to 0 step -1 do {

					// Create a slightly shorter line each time
					_step = _distance * (_i / _repeats);
					_source = +_p1;
					_newDestination = [_source, _step, _dirTo] call relPos;

					// Alternate the line colour
					_currentColor = if ((_i % 2) == 0) then { [0.99,0.82,0.04,1] } else { [0,0,0,1] };
		
					(_this select 0) drawLine [
						_source,
						_newDestination,
						_currentColor
					];

					_source set[0, (_source select 0) + 1];
					_source set[1, (_source select 1) - 1];
					_newDestination set[0, (_newDestination select 0) + 1];
					_newDestination set[1, (_newDestination select 1) - 1];						

				};

				_c = _c + 1;
				false
			} count _points > 0;
			false
		} count GW_ZONE_BOUNDARIES > 0;

	};

}];

