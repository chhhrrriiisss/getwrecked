//
//      Name: drawIcons
//      Desc: Render loop for onscreen icons
//      Return: None
//

{
	_arr = _x select 0;
	_code = _x select 1;


	if (count _arr == 0) then {} else {

		{
			// Cleanup outdated targets/icons
			if (_x isEqualType objNull && {!alive _x}) then {
				_arr deleteAt _forEachIndex; 
			};
			_x call _code;
			false
		} count _arr;

	};

	false 

} count [
	[
		GW_LOCKEDTARGETS, 
		{
			drawIcon3D [lockedIcon,colorRed,(ASLtoATL visiblePositionASL (VEHICLE _this)),2.25,2.25,2, 'LOCKED', 0, 0.025, "PuristaMedium"];
		}
	],
	[
		GW_TARGETICON_ARRAY,
		{
			drawIcon3D [lockedIcon,colorRed,(ASLtoATL visiblePositionASL (VEHICLE _this)),2.25,2.25,2, '', 0, 0.03, "PuristaMedium"];
		}
	],
	[
		GW_WARNINGICON_ARRAY,
		{	
			_obj = _this;
					
			// Used cached position if we've already calculated it
			_p = _obj getVariable ['GW_CachedPos', nil];
			if (isNil "_p") then {  

				// Some objects need the warning icon in a slightly different place
				_class = typeof _obj;
				_offset = _class call {
					if (_this == "Land_New_WiredFence_5m_F") exitWith { [0,0,2.2] };
					if (_this == "Land_FoodContainer_01_F") exitWith { [0,0,0.5] };
					if (_this == "Land_Sacks_heap_F") exitWith { [0,0,2] };
					[0,0,0] 
				};

				_p = (_obj modelToWorldVisual _offset);

				// Objects that can fall and hit the ground
				if ((_p select 2) > 1) exitWith {};

				_obj setVariable ['GW_CachedPos', _p];
			};

			_distance = _p distance GW_CURRENTPOS;
			if (_obj distance GW_CURRENTPOS > 300) exitWith { false };	

			_size = (1 - ((_distance / 300) * 0.6)) * 1.4;
			_alpha = (300 - _distance) / (300 - 50);
			if (_alpha <= 0) exitWith { false };	

			drawIcon3D [warningIcon,[0.99,0.14,0.09,_alpha], _p, _size,_size,0, '', 0, 0.04, "PuristaMedium"];

			
		
		}
	],

	[
		nitroPads,
		{

			if !(GW_INVEHICLE && GW_ISDRIVER || GW_CURRENTZONE == "globalZone") exitWith { false };
			_pos = (_x select 1);
			if (_pos distance GW_CURRENTVEHICLE > 6) exitWith { false };
			[(_x select 0), GW_CURRENTVEHICLE] call nitroPad;
		}
	],

	[
		flamePads,
		{
			if !(GW_INVEHICLE && GW_ISDRIVER || GW_CURRENTZONE == "globalZone") exitWith { false };
			_pos = (_x select 1);
			if (_pos distance GW_CURRENTVEHICLE > 8) exitWith { false };
			[(_x select 0), GW_CURRENTVEHICLE] call flamePad;

		}
	]
];

// Laser Effect
if (count GW_LINEFFECT_ARRAY > 0) then {
	{
		_p1 = _x select 0;
		_p2 = _x select 1;
		if (_p1 isEqualType objNull) then { _p1 = (ASLtoATL visiblePositionASL _p1); };				
		if (_p2 isEqualType objNull) then { _p2 = (ASLtoATL visiblePositionASL _p2); };	

		if ((_x select 2) == "LSR") then { _p1 set [2, (_p1 select 2) + 0.48]; };

		drawLine3D [_p1, _p2, GW_LINEEFFECT_COLOR];				
		false
	} count GW_LINEFFECT_ARRAY > 0;
};	

