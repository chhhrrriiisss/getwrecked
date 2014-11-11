//
//      Name: display
//      Desc: Main loop for rendering icons and hud indicators to the screen
//      Return: None
//

GW_ANIMCOUNT = 0;
GW_LASTTICK = 0;
showBinds = false;

drawServiceIcon = {
		
		_pos = [_this,0, [], [[]]] call BIS_fnc_param;
		_defaultIcon = [_this,1, "", [""]] call BIS_fnc_param;

		// Optionally loop through a series of icons once close enough
		_activeIcons = [_this,2, [], [[]]] call BIS_fnc_param;

		// Max visible range of icon
		_maxVisibleRange = [_this,3, 300, [0]] call BIS_fnc_param;

		_distance = _pos distance player;
		_size = (1 - ((_distance / _maxVisibleRange) * 0.6)) * 1.4;
		_alpha = (_maxVisibleRange - _distance) / (_maxVisibleRange);

		if (_alpha <= 0) exitWith {};

		_colour = [1,1,1,_alpha];
		_inUse = (vehicle player) getVariable ["inUse", false];
		
		//If the player is really close and we have an animated icon set switch icons to an 'active' state
		if (_distance < 8 && count _activeIcons > 0 && _inUse) then {

			// Every 5 seconds increase the tick on the animation
			if (time - GW_LASTTICK > 0.5) then {
				GW_LASTTICK = time;
				GW_ANIMCOUNT = GW_ANIMCOUNT + 1;
				GW_ANIMCOUNT = if (GW_ANIMCOUNT >=  (count _activeIcons)) then { 0 } else { GW_ANIMCOUNT };
			};

			_icon = _activeIcons select GW_ANIMCOUNT;

			drawIcon3D [_icon, _colour, _pos, _size, _size, 0, "", 0.01];					

		} else {
			drawIcon3D [_defaultIcon, _colour, _pos, _size, _size, 0, "", 0.01];	
		};
};

