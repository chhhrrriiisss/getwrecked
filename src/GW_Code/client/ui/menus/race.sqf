//
//      Name: race
//      Desc: 
//      Return: 
//

closedialog 0;

if (isNil "GW_RACE_GENERATOR_ACTIVE") then { GW_RACE_GENERATOR_ACTIVE = false; };	
if (GW_RACE_GENERATOR_ACTIVE) exitWith {};
GW_RACE_GENERATOR_ACTIVE = true;

GW_RACE_ACTIVE = false;

params ['_pad', '_unit'];

_isVehicleReady = [_pad, _unit] call vehicleReadyCheck;
if (!_isVehicleReady) exitWith { GW_RACE_GENERATOR_ACTIVE = false; };
	
// Lock the HUD
GW_HUD_LOCK = true;

// Wait until hud locked
waitUntil{isNil "GW_HUD_INITIALIZED"};


disableSerialization;
if(!(createDialog "GW_Race")) exitWith { GW_RACE_GENERATOR_ACTIVE = false; GW_HUD_LOCK = false; }; //Couldn't create the menu

showChat TRUE;

getAllRaces = {
	_rcs = profileNamespace getVariable [GW_RACES_LOCATION, []];
	_version = profileNamespace getVariable [GW_RACES_VERSION_LOCATION, 0];

	_updateRequired = if (isNil "_version" || _version < GW_VERSION) then { true } else { false };
	_defaultRequired = if (count _Rcs == 0) then { true } else { false };

	// No existing race library, or no race library empty + update required
	if ((_defaultRequired && !_updateRequired) || (_updateRequired && count _rcs == 0)) then {
		[] call createDefaultRaces; 
		_rcs = profileNamespace getVariable [GW_RACES_LOCATION, []];
	};

	// Existing race library + update required
	if (_updateRequired && count _rcs > 0) then {

		// Set defaults
		[] call createDefaultRaces; 
		_rcsNew = profileNamespace getVariable [GW_RACES_LOCATION, []];

		// Try to port across races into the new array
		{
			_r = _x;
			_name = (_x select 0) select 0;

			// Check race with same name doesn't exist and push if it doesn't
			if ( ({ if (((_x select 0) select 0) == _name) exitWith { 1 }; false } count _rcsNew) >= 1) then {} else { 
				_rcsNew pushback _r;
			};

		} foreach _rcs;

		// Save race to profile
		profileNamespace setVariable [GW_RACES_LOCATION, _rcsNew];
		profilenamespace setVariable [GW_RACES_VERSION_LOCATION, GW_VERSION];
		saveProfileNamespace;

		systemchat 'Race library successfully updated to new version.';
	};


	_libraryRaces = +_rcs;

	// Get a quick reference array including active race names
	_activeRaces = [];
	{ _activeRaces pushback ((_x select 0) select 0);	} foreach GW_ACTIVE_RACES;

	// Hide races in library that are the same as active races OR aren't on this map
	_filteredRaces = [];
	{
		_name = (_x select 0) select 0;
		_location = (_x select 0) select 2;
		if (_name in _activeRaces || _location != worldName) then {} else { _filteredRaces pushback _x; };
	} foreach _libraryRaces;

	// Merge the two arrays and return
	_totalRaces = +GW_ACTIVE_RACES;
	_totalRaces append _filteredRaces;
	_totalRaces
};

startRace = {	
	
	disableSerialization;

	if (GW_RACE_EDITING) exitWith {};
	GW_RACE_ACTIVE = true;

	_existingRaces = (call getAllRaces);
	_id = [_this, 0, [0]] call filterParam;;
	_id = [abs _id, 0, (count _existingRaces)-1] call limitToRange;

	_selectedRace = (call getAllRaces) select _id;
	_points = _selectedRace select 1;
	_meta = (_selectedRace select 0);
	_name = _meta select 0;

	_minPlayers = if (GW_DEBUG) then { 1 } else { 2 };
	_meta set [3, _minPlayers];

	_maxWaitPeriod = if (GW_DEBUG) then { 15 } else { 60 };
	_meta set [4, _maxWaitPeriod];

	_host = (name player);
	_raceStatus = [_name] call checkRaceStatus;

	// Check a race with that name is not currently running
	_exists = false;
	_timeout = serverTime + 60;
	{
		if (((_x select 0) select 0) == _name) exitWith { _timeout = ((_x select 0) select 5); _exists = true; };
		if (((_x select 1) select 0) distance (_points select 0) < 100) exitWith { _exists = true; };
	} foreach GW_ACTIVE_RACES;

	// Calculate total distance for this race
	_distance = [_points] call calculateTotalDistance;

	// If we're targetting a race that's already running, go straight to deploy
	if (_exists) exitWith {

		// Race is a new one
		if (_raceStatus == -1) exitWith {
			
			_startButton = ((findDisplay 90000) displayCtrl 90015);
			_startButton ctrlSetText "RACE ACTIVE IN AREA";
			_startButton ctrlCommit 0;
		};

		// Race is currently locked (already started)
		if (_raceStatus >= 2 || (_timeout - serverTime < 10)) exitWith {
			_startButton = ((findDisplay 90000) displayCtrl 90015);
			_startButton ctrlSetText "NOT JOINABLE";
			_startButton ctrlCommit 0;

			//closeDialog 0;
			//[] execVM 'testspectatorcamera.sqf';
		};
		

		closeDialog 0;

		// Send player to zone and begin waiting period for races that are already active
		_success = [GW_SPAWN_VEHICLE, player, _selectedRace] call deployRace;
		GW_SPAWN_ACTIVE = false;
	};

	// Confirmation in case of mis-click
	_result = ['START RACE?', format['%1 [%2]', _name, _distance], 'CONFIRM'] call createMessage;
	if (!_result) exitWith { GW_RACE_ACTIVE = false; };	
	
	//_selectedRace pushback _host;
	_selectedRace pushback _host;
	// GW_ACTIVE_RACES pushback _selectedRace;

	// // Get index of race for reference
	// _raceID = -1;
	// { 
	// 	if (_name == ((_x select 0) select 0)) exitWith { _raceID = _foreachIndex; };
	// } foreach GW_ACTIVE_RACES;

	// Sync race to all clients
	systemchat 'Sending race data to server...';

	// Initialize race thread on server
	[
		[format['%1', _selectedRace]],
		'createRace',
		false,
		false
	] call bis_fnc_mp;	

	closeDialog 0;

	// Wait for server to update race to 'waiting'
	_timeout = time + 5;
	waitUntil {
		Sleep 1;
		['WAITING FOR SERVER...', 0.5, warningIcon, nil, "slideUp"] spawn createAlert; 
		( (([_name] call checkRaceStatus) == 0) || (time > _timeout) )
	};

	
	if (time > _timeout) exitWith {

		GW_RACE_ACTIVE = false;

		// Find and delete added race entry 9if exists)
		{ 
			if (_name == ((_x select 0) select 0)) exitWith { 
				GW_ACTIVE_RACES deleteAt _foreachIndex;
				publicVariable "GW_ACTIVE_RACES";
			};
		} foreach GW_ACTIVE_RACES;

		GW_HUD_ACTIVE = true;
		GW_HUD_LOCK = false;

		Sleep 1;
		['FAILED TO START!',1, warningIcon, colorRed, "slideUp"] spawn createAlert; 
	};	

	GW_HUD_ACTIVE = false;
	GW_HUD_LOCK = true;

	// Send player to zone and begin waiting period
	_success = [GW_SPAWN_VEHICLE, player, _selectedRace] call deployRace;
	GW_SPAWN_ACTIVE = false;
	GW_RACE_ACTIVE = false;

	if (!_success) exitWith {
		GW_HUD_ACTIVE = true;
		GW_HUD_LOCK = false;
	};

};

changeRace = {
	if (GW_RACE_EDITING) exitWith {};
	private ['_list', '_newSelection'];	
	_existingRaces = call getAllRaces;
	_newSelection = [GW_RACE_ID + _this, 0, (count _existingRaces) - 1, true] call limitToRange;
	disableSerialization;
	_list = ((findDisplay 90000) displayCtrl 90011);	
	_list lbSetCurSel _newSelection;
	_newSelection call selectRace;
};

generateRaceStats = {	

	_raceStats = ((findDisplay 90000) displayCtrl 90009);
	_raceStats ctrlEnable false;
	_raceStats ctrlSetFade 0;
	_raceStats ctrlCommit 0;

	lnbClear _raceStats;

	{	
		_raceStats lnbAddRow _x;
		false
	} count [
		[""],
		["", "Distance:", ([GW_RACE_ARRAY] call calculateTotalDistance)],
		["", "Total Checkpoints:", str count (GW_RACE_ARRAY)],
		["", "Estimated Time:", ([GW_RACE_ARRAY, true] call estimateRaceTime)]
	] > 0;

};

selectRace = {
	
	private ['_existingRaces', '_selection', '_raceData', '_raceStatus', '_raceMeta', '_isDefault'];
	disableSerialization;

	_existingRaces = call getAllRaces;

	_selection = [_this, 0, (count _existingRaces) - 1, true] call limitToRange;

	_raceData = _existingRaces select _selection;
	
	GW_RACE_ARRAY = (_raceData select 1);
	GW_RACE_NAME = (_raceData select 0) select 0;	
	GW_RACE_HOST = [_raceData, 2, "NONE", [""]] call filterParam;
	GW_RACE_ID = _selection;
	_raceMeta = _raceData select 0;
	_isDefault = [_raceMeta, 3, false, [false]] call filterParam;

	_startButton = ((findDisplay 90000) displayCtrl 90015);
	_raceStatus = [GW_RACE_NAME] call checkRaceStatus;

	// Determine start text based on race status
	_startText = _raceStatus call {
		if (_this == -1) exitWith { 'START' };
		if (_this == 0) exitWith { 'JOIN' };
		If (_this == 2) exitWith { 'NOT JOINABLE' };
		'START'
	};

	_startButton ctrlSetText _startText;
	_startButton ctrlCommit 0;	

	// Hide edit/rename buttons
	_fade = if (_raceStatus >= 0 || _isDefault) then { 1 } else { 0 };
	_enable = if (_fade == 1) then { false } else { true };

	_editButton = ((findDisplay 90000) displayCtrl 90020);
	_renameButton = ((findDisplay 90000) displayCtrl 90021);
	_deleteButton = ((findDisplay 90000) displayCtrl 90018);

	{	

		_x ctrlEnable _enable;	
		_x ctrlSetFade _fade;
		_x ctrlCommit 0;
	} foreach [_editButton, _renameButton, _deleteButton];

	_defaultFlag = ((findDisplay 90000) displayCtrl 90023);
	_fade = if (_raceStatus >= 0 || _isDefault) then { 0 } else { 1 };
	_defaultFlag ctrlSetFade _fade;

	_text = 'DEFAULT RACE';
	if (_raceStatus >= 0) then {
		_text = format['SHARED BY %1', [GW_RACE_HOST, 12] call cropString];
	};

	_defaultFlag ctrlSetText _text;

	_defaultFlag ctrlCommit 0;

	_mapTitle = ((findDisplay 90000) displayCtrl 90012);
	_mapTitle ctrlSetText GW_RACE_NAME;
	_mapTitle ctrlCommit 0;	

	// Populate race properties
	[] call generateRaceStats;
		
	// Update the map location and animate
	[] call focusCurrentRace;



};

generateRaceList = {

	private ['_selected', '_filterList', '_existingRaces', '_meta', '_name', '_host', '_text', '_status'];
	
	_selected = [_this, 0, 0, [0]] call filterParam;

	disableSerialization;
	_filterList = ((findDisplay 90000) displayCtrl 90011);
	lbClear _filterList;

	_existingRaces = call getAllRaces;

	{
		_meta = _x select 0;
		_name = _meta select 0;
		_status = [_name] call checkRaceStatus;
		_host =  [_x, 2, "", [""]] call filterParam;
		_host = if ((count toArray _host) > 0) then { _host } else { 'UNKNOWN' };

		_text = if (_status == -1) then {
			format[' %1', _name]
		} else {
			if (_status == 3) exitWith {  format[' %1 [ENDING]', _name] };
			if (_status == 2) exitWith {  format[' %1 [RUNNING]', _name] };
			if (_status == 1) exitWith {  format[' %1 [STARTING]', _name] };
			format[' %1 [IN LOBBY]', _name]
		};

		lbAdd [90011,  _text ];
		lbSetData [90011, _forEachIndex, _name];	


	} foreach _existingRaces;

	lbSetCurSel [90011, _selected];

};


focusCurrentRace = {
	
	private ['_map'];

	disableSerialization;
	_map = ((findDisplay 90000) displayCtrl 90001);

	_startPos = GW_RACE_ARRAY select 0;
	if (isNIl "_startPos") exitWith {};

	_endPos = GW_RACE_ARRAY select ((count GW_RACE_ARRAY) -1);
	if (isNIl "_endPos") exitWith {};

	_midPos = [_startPos, ((_startPos distance _endPos) / 2), _dir] call relPos;
	_map ctrlMapAnimAdd [0.25, 0.05, _startPos];
	ctrlMapAnimCommit _map;

};


// focusCurrentRace = {
	
// 	private ['_map'];

// 	disableSerialization;
// 	_map = ((findDisplay 90000) displayCtrl 90001);

// 	_startPos = GW_RACE_ARRAY select 0;
// 	if (isNIl "_startPos") exitWith {};

// 	_endPos = GW_RACE_ARRAY select ((count GW_RACE_ARRAY) -1);
// 	if (isNIl "_endPos") exitWith {};

// 	_dir = [_startPos, _endPos] call dirTo;
// 	_midPos = [_startPos, ((_startPos distance _endPos) / 2), _dir] call relPos;
// 	if (isNIl "_midPos") exitWith {};

// 	_startPosMap = (_map ctrlMapWorldToScreen _startPos);
// 	_endPosMap = (_map ctrlMapWorldToScreen _endPos);
// 	_screenYDist = [_startPosMap select 0, _startPosMap select 1, 0] distance [_startPosMap select 0, _endPosMap select 1, 0];
// 	_screenXDist = [_startPosMap select 0, _startPosMap select 1, 0] distance [_endPosMap select 0, _startPosMap select 1, 0];
// 	_multiplier = if (_screenXDist > _screenYDist) then { (_screenXDist / 0.5) } else { (_screenYDist / 0.3) };
// 	_map ctrlMapAnimAdd [0.25, (1 * _multiplier), _midPos];
// 	ctrlMapAnimCommit _map;

// };



createNewRace = {
	private ['_existingRaces', '_raceName', '_origin', '_p1', '_p2'];

	_existingRaces = call getAllRaces;
	_raceName = toUpper([true] call generateName);

	// Make sure we don't create two identical names
	if ( ({ if (((_x select 0) select 0) == _raceName) exitWith { 1 }; false } count call getAllRaces) >= 1) exitWith { [] call createNewRace; };

	// Create a basic set of waypoints to start
	_origin = [[], 0, 20000, 25, 0, 5, 0] call bis_fnc_findSafePos;
	_p1 = [_origin, 200, 1000, 5, 0, 5, 0] call bis_fnc_findSafePos;
	_p2 = [_p1, 200, 1000, 5, 0, 5, 0] call bis_fnc_findSafePos;

	if (count _origin == 0 || count _p1 == 0 || count _p2 == 0) exitWith { [] call createNewRace; };
	{_x set [2, 0];	} foreach [_origin, _p1, _p2];

	_existingRaces pushBack [[_raceName,(name player),worldName, false],[_origin,_p1,_p2]];	

	profileNamespace setVariable [GW_RACES_LOCATION, _existingRaces];
	saveProfileNamespace;

	[((count _existingRaces) -1)] call generateRaceList;

};


_mapControl = ((findDisplay 90000) displayCtrl 90001);
_mapTitle = ((findDisplay 90000) displayCtrl 90012);
_mapControl ctrlEnable false;
_mapControl ctrlCommit 0;

_existingRaces = call getAllRaces;

GW_RACE_NAME = '';
GW_RACE_DATA = [];
GW_RACE_ID = 0;

_selection = (floor (random (count _existingRaces)));
_selection call generateRaceList;

GW_MARKER_ARRAY = [];
GW_RACE_EDITING = false;
GW_MAP_DRAG = false;
GW_VALID_POS = true;

GW_MAP_X = -1;
GW_MAP_Y = -1;
GW_MAP_NUMBER = 0;
GW_MAP_HOVER_CLOSEST = -1;
GW_MAP_CLOSEST = -1;
GW_MAP_INSERT = -1;

deleteRace = {
	
	private ['_raceToDelete', '_existingRaces', '_meta', '_name'];

	_raceToDelete = [_this, 0, GW_RACE_NAME, [""]] call filterParam;

	_result = if (isNil {_this select 0}) then { ([format['DELETE %1?', _raceToDelete], '', 'CONFIRM'] call createMessage) } else { true };
	if (!_result) exitWith {};	

	_existingRaces = call getAllRaces;

	// Dlete race from array
	{ 
		if (((_x select 0) select 0) == _raceToDelete) exitWith { _existingRaces deleteAt _forEachIndex; }; 
	} foreach _existingRaces;

	profileNamespace setVariable [GW_RACES_LOCATION, _existingRaces];
	saveProfileNamespace;

	[((count _existingRaces) -1)] call generateRaceList;
		
};

renameCurrentRace = {

	private ['_result', '_originalName'];
	
	_originalName = GW_RACE_NAME;
	_result = ['RENAME RACE', toUpper(GW_RACE_NAME), 'INPUT'] call createMessage;	

	if !(_result isEqualType "") exitWith {};
	if (_result == GW_RACE_NAME) exitWith {};
	if (count toArray _result == 0) exitWith {};

	// Check race name isn't the same as an existing race
	if ( ({ if (((_x select 0) select 0) == _result) exitWith { 1 }; false } count call getAllRaces) >= 1) exitWith {  systemchat "Race name conflicts with an existing race."; };

	// GW_RACE_NAME = [toUpper (_result), 10] call cropString;
	GW_RACE_NAME = toUpper _result;
	[] call saveCurrentRace;

	// Delete previous race entry
	[_originalName] call deleteRace;

	disableSerialization;
	_mapTitle = ((findDisplay 90000) displayCtrl 90012);
	_mapTitle ctrlSetText GW_RACE_NAME;
	_mapTitle ctrlCommit 0;

};

clearCurrentRace = {
	
	private['_result'];
	
	_result = ['CLEAR POINTS?', '', 'CONFIRM'] call createMessage;
	if !(_result isEqualType true) exitWith {};
	if (!_result) exitWith {};

	GW_RACE_ARRAY = []; 
	[] call saveCurrentRace;
};


toggleRaceEditing = {
	
	disableSerialization;
	_display = (findDisplay 90000);
	_mapControl = (_display displayCtrl 90001);
	_mapTitle = (_display displayCtrl 90012);
	_mapHelpText = (_display displayCtrl 90030);

	_nonEditorControls = [
		(_display displayCtrl 90011),
		(_display displayCtrl 90018),
		(_display displayCtrl 90017),
		(_display displayCtrl 90016),
		(_display displayCtrl 90015),
		(_display displayCtrl 90014),
		(_display displayCtrl 90022)
	];

	_mapEnabled = ctrlEnabled _mapControl;
	params ['_editButton'];

	_mapControl ctrlEnable !_mapEnabled;
	_mapControl ctrlCommit 0;

	if (_mapEnabled) then {

		_mapTitle ctrlSetFade 0;
		_mapTitle ctrlCommit 1;

		_editButton ctrlSetText 'EDIT';
		_editButton ctrlEnable true;
		_editButton ctrlCommit 0;

		_mapHelpText ctrlSetFade 1;
		_mapHelpText ctrlEnable false;
		_mapHelpText ctrlCommit 0;

		{
			_x ctrlSetFade 0;
			_x ctrlCommit 0;
		} foreach _nonEditorControls;

		[] call focusCurrentRace;
		[] call saveCurrentRace;

		GW_RACE_EDITING = false;

		// Reset tooltips while out of editing
		_mapControl = ((findDisplay 90000) displayCtrl 90001);
		_mapControl ctrlSetTooltip "";
		_mapControl ctrlCommit 0;


	} else {

		_mapTitle ctrlSetFade 1;
		_mapTitle ctrlCommit 0.25;

		_editButton ctrlSetText 'SAVE';
		_editButton ctrlCommit 0;

		{
			_x ctrlSetFade 1;
			_x ctrlCommit 0;
		} foreach _nonEditorControls;

		GW_RACE_EDITING = true;

	};

};

saveCurrentRace = {
	
	_existingRaces = profileNamespace getVariable [GW_RACES_LOCATION, nil];
	if (isNil "_existingRaces") exitWith { systemchat 'Error saving... corrupted race library.'; };

	_index = count _existingRaces;

	{
		_meta = _x select 0;
		_name = _meta select 0;
		if (_name == GW_RACE_NAME) exitWith { _index = _foreachIndex; };
	} foreach _existingRaces;

	_existingRaces set [_index, 
		[
			[GW_RACE_NAME, name player, worldName],
			GW_RACE_ARRAY
		]
	];

	profileNamespace setVariable [GW_RACES_LOCATION, _existingRaces]; 
	saveProfileNamespace;

	[_index] call generateRaceList;
	[] call generateRaceStats;
};

closestMarkerToPosition = {

	private ['_dist', '_closest'];	

	_dist = 99999;
	_closest = -1;
	{	
		if (_x distance _this < _dist) then {
			_closest = _forEachIndex;
			_dist = _x distance _this;
		};
	} foreach GW_RACE_ARRAY;

	_closest

};


findMarkerNearMouse = {
	
	private ['_tolerance', '_closest', '_currentPos', '_pointPos', '_currentPosMap', '_pointPosMap'];

	_tolerance = [_this,0,0.1, [0]] call filterParam;
	_useMap = [_this,1,true, [false]] call filterParam;

	// If we're close to an existing marker, move it
	disableSerialization;
	_mapControl = ((findDisplay 90000) displayCtrl 90001);	
	_currentPos = _mapControl ctrlMapScreenToWorld [GW_MAP_X, GW_MAP_Y];	
	_currentPosMap = _mapControl ctrlMapWorldToScreen _currentPos;
	_currentPos = if (_useMap) then { _currentPosMap } else { (_currentPos) };

	_closest = -1;
	// Find the closest point to current mouse position
	{				
		_pointPosMap = _mapControl ctrlMapWorldToScreen _x;
		_pointPos = if (_useMap) then { _pointPosMap } else { _x };
		if (_currentPos distance _pointPos < _tolerance) exitWith { _closest = _foreachIndex; };
	} foreach GW_RACE_ARRAY;

	_closest

};

_mouseDblClick = _mapControl ctrlAddEventHandler ["MouseButtonDblClick", { 

	private ['_currentPos'];
	
	disableSerialization;
	_mapControl = ((findDisplay 90000) displayCtrl 90001);
	_currentPos = _mapControl ctrlMapScreenToWorld [GW_MAP_X, GW_MAP_Y];	

	_currentPos = _currentPos call validLocationForCheckpoint;
	if (count _currentPos == 0) exitWith {
		["Cannot place here", [1,0,0,0.75], 0.75] call setMapTooltip;
		player say3D "beep_light"; 
	};
			

	// Add a marker at current location, insert if we're between cps
	_index = GW_MAP_INSERT;
	// systemchat format['%1 / %2 / %3 / %4', _index, _currentPos, GW_MAP_X, GW_MAP_Y];

  	if (GW_MAP_INSERT == -1) exitWith {
  		GW_RACE_ARRAY = [GW_RACE_ARRAY, _currentPos] call BIS_fnc_ArrayUnshift
  	};

	GW_RACE_ARRAY = [GW_RACE_ARRAY, GW_MAP_INSERT, _currentPos] call insertAt;

}];


_mouseUp = _mapControl ctrlAddEventHandler ["MouseButtonUp", { 
	
	 	
	if (GW_MAP_HOVER_CLOSEST > -1) then {
		['Press delete to remove', [1,1,1,1], 0] call setMapTooltip;
	};


	// disableSerialization;
	// _mapControl = ((findDisplay 90000) displayCtrl 90001);	
	// _currentPos =_mapControl ctrlMapScreenToWorld [GW_MAP_X, GW_MAP_Y];
	// _raceLength = count GW_RACE_ARRAY;

	// if ((_this select 1) == 0) exitWith {
	// 	if (surfaceIsWater _currentPos) exitWith {};
	// 	GW_RACE_ARRAY = [GW_RACE_ARRAY, GW_MAP_BETWEEN, _currentPos] call insertAt;
	// 	GW_MAP_NUMBER = GW_MAP_NUMBER + 1; 
	// };

	// if ((_this select 1) == 1 || GW_RACE_EDITING) exitWith {};

	// _tooClose = -1;

	// _nearbyMarker = [100, false] call closestMarkerToMouse;
	// if (_nearbyMarker >= 0 && _raceLength > 1 && GW_MAP_NUMBER != _nearbyMarker) exitWith {
	// 	["Not enough space at position", [1,0,0,0.75], 0.75] call setMapTooltip;
	// 	player say3D "beep_light";
	// };	

	// _currentPos = _currentPos findEmptyPosition [10,75,"O_truck_03_ammo_f"];
	// if (count _currentPos == 0) exitWith {
	// 	["Not enough space at position", [1,0,0,0.75], 0.75] call setMapTooltip;
	// 	player say3D "beep_light";
	// };

	// GW_RACE_ARRAY set [GW_MAP_NUMBER, _currentPos];
	// GW_MAP_NUMBER = GW_MAP_NUMBER + 1; 



}];



_mouseDown = _mapControl ctrlAddEventHandler ["MouseButtonDown", { 
	

	// _currentPos = _mapControl ctrlMapScreenToWorld [GW_MAP_X, GW_MAP_Y];	
 // 	GW_RACE_ARRAY pushback _currentPos;

	if (GW_RACE_EDITING && !GW_MAP_DRAG) exitWith {

		disableSerialization;
		_mapControl = ((findDisplay 90000) displayCtrl 90001);	

		if (GW_MAP_HOVER_CLOSEST >= 0 && (_this select 1) == 0) exitWith {

			GW_MAP_HOVER_CLOSEST spawn {

				disableSerialization;
				_mapControl = ((findDisplay 90000) displayCtrl 90001);	
				_prevPos = GW_RACE_ARRAY select _this;
				_pos = _prevPos;



				waitUntil {
					_pos = _mapControl ctrlMapScreenToWorld [GW_MAP_X, GW_MAP_Y];	
					
					_pos = _pos call validLocationForCheckpoint;
					if (count _pos > 0) then {
						GW_RACE_ARRAY set [_this, _pos]; 
					} else {
						["Not a valid location", [1,0,0,0.75], 0] call setMapTooltip;
					};

					(!GW_LMBDOWN)
				};

				// _pos = _pos call validLocationForCheckpoint;
				// _pos = if (count _pos == 0) then { 
				// 	["Not a valid location", [1,0,0,0.75], 0.75] call setMapTooltip;
				// 	player say3D "beep_light"; 
				// } else { _pos };
				// GW_RACE_ARRAY set [_this, _pos];

				// systemchat str _pos;

				GW_MAP_DRAG = false;
			};
		};
	};

}];




setMapTooltip = {

	params ['_str', '_color', '_duration'];

	_str = [_this, 0, "", [""]] call filterParam;
	_color = [_this, 1, [1,1,1,1], [[]]] call filterParam;
	_duration = [_this, 2, 0, [0]] call filterParam;

	_mapControl = ((findDisplay 90000) displayCtrl 90001);
	if (!ctrlCommitted _mapControl) exitWith {};

	if (_duration > 0) exitWith {

		_this spawn {

			disableSerialization;
			_mapControl = ((findDisplay 90000) displayCtrl 90001);
			_mapControl ctrlSetTooltip (_this select 0);
			_mapControl ctrlSetTooltipColorText (_this select 1);

			_bgColor = +(_this select 1);
			_bgColor set [3, (_bgColor select 3) * 0.5];

			_mapControl ctrlSetTooltipColorBox _bgColor;
			_mapControl ctrlCommit (_this select 2);

			Sleep (_this select 2);

			_mapControl ctrlSetTooltip "";
			_mapControl ctrlSetTooltipColorText [1,1,1,1];
			_mapControl ctrlSetTooltipColorBox [1,1,1,1];
			_mapControl ctrlCommit 0;

		};
	};

	disableSerialization;
	_mapControl ctrlSetTooltip (_this select 0);
	_mapControl ctrlSetTooltipColorText _color;
	_mapControl ctrlSetTooltipColorBox [1,1,1,1];
	_mapControl ctrlCommit 0;
	
	
};

_mouseHold = _mapControl ctrlAddEventHandler ["MouseHolding", { 
	// _tooltip = (findDisplay 90000) displayCtrl 90020;
	// _tooltip ctrlSetFade 0;
	// _tooltip ctrlCommit 0.2;

	// Populate race properties
	[] call generateRaceStats;

}];


_mouseMove = _mapControl ctrlAddEventHandler ["MouseMoving", { 	
	GW_MAP_X = _this select 1; 
	GW_MAP_Y = _this select 2; 	

	_clr = [1,1,1,1];
	_str = [] call {
		if (!GW_VALID_POS) exitWith { "" };
		if (!GW_RACE_EDITING) exitWith { "" };
		if (GW_LMBDOWN) exitWith { "" };
		if (GW_MAP_HOVER_CLOSEST > -1) exitWith { "Click and drag to move"};			
		if (GW_RACE_EDITING) exitWith { "Double click to add a checkpoint" };
		""
	};
 	

 	[_str, _clr, 0] call setMapTooltip;
	// _mapControl = ((findDisplay 90000) displayCtrl 90001);
	// _mapControl ctrlSetTooltip "";
	// _mapControl ctrlCommit 1;
	
}];


_mapKeyDown = _mapControl ctrlAddEventHandler ["KeyDown", {  
	
	if (GW_RACE_EDITING && (_this select 1) == 211 && GW_MAP_HOVER_CLOSEST >= 0 && (count GW_RACE_ARRAY) > 2) exitWith {
		GW_RACE_ARRAY deleteAt GW_MAP_HOVER_CLOSEST;
	};

}];

validLocationForCheckpoint = {
	
	private ['_pos', '_isWater', '_nearRoad'];
	
	_pos = _this;
	
	if (count _pos == 0) exitWith { [] };
	if (count _pos == 2) then { _pos set [2, 0]; };

	_isWater = surfaceIsWater _pos;
	_range = if (_isWater) then { 30 } else { 10 };
	_nearbyRoads = _pos nearRoads _range;
	_nearRoad = if (count _nearbyRoads > 0) then { true } else { false };

	_int = lineIntersectsSurfaces [ATLtoASL [_pos select 0, _pos select 1, (_pos select 2) + 100], ATLtoASL _pos, objNull, objNull, true, 1];
	_pos = _pos findEmptyPosition [5,15,"O_truck_03_ammo_f"];

	// Water
	if (_isWater && count _int == 0 && count _pos == 0) exitWith { 
		[] 
	};

	// Use pos method if we find something and there's no intersecting object above (ie bridge)
	if (count _pos > 0 && count _int == 0) exitWith {
		(ATLtoASL _pos)
	};

	// Bridge, dock etc
	if (count _int > 0 && _nearRoad) exitWith {
		// // Draw a line down until we hit the bridge
		// _int = lineIntersectsSurfaces [ATLtoASL [_pos select 0, _pos select 1, (_pos select 2) + 100], ATLtoASL _pos, objNull, objNull, true, 1];

		// if (count _int == 0) exitWith { [] };

		// Return first intersect we hit as pos
		((_int select 0) select 0)

	};	

	if (count _pos > 0) exitWith {
		(ATLtoASL _pos)
	};

	[]
};

drawSegment = {

	private ['_p1','_p2', '_map', '_dist', '_dirTo', '_midPos', '_color'];
	params ['_p1', '_p2'];
	_color = [_this, 2, '(0.99,0.85,0.23,1)', ['']] call filterParam;

	disableSerialization;
	_mapControl = ((findDisplay 90000) displayCtrl 90001);

	_dist = (_p1 distance _p2) / 2;
	_dirTo = ([_p1, _p2] call dirTo);
	_midPos = [_p1, _dist, _dirTo] call relPos;

	_mapControl drawRectangle [
		_midPos,
		([ (50 * ctrlMapScale _mapControl), 2, 30] call limitToRange),
		_dist,
		_dirTo,
		[1,1,1,0.5],
		format["#(rgb,8,8,3)color%1", _color]
	];
};

_mapDraw = _mapControl ctrlAddEventHandler ["Draw", {  
	
	_raceLength = count GW_RACE_ARRAY;
	if (count GW_RACE_ARRAY == 0) exitWith {};

	_lastPos = [0,0,0];
	GW_MAP_HOVER_CLOSEST = [0.05] call findMarkerNearMouse;	

	disableSerialization;
	_mapControl = (_this select 0);
	_mousePos = _mapControl ctrlMapScreenToWorld [GW_MAP_X, GW_MAP_Y];	
	GW_MAP_CLOSEST = _mousePos call closestMarkerToPosition;

	GW_VALID_POS = true;
	
	// Render line segments between mouse and closest points
	if (!GW_LMBDOWN && GW_RACE_EDITING && GW_MAP_HOVER_CLOSEST <0) then {	

		// Is last in array
		if (GW_MAP_CLOSEST < 0 || GW_MAP_CLOSEST >= _raceLength) exitWith {};

		// Check mouse position is valid
		_newPos = _mousePos call validLocationForCheckpoint;
		_c = if (count _newPos == 0) then { GW_VALID_POS = false; '(0.99,0,0,0.3)' } else { GW_VALID_POS = true; '(0.99,0.85,0.23,0.3)' };
		[(GW_RACE_ARRAY select GW_MAP_CLOSEST), _mousePos, _c] call drawSegment;
		
		// systemchat str _mousePos;
		_p = +_mousePos;
		_p set [2, 0];
		// systemchat str (_p call validLocationForCheckpoint);


		// Also render +checkpoint icon at mouse location
		_color = [1,1,1,0.5];
		_size = 30;
		_icon = checkpointMarkerAddIcon;

		if (!GW_VALID_POS) then { 
			_size = 50; 
			_color = [1,0,0,1]; 
			_icon = noTargetIcon 
		} else { 
			if (GW_MAP_CLOSEST == 0) then { _icon = startMarkerIcon };
			if (GW_MAP_CLOSEST == (count GW_RACE_ARRAY-1)) then { _icon = finishMarkerIcon };
		};

		_mapControl drawIcon [
			_icon,
			_color,
			_mousePos,
			_size,
			_size,
			0,
			'',
			0,
			0.1,
			'puristaMedium',
			'center'
		];

		// Don't render line if last point doesnt exist
		_next = GW_MAP_CLOSEST + 1;
		GW_MAP_INSERT = _next;
		if (_next >= _raceLength) exitWith {};
		
		// Don't render next if the mouse is far closer to the first checkpoint
		_maxDistanceBetween = (GW_RACE_ARRAY select GW_MAP_CLOSEST) distance (GW_RACE_ARRAY select _next);
		_distanceNextToMouse = (GW_RACE_ARRAY select _next) distance _mousePos;

		// If the range is too far from previous/next cp (first and last checkpoints typicall), only render one line
		if (_distanceNextToMouse > _maxDistanceBetween && (GW_MAP_CLOSEST == 0 || GW_MAP_CLOSEST == _raceLength)) exitWith {

			// Adjust insertion index (when mousedblclick) appropriately for first+last cps
			GW_MAP_INSERT = if (GW_MAP_CLOSEST == _raceLength) then {  GW_MAP_INSERT + 1 } else {  GW_MAP_INSERT -1 };
		};

		[GW_RACE_ARRAY select _next, _mousePos, _c] call drawSegment;

	};
	
	{
		if (_foreachIndex == 0) then {} else {

			_lastPos = GW_RACE_ARRAY select (_foreachIndex - 1);			
			_currentPos = _x;
			
			// Mouse between these two points?		
			// _maxDist = _lastPos distance _currentPos;
			// if (_mousePos distance _currentPos > _maxDist || _mousePos distance _lastPos > _maxDist) then {} else {

			// 	// Mouse angle is close enough to angle between points	
			// 	_dirMouseToMarker = [_mousePos, _currentPos] call dirTo;
			// 	_dirMarkerToNext = [_lastPos, _currentPos] call dirTo;
			// 	_difDir = abs ([_dirMouseToMarker - _dirMarkerToNext] call flattenAngle);

			// 	if (_difDir < 0.5 && (_mousePos distance _currentPos > 100) && (_mousePos distance _lastPos > 100)) then {
			// 		GW_MAP_BETWEEN = _forEachIndex;
			// 	};

			// };

			// _lastPos set [2, 0];
			// _currentPos set [2, 0];

			_dirTo = ([_lastPos, _currentPos] call dirTo);		
			_dist = (_lastPos distance _currentPos) / 2;

			_segmentSize = 300;

			_prevPos = _lastPos;

			_segments = [];

			for "_i" from 0 to _dist step 100 do {	

				if (surfaceIsWater _currentPos) exitWith {};

				_dirTo = ([_prevPos, _currentPos] call dirTo);
				_nextPos = [_prevPos, _segmentSize, _dirTo] call relPos;

				_dirBack = [_nextPos, _currentPos] call dirTo;
				_dirDif = abs ([_dirBack - _dirTo] call flattenAngle);

				if (_dirDif > 90) then { _nextPos = _currentPos; };
				
				_surfaceIsWater = surfaceIsWater _nextPos;
				_found = false;
				_nextPos = if (_surfaceIsWater) then {

					_scopeStart = [_dirTo - 90] call normalizeAngle;
					_scopeEnd = [_dirTo + 90] call normalizeAngle;

					// Do a sweep across all angles from prevPoint to find one that isn't in water
					_startDir = _dirTo;
					_toggle = 1;
					for "_i" from 0 to 90 step 10 do {
						_toggle = _toggle * -1;
						_newDir = _StartDir - (_i * _toggle);
						_tempPos = [_prevPos, _segmentSize, _newDir] call relPos;
						
						if (!surfaceisWater _tempPos) exitWith { _found = true; _nextPos = _tempPos; };
					};
						
					_nextPos
				} else {
					_nextPos
				};

				_c = if (_surfaceIsWater && !_found) then { '(1,0,0,1)' } else { '(0.99,0.85,0.23,1)' };

				_segments pushBack [_prevPos, _nextPos,_c];			
			
				if (_dirDif > 90) exitWith {};

				_prevPos = _nextPos;

			};

			if (count _segments == 0) exitWith { [_lastPos, _currentPos] call drawSegment; };

			// Render segments between closest marker and mouse
			// _closest = [9999, true] call closestMarkerToMouse;

			// if (_closest > 0 && count GW_RACE_ARRAY > 0) then {

			// 	systemchat str GW_MAP_HOVER_CLOSEST;

			// 	[(GW_RACE_ARRAY select _closest), _mousePos, '(0.99,0.85,0.23,0.25)'] call drawSegment;

			// 	if (true) exitWith {};
			// 	if ((_closest + 1) > count GW_RACE_ARRAY) exitWith {};
			// 	_segments pushback [(GW_RACE_ARRAY select 1), _mousePos, '(0.99,0.85,0.23,0.25)'];
			// };

			{ [(_x select 0), (_x select 1), (_x select 2)] call drawSegment; false } count _segments;
		
		};

		_color = [1,1,1,1];
		_scale = [ (100 * ctrlMapScale (_this select 0)), 35, 100] call limitToRange;

		_iconToUse = switch (true) do {
			case (_foreachIndex == 0): { _scale = _scale * 1.5; startMarkerIcon };
			case ( _raceLength > 1 &&  _foreachIndex == _raceLength -1) : { _scale = _scale * 1.5; finishMarkerIcon };
			default { checkpointMarkerIcon };
		};

		_dirTo = if (_raceLength > 1 && _forEachIndex < (_raceLength - 1) && _foreachIndex > 0) then {
			([([_x, GW_RACE_ARRAY select (_foreachIndex + 1)] call dirTo) - 90] call normalizeAngle)
		} else { 0 };

		if (GW_LMBDOWN && _foreachIndex == GW_MAP_HOVER_CLOSEST) then {
			_color set [3, 0.5];

		};

		if (_foreachIndex == GW_MAP_HOVER_CLOSEST && !GW_LMBDOWN) then {

			_scale = _scale * 1.25;
			
			// Draw icons for each point
			(_this select 0) drawIcon [
				markerBoxIcon,
				_color,
				_x,
				_scale,
				_scale,
				_dirTo,
				'',
				0,
				0.1,
				'puristaMedium',
				'center'
			];	

		};

		if (_foreachIndex == 0 || _foreachIndex == _raceLength -1) then {

			// Draw box background
			(_this select 0) drawIcon [
				uiBar,
				[0,0,0,0.25],
				_x,
				_scale * 0.72,
				_scale * 0.72,
				_dirTo,
				'',
				2,
				0.1,
				'puristaMedium',
				'center'
			];		

		};

		// Draw icons for each point
		(_this select 0) drawIcon [
			_iconToUse,
			_color,
			_x,
			_scale,
			_scale,
			_dirTo,
			'',
			2,
			0.1,
			'puristaMedium',
			'center'
		];

		// if (GW_MAP_BETWEEN > 0 && GW_MAP_BETWEEN == _foreachIndex && !GW_LMBDOWN) then {

		// 	_dirPrev = if (_foreachIndex > 0) then { ([([GW_RACE_ARRAY select (_foreachIndex - 1), _x] call dirTo) - 90] call normalizeAngle) } else { 0 };

		// 	// Additionally draw a tempIcon if mouse is currently between points
		// 	(_this select 0) drawIcon [
		// 		checkpointMarkerAddIcon,
		// 		[1,1,1,0.5],
		// 		_mousePos,
		// 		30,
		// 		30,
		// 		_dirPrev,
		// 		'',
		// 		0,
		// 		0.1,
		// 		'puristaMedium',
		// 		'center'
		// 	];

		// };

	} foreach GW_RACE_ARRAY;

}];

Sleep 0.1;

// Menu has been closed, kill everything!
waitUntil { isNull (findDisplay 90000) };

GW_HUD_LOCK = false; 

_mapControl ctrlRemoveEventHandler ["KeyDown", _mapKeyDown];
_mapControl ctrlRemoveEventHandler ["MouseButtonUp", _mouseUp];
_mapControl ctrlRemoveEventHandler ["MouseButtonDown", _mouseDown];
_mapControl ctrlRemoveEventHandler ["MouseHolding", _mouseHold];
_mapControl ctrlRemoveEventHandler ["MouseMoving", _mouseMove];
_mapControl ctrlRemoveEventHandler ["MouseButtonDblClick", _mouseDblClick]; 
_mapControl ctrlRemoveEventHandler ["Draw", _mapDraw];

GW_RACE_GENERATOR_ACTIVE = false;
GW_RACE_EDITING = false;

showChat true;