// Vehicle pad & workshop hud icons
if (!isNil "GW_CURRENTZONE") then {

	if (GW_CURRENTZONE == "workshopZone" && !GW_TIMER_ACTIVE) then {
	
		// Draw a 3D icon for the save areas and buy terminals
		{					
			_areas = _x select 1;
			
			if (count _areas < 0) exitWith {};	

			_icon = _x select 2;
			_heightOffset = _x select 0;

			{

				_pos = _x getVariable ['GW_CachedPos', nil];
				if (isNil "_pos") then {
					_pos = _x modelToWorldVisual [0,0,_heightOffset];
					_x setVariable ['GW_CachedPos', _pos];
				};

				_d = (_pos distance GW_CURRENTPOS);
				if (_d <= 50) then {
					[_pos, _icon, [], 50] call drawServiceIcon;		
				};

				false
			} count _areas;
			FALSE
		} count [	
			[2.2, vehicleTerminals, saveAreaIcon],
			[1.7, buySigns, buyAreaIcon]
		];

		// Additionally draw icons for vehicles that are hidden
		{
			_isHidden = _x getVariable ['GW_HIDDEN', false];
			_distance = _x distance player;
			_opacity = [1 - (_distance/30), 0, 1] call limitToRange;

			if (_isHidden) then {
				_pos = _x getVariable ['GW_CachedPos', nil];
				if (isNIl "_pos") then {
					_pos = (_x modelToWorldVisual [0,0,1]);
					_x setVariable ['GW_CachedPos', _pos];
				};

				drawIcon3D [hiddenIcon,[1,1,1,_opacity],_pos, 1.7,1.7,0, '', 0, 0.04, "PuristaMedium"];
			};
			false
		} count ((getMarkerPos "workshopZone_camera") nearEntities [["Car", "Tank"], 150]);

	};

	if (GW_CURRENTZONE != "workshopZone" && GW_CURRENTZONE != "globalZone") then {

		// Draw a 3D icon for each service point
		{		
			_areas = _x select 1;	

			if (count _areas < 0) exitWith {};

			_icon = _x select 2;
			_heightOffset = _x select 0;
			_activeIcons = _x select 3;
			_type = _x select 4;

			{		
				_pos = +(_x select 1);
				_pos set [2, (_pos select 2) + _heightOffset];
				if ((_pos distance GW_CURRENTPOS) < 500) then {
					[_pos, _icon, _activeIcons, 500, _type] call drawServiceIcon;		
				};
				false
			} count _areas;

			false
		} count [	
			[1, reloadAreas, rearmIcon, [activeIconA, activeIconB, activeIconC], "REARM" ],
			[1, repairAreas, repairIcon, [activeIconA, activeIconB, activeIconC], "REPAIR" ],
			[1, refuelAreas, refuelIcon, [activeIconA, activeIconB, activeIconC], "REFUEL" ]
		];

	};

};

if (GW_CURRENTZONE != "globalZone") exitWith { true };

// Current Checkpoints
// {	
// 	// Abort on race complete
// 	if (count GW_CHECKPOINTS == GW_CHECKPOINTS_PROGRESS) exitWith { false };

// 	_completedArray = (_x select 1);
// 	_totalCheckpoints = (count GW_CHECKPOINTS) + (count GW_CHECKPOINTS_COMPLETED);
// 	_currentCheckpoint = [(_totalCheckpoints - (count GW_CHECKPOINTS)) + 1, 0, _totalCheckpoints] call limitToRange;
// 	_divider = '/';
// 	IF (_currentCheckpoint == _totalCheckpoints) then { 
// 		_currentCheckpoint = 'FINISH';
// 		_totalCheckpoints = '';
// 		_divider = '';
// 	};

// 	_arr = (_x select 0);

// 	{		

// 		// Use cached position if available
// 		_pos = _x select 0;

// 		_dist = (GW_CURRENTVEHICLE distance _pos);
// 		_alpha = [1 - (_dist / 1000), 0.05, 1] call limitToRange;

// 		_alpha = if (_completedArray) then { 
// 			_prevAlpha = (_x select 2);
// 			_prevAlpha = [_prevAlpha - 0.005, 0, 1] call limitToRange;
// 			_x set [2, _prevAlpha];
// 			_prevAlpha
// 		} else { _alpha };
// 		_alpha = if (_forEachIndex == 0 && !_completedArray) then { 1 } else { _alpha };

// 		if (_alpha <= 0) then {} else {

// 			_size = [2.5 - (_dist / 100), 1.2, 2.5] call limitToRange;
// 			_fontSize = if (_completedArray) then { ([(0.06 - (_dist / 10000)), (0.03), (0.06)] call limitToRange)  } else { (0.032) };
// 			_pos set [2, ([(_dist / 15), 0, 4] call limitToRange)];
// 			_colour = [255,255,255,_alpha];