drawDisplay = {

	if(!hasInterface) exitWith {};
	// Useful for detecting mouse presses
	[] call mouseHandler;

	// Used for detecting key presses
	[] call initBinds;

	// Main HUD
	_mEH = addMissionEventHandler ["Draw3D", {

		// Get all the conditions we need
		_vehicle = (vehicle player);		
		_inVehicle = !(player == _vehicle);
		_isDriver = (player == (driver (_vehicle)));		
		_hasLockOns = _vehicle getVariable ["lockOns", false];
		_freshSpawn = _vehicle getVariable ["newSpawn", false];
		_currentDir = direction player;
		_currentPos = getPosASL player;

		// Target icons 
		if (count GW_TARGETICON_ARRAY > 0) then {
			{
				if (!alive _x || isNull _x) then {
					GW_TARGETICON_ARRAY = GW_TARGETICON_ARRAY - [_x];
				} else {
					if (typename _x == "OBJECT" && {alive _x}) then {
						drawIcon3D [lockingIcon,[0.99,0.14,0.09,1], (_x modelToWorldVisual [0,0,0]), 2.5,2.5,0, '', 0, 0.04, "PuristaMedium"];
					};
				};

				false
			} count GW_TARGETICON_ARRAY > 0;
		};	        

		// Laser Effect
		if (count GW_LINEFFECT_ARRAY > 0) then {
			{
				_p1 = _x select 0;
				_p2 = _x select 1;
				if (typename _p1 == "OBJECT") then { _p1 = (ASLtoATL visiblePositionASL _p1); };				
				if (typename _p2 == "OBJECT") then { _p2 = (ASLtoATL visiblePositionASL _p2); };	
				drawLine3D [_p1, _p2, GW_LINEEFFECT_COLOR];				
				false
			} count GW_LINEFFECT_ARRAY > 0;
		};	

		// Warning Icons on Added Objects
		if (count GW_WARNINGICON_ARRAY > 0) then {
			{
				if (!alive _x || isNull _x) then {
					GW_WARNINGICON_ARRAY = GW_WARNINGICON_ARRAY - [_x];

				} else {	

					if (typename _x == "OBJECT" && { alive _x } && { _x distance _vehicle < 300 }) then {

						// Some objects need the warning icon in a slightly different place
						_offset = switch (typeof _x) do { case "Land_New_WiredFence_5m_F": { [0,0,2.2] }; case "Land_FoodContainer_01_F": { [0,0,0.5] }; case "Land_Sacks_heap_F": { [0,0,2] }; default { [0,0,0] }; };
						_p = (_x modelToWorldVisual _offset);
						_distance = _p distance (ASLtoATL visiblePositionASL _vehicle);
						_size = (1 - ((_distance / 300) * 0.6)) * 1.4;
						_alpha = (300 - _distance) / (300 - 50);

						if (_alpha <= 0) exitWith {};
						
						drawIcon3D [warningIcon,[0.99,0.14,0.09,_alpha], _p, _size,_size,0, '', 0, 0.04, "PuristaMedium"];
					};

				};
				false
			} count GW_WARNINGICON_ARRAY > 0;
		};	
        
		if (!isNil "GW_DISPLAY_CANCEL") exitWith {
			GW_DISPLAY_CANCEL = nil;
		};


  		if (!isNil "GW_CURRENTZONE") then {

  			if (GW_CURRENTZONE == "workshopZone" && !GW_TIMER_ACTIVE) then {
 
  				// Draw a 3D icon for the save areas and buy terminals
				{		
					_areas = _x select 1;
					if (count _areas < 0) exitWith {};

					for "_i" from 0 to (count _areas) step 1 do {
						_d = ((_areas select _i) distance player);
						if (_d <= 50) then {
							[((_areas select _i) modelToWorldVisual [0,0,(_x select 0)]), (_x select 2), [], 50] call drawServiceIcon;		
						};
					};

				} count [	
					[2.2, vehicleTerminals, saveAreaIcon],
					[1.7, buySigns, buyAreaIcon],
					[2.2, lootAreas, lootAreaIcon]
				] > 0;

  			};

			if (GW_CURRENTZONE != "workshopZone") then {

				// Draw a 3D icon for each service point
				{		
					_areas = _x select 1;
					if (count _areas < 0) exitWith {};

					for "_i" from 0 to (count _areas) step 1 do {
						if (((_areas select _i) distance player) < 500) then {
							[((_areas select _i) modelToWorldVisual [0,0,(_x select 0)]), (_x select 2), (_x select 3), 500] call drawServiceIcon;		
						};
					};

				} count [	
					[1, reloadAreas, rearmIcon, [activeIconA, activeIconB, activeIconC] ],
					[1, repairAreas, repairIcon, [activeIconA, activeIconB, activeIconC] ],
					[1, refuelAreas, refuelIcon, [activeIconA, activeIconB, activeIconC] ]
				] > 0;

			};

		};
		
		// If any of these menus are active, forget about drawing anything else
		if (GW_DEPLOY_ACTIVE || GW_SPAWN_ACTIVE || GW_SETTINGS_ACTIVE) exitWith {};
		if (isNil "GW_CURRENTZONE") exitWith {};

		// Player target marker
		if (_inVehicle && _isDriver && !GW_TIMER_ACTIVE) then {
			[_vehicle] call targetCursor;
		};

		// If there's no nearby targets, no point going any further
		_targets = [GW_CURRENTZONE] call findAllInZone;
		if (count _targets == 0) exitWith {};		

		// Try to lock on to those targets if we have lock ons
		if (_inVehicle && _isDriver && _hasLockOns && !_freshSpawn) then {
			call targetLockOn;
		};

		// Show player/vehicle tags for nearby units
		{
			_isVehicle = _x getVariable ['isVehicle', false];
			_name = _x getVariable ["name", ''];
			_owner = _x getVariable ["owner",''];		
			_newSpawn = _x getVariable ["newSpawn", false];	

			if (_x isKindOf "Civilian" && _x != player && (_x == (vehicle _x)) && (alive _x)) then { // (isPlayer _x)

				_name = (name _x);
				_pos = _x modelToWorldVisual [0, 0, 2.2];
				_dist = _currentPos distance _pos;
				_alpha = (1 - (_dist/150)) max 0;

				drawIcon3D [
					blankIcon,
					[1,1,1,_alpha],
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

			if (_owner != '' && _isVehicle && (vehicle player) != _x && !_newSpawn) then {
				[_x] call vehicleTag;
			};		
			false
		} count _targets > 0;
			
	}];

	if (_mEH < 0) then {
		systemChat 'Display rendering failed.';
	};	

	// Map Icons
	waitUntil{sleep 0.22; !isNull ((findDisplay 12) displayCtrl 51)};

	_eh = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", {

		_vehicle = (vehicle player);
		_scale = 0.75;

		// Draw current vehicle
		(_this select 0) drawIcon [
	        getText (configFile/"CfgVehicles"/typeOf _vehicle/"Icon"),
	        [1,1,1,1],
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
			[refuelAreas, refuelIcon],
			[saveAreas, saveAreaIcon]
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

					_dirTo = [_p1, _p2] call BIS_fnc_dirTo;
					_distance = _p1 distance _p2;
					_thickness = 1;

					_repeats = (ceil (_distance / 70)) max 10;

					for "_i" from _repeats to 0 step -1 do {

						// Create a slightly shorter line each time
						_step = _distance * (_i / _repeats);
						_source = +_p1;
						_newDestination = [_source, _step, _dirTo] call BIS_fnc_relPos;

						// Alternate the line colour
						_currentColor = if ((_i % 2) == 0) then { [0.99,0.82,0.04,1] } else { [0,0,0,1] };

						// Repeat to increase line thickness
						for "_y" from 0 to _thickness step 1 do {

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

					};

					_c = _c + 1;
					false
				} count _points > 0;
				false
			} count GW_ZONE_BOUNDARIES > 0;

		};

	}];

	if (_eh < 0) then {
		systemChat 'Map icon rendering failed.';
	};

};