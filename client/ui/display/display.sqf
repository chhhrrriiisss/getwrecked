//
//      Name: drawDisplay
//      Desc: Main loop for rendering icons and hud indicators to the screen
//      Return: None
//

if(!hasInterface) exitWith {};
	
// Main HUD
if (!isNil "GW_DISPLAY_EH") then {
	removeMissionEventHandler ["Draw3D", GW_DISPLAY_EH];
	GW_DISPLAY_EH = nil;
};

GW_DISPLAY_EH = addMissionEventHandler ["Draw3D", {

	// Debugging
	if (!GW_DEBUG) then {} else {

		if (isNil "GW_DEBUG_ARRAY") then {	GW_DEBUG_ARRAY = []; };
		if (GW_DEBUG_ARRAY isEqualTo []) exitWith {};

		GW_DEBUG_MONITOR_LAST_UPDATE = time;
		_totalString = format["[   DEBUG MODE   ] \n\n Time: %1\n Zone: %2\n Player: %3\n", time, GW_CURRENTZONE, GW_PLAYERNAME];
		{	_totalString = format['%1 \n %2: %3', _totalString, (_x select 0), (_x select 1)];	false	} count GW_DEBUG_ARRAY > 0;

		hintSilent _totalString;
	};

	// Get all the conditions we need
	_vehicle = GW_CURRENTVEHICLE;		
	_inVehicle = !(player == _vehicle);
	_isDriver = (player == (driver (_vehicle)));		
	_status = _vehicle getVariable ["status", []];
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
				[1.7, buySigns, buyAreaIcon]
			] > 0;

		};

		if (GW_CURRENTZONE != "workshopZone") then {

			// Draw a 3D icon for each service point
			{		
				_areas = _x select 1;
				if (count _areas < 0) exitWith {};

				for "_i" from 0 to (count _areas) step 1 do {
					if (((_areas select _i) distance (vehicle player)) < 500) then {
						[((_areas select _i) modelToWorldVisual [0,0,(_x select 0)]), (_x select 2), (_x select 3), 500, (_x select 4)] call drawServiceIcon;		
					};
				};

			} count [	
				[1, reloadAreas, rearmIcon, [activeIconA, activeIconB, activeIconC], "REARM" ],
				[1, repairAreas, repairIcon, [activeIconA, activeIconB, activeIconC], "REPAIR" ],
				[1, refuelAreas, refuelIcon, [activeIconA, activeIconB, activeIconC], "REFUEL" ]
			] > 0;

			// Check we're not in range of a nitro pad
			if (_inVehicle && _isDriver) then {
				{
					if (_x distance (vehicle player) < 6) exitWith {
						[_x, _vehicle] call nitroPad;
						false
					};
					false
				} count nitroPads;
			};

		};

	};
	
	// If any of these menus are active, forget about drawing anything else
	if (GW_DEPLOY_ACTIVE || GW_SPAWN_ACTIVE || GW_SETTINGS_ACTIVE) exitWith {};
	if (isNil "GW_CURRENTZONE") exitWith {};

	// Player target marker
	if (_inVehicle && _isDriver && !GW_TIMER_ACTIVE) then {
		call targetCursor;
	};

	// If there's no nearby targets, no point going any further
	_r = if (GW_CURRENTZONE == "workshopZone") then { 200 } else { GW_MAXLOCKRANGE };
	//_targets = (ASLtoATL visiblePositionASL GW_CURRENTVEHICLE) nearEntities [["Car", "Civilian"], _r];
	_targets = [GW_CURRENTZONE] call findAllInZone;
	if (count _targets == 0) exitWith {};		

	// Try to lock on to those targets if we have lock ons
	if (_inVehicle && _isDriver && _hasLockOns && !_freshSpawn) then {
		_targets call targetLockOn;
	};

	// Show player/vehicle tags for nearby units
	{
		_isVehicle = _x getVariable ['isVehicle', false];
		_name = _x getVariable ["name", ''];
		_owner = _x getVariable ["owner",''];		
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
		if (_owner != '' && _isVehicle && !_newSpawn && GW_CURRENTZONE != "workshopZone") then {

			if ('radar' in _status && !(_x in GW_TARGETICON_ARRAY) && _x != GW_CURRENTVEHICLE) then { 
				GW_TARGETICON_ARRAY pushback _x;
			};

			IF (!('radar' in _status)) then {
				GW_TARGETICON_ARRAY = [];
			};	

			[_x] call vehicleTag;
		};	

		false
	} count _targets > 0;
		
}];