// 			// Only render current checkpoint for in-progress array
// 			if (_forEachIndex > 2 && !_completedArray) exitWith {};

// 			// Change icon for completed checkpoints
// 			_icon = if (_completedArray) then { okIcon } else { 				
// 				if (_forEachIndex == 0 && (count GW_CHECKPOINTS_COMPLETED) == 0) exitWith {	startMarkerIcon	};
// 				if (_forEachIndex == ((count GW_CHECKPOINTS)-1) ) exitWith { finishMarkerIcon };
// 				checkpointMarkerIcon 	
// 			};
			
// 			// Display distance and checkpoint index information
// 			_index = if (_completedArray) then { (_x select 1) } else { 

// 				if (_forEachIndex > 0) exitWith { '' };
// 				_dist = if (_dist > 5000) then { format['%1km', [_dist / 1000, 0] call roundTo ] } else { format['%1m', [_dist, 0] call roundTo ]};
// 				(format['%1%2%3 [%4]',_currentCheckpoint, _divider, _totalCheckpoints, _dist]) 
// 			};

// 			drawIcon3D [_icon,[255,255,255,_alpha],_pos,_size * 1.03,_size * 1.03,0, _index,0, _fontSize, "PuristaMedium"];			
// 			drawIcon3D [markerBoxIcon,_colour,_pos,_size,_size,0, '',0, 0.03, "PuristaMedium"];		

// 		};

// 	} foreach _arr;	  

// 	false

// } count [
// 	[GW_CHECKPOINTS, false],
// 	[GW_CHECKPOINTS_COMPLETED, true]
// ];

if (isNil "GW_CHECKPOINTS") exitWith { true };
if (count GW_CHECKPOINTS == 0) exitWith { true };
_totalCheckpoints = count GW_CHECKPOINTS;

{	
	// Abort on race complete
	if (_totalCheckpoints == GW_CHECKPOINTS_PROGRESS) exitWith { false };

	// Only render 3 checkpoints above current progress
	if (_forEachIndex >= GW_CHECKPOINTS_PROGRESS && _forEachIndex <= GW_CHECKPOINTS_PROGRESS + 2) then {

		// Icon config and properties
		_pos = if (surfaceIsWater _x) then { _x } else { ASLtoATL _x };
		_dist = (GW_CURRENTVEHICLE distance _pos);
		_alpha = [1 - (_dist / 1000), 0.05, 1] call limitToRange;	
		_alpha = if (GW_CHECKPOINTS_PROGRESS == _forEachIndex) then { 1 } else { _alpha };
		_divider = '/';
		_size = [2.5 - (_dist / 100), 1.2, 2.5] call limitToRange;
		_fontSize = 0.032;
		// _pos set [2, ([(_dist / 15), 0, 4] call limitToRange)];
		_colour = [255,255,255,_alpha];

		// Change icon for completed checkpoints
		_icon = if (_forEachIndex+1 == count GW_CHECKPOINTS) then { finishMarkerIcon } else {
			if (_forEachIndex == 0) exitWith { startMarkerIcon };
			checkpointMarkerIcon
		};
			
		// Display distance and checkpoint index information
		_dist = if (_dist > 5000) then { format['%1km', [_dist / 1000, 0] call roundTo ] } else { format['%1m', [_dist, 0] call roundTo ]};
		_text = if (_forEachIndex == 0) then { 'START' } else {
			if (_forEachIndex+1 == _totalCheckpoints) exitWith { 'FINISH' } ;
			format['%1%2%3',_forEachIndex+1, _divider, _totalCheckpoints];
		};
		_text = if (_forEachIndex != GW_CHECKPOINTS_PROGRESS) then { '' } else { format['%1 [%2]', _text, _dist] };

		drawIcon3D [_icon,[255,255,255,_alpha],_pos,_size * 1.03,_size * 1.03,0, _text,0, _fontSize, "PuristaMedium"];			
		drawIcon3D [markerBoxIcon,_colour,_pos,_size,_size,0, '',0, 0.03, "PuristaMedium"];	

	};

	false

} foreach GW_CHECKPOINTS;

true