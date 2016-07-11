//
//      Name: raceLobby
//      Desc: Dialog used in ready-up phase of races
//      Return: None
//

private ['_vehicle', '_unit'];

if (isNil "GW_LOBBY_ACTIVE") then { GW_LOBBY_ACTIVE = false; };
if (GW_LOBBY_ACTIVE) exitWith {};
GW_LOBBY_ACTIVE = true;

private ['_targetRace', '_racePoints', '_raceName'];

_targetRace = [_this, 0, [], [[]]] call filterParam;
if (count _targetRace == 0) exitWith { systemchat 'Bad race data, could not init race lobby.'; };

// Determine the start checkpoint
_raceName = (_targetRace select 0) select 0;
GW_CURRENTRACE = _raceName;
GW_CURRENTRACE_VEHICLE = GW_CURRENTVEHICLE;
_raceStatus = [_raceName] call checkRaceStatus;
_raceHost = if (isNil "_targetRace select 2") then { 'UNKNOWN' } else { (_targetRace select 2) };
_points = _targetRace select 1;

disableSerialization;
if(!(createDialog "GW_Lobby")) exitWith { GW_LOBBY_ACTIVE = false; }; //Couldn't create the menu

// Set Dialog title to race name
// _title = ((findDisplay 103000) displayCtrl 103010);
// _title ctrlSetText _raceName;
// _title ctrlCommit 0;

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerStatic cutRsc ["RscStatic", "PLAIN" , 0.5];

"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [0.5]; 
"dynamicBlur" ppEffectCommit 0.25; 

// Close the hud if its open
GW_HUD_ACTIVE = false;
GW_HUD_LOCK = true;

exitLobbyToWorkshop = {
	
	if (isNull (findDisplay 103000)) exitWith {};

	// Don't allow exiting once race has started
	_raceStatus = [GW_CURRENTRACE] call checkRaceStatus;
	if (_raceStatus == 2) exitWith { systemchat 'Race already starting... cannot abort.';  };

	9999 cutText ["", "BLACK", 0.01]; 
	GW_IGNORE_DEATH_CAMERA = TRUE;

	closeDialog 0;

};

toggleRaceReady = {	
	
	// Don't allow status changes once race has started
	_raceStatus = [GW_CURRENTRACE] call checkRaceStatus;
	if (_raceStatus == 2) exitWith {};

	_pr = GW_CURRENTVEHICLE getVariable ['GW_R_PR', -1];
	disableSerialization;

	_readyParams = if (_pr == -1) then {
		GW_CURRENTVEHICLE setVariable ['GW_R_PR', 0, true];
		["NOT READY", "client\images\stripes_repeat_red.paa"]
	} else {
		GW_CURRENTVEHICLE setVariable ['GW_R_PR', -1, true];		
		["READY", "client\images\stripes_repeat_yellow.paa"]
	};

	_readyTexture = ((findDisplay 103000) displayCtrl 103030);
	_readyTexture ctrlSetText (_readyParams select 1);
	_readyTexture ctrlCommit 0;

	_readyButton = ((findDisplay 103000) displayCtrl 103003);
	_readyButton ctrlSetText (_readyParams select 0);
	_readyButton ctrlCommit 0;

	// Refresh local vehicle ready list
	[] call updateVehicleReadyList;

};

updateVehicleReadyList = {
	
	private ['_v', '_list'];

	// Ensure we only count vehicles with drivers
	_v = (ASLtoATL visiblePositionASL GW_CURRENTVEHICLE) nearEntities [["Car"], 150];
	{
		_isVehicle = _x getVariable ['isVehicle', false];
		_hasDriver = !isNull (driver _x);
		_hasDriver = true;
		if (!_isVehicle || !_hasDriver || !alive _x) then { _v deleteAt _forEachIndex; };
	} foreach _v;

	disableSerialization;
	_list = ((findDisplay 103000) displayCtrl 103001);
	ctrlShow[103001, true]; 
	lnbClear _list;

	_list lnbAddRow["", "", "", ""];

	// Use list of nearby vehicles to generate a ready list
	{
		_progress = _x getVariable ['GW_R_PR', -1];
		_isReady = IF (_progress < 0) then { false } else { true };

		_name = [(_x getVariable ["name", '?']), 16] call cropString;
		_driver = if ((driver _x) isEqualType objNull) then { '?' } else { (name driver _x) };
		_driver = [_driver, 10] call cropString;
		_id = format['%1 [%2]', _name, _driver];
		_list lnbAddRow["", "", _id, ""];

		_icon = [typeof _x] call getVehiclePicture;

		if (!_isReady) then {
			// Nope, gotta cough up the money
			_list lnbSetPicture[[((((lnbSize 103001) select 0)) -1), 3], noTargetIcon];
		} else {
			// It is normally a locked item, but its been unlocked! Woop!
			_list lnbSetPicture[[((((lnbSize 103001) select 0)) -1), 3], okIcon];
		};

		_list lnbSetPicture[[((((lnbSize 103001) select 0)) -1), 1], _icon];

	} foreach _v;

	if (count _v == 0) then {
		_list lnbAddRow["", "LOADING...", ""];
	};

};


// Generate a list of attributes for the current race
private ['_display', '_control', '_v', '_vehicleStats', '_dist'];
params ['_target'];

disableSerialization;
_statsList = ((findDisplay 103000) displayCtrl 103002);

// Make sure we're starting from scratch
lnbClear _statsList;

_totalCheckpoints = count _points;
_totalDistance = [_points] call calculateTotalDistance;
_estimatedTime = [_points] call estimateRaceTime;

{	

	_text = (_x select 0);
	_icon = (_x select 1);
	_statsList lnbAddRow['', '', _text];
	_statsList lnbSetPicture[[((((lnbSize 103002) select 0)) -1),1], _icon];
	false

} count [
	// For each entry, create two columns and a row
	[ format['%1', _raceName],  infoIcon],
	[ format['%1 checkpoints', _totalCheckpoints],  checkpointMarkerIcon],
	[ format['%1', _totalDistance], suspendIcon],
	[ format['%1', _estimatedTime], timerIcon]
	// [ [(format['%1%2', (_data select 3) * 100, '%']), ammoIcon], [(format['%1L', (_data select 4) * 100]), fuelIcon] ],
	// [ [(format['%1', (_data select 5)]),armourIcon], [(format['%1', (_data select 7)]), radarIcon] ]		

] > 0;

_description  = ((findDisplay 103000) displayCtrl 103005);
_description ctrlSetStructuredText parseText ( format["<t size='1' align='center'>%1</t>", "No respawns; Increased damage. Weapons enabled after first checkpoint."] );
_description ctrlCommit 0;

_lastTimerUpdate = time - 1;
_lastReadyUpdate = time - 1;

// Menu has been closed, kill everything!
waitUntil { 	
	
	// Update vehicle ready list every second
	if (time - _lastReadyUpdate > 1) then {
		_lastReadyUpdate = time;
		[] call updateVehicleReadyList;
	};

	// Check race status every 0.5 seconds
	_raceStatus = [_raceName] call checkRaceStatus;
	if (_raceStatus >= 2) exitWith {true };	
	if (_raceStatus == -1) exitWith { true };

	if (time - _lastTimerUpdate > 1) then {
		_lastTimerUpdate = time;

		_startTime = [(_targetRace select 0), 5, 0, [0]] call filterParam;
		_left = [([(_startTime - serverTime), 0, 9999] call limitToRange), 0] call roundTo;
		_seconds = floor (_left);	
		_hoursLeft = floor(_seconds / 3600);
		_minsLeft = floor((_seconds - (_hoursLeft*3600)) / 60);
		_secsLeft = floor(_seconds % 60);
		_timeLeft = format['-%1:%2:%3', ([_hoursLeft, 2] call padZeros), ([_minsLeft, 2] call padZeros), ([_secsLeft, 2] call padZeros)];

		if (_secsLeft < 5) then {
			GW_CURRENTVEHICLE say "beepTarget";
		};

		_text = if (_raceStatus == 0) then { "WAITING FOR PLAYERS" } else {
			if (_raceStatus == 1) exitWith { "STARTING RACE" };
			"RACE STARTED"
		};

		_title = ((findDisplay 103000) displayCtrl 103010);
		_title ctrlSetText format['%1 [%2]', _text, _timeLeft];
		_title ctrlCommit 0;		
	};

	isNull (findDisplay 103000) 
};



closeDialog 103000;
_timeout = time + 1;
waitUntil { ((isNull (findDisplay 103000)) || time > _timeout) };

GW_LOBBY_ACTIVE = false;

"dynamicBlur" ppEffectAdjust [0]; 
"dynamicBlur" ppEffectCommit 0.1; 

// Race cancelled or not enough players
_raceStatus = [_raceName] call checkRaceStatus;
_raceData = _raceName call getRaceID;
_raceID = (_raceData select 1);

// Race aborted by user, return to workshop
if (_raceStatus == 0 || _raceStatus == 1) exitWith {	
	GW_CURRENTVEHICLE call destroyAndClear;	
};

if (_raceStatus != 2 || _raceStatus == -1) exitWith {

	waitUntil { Sleep 0.1; (isNull (findDisplay 95000)) };
	["<br /><br /><t size='3' color='#ffffff' align='center'>RACE ABORTED</t>", "", [false, { false }], { true }, 3, true] call createTitle;
	GW_CURRENTVEHICLE call destroyAndClear;

};

// Race running, start checkpoint system!
if (_raceStatus >= 2) exitWith {

	[_targetRace, 9999] spawn raceCheckpoints;

	waitUntil { Sleep 0.1; (isNull (findDisplay 95000)) };
	["<br /><br /><t size='3' color='#ffffff' align='center'>GET READY</t>", "", [false, { false }], { true }, 3, true] call createTitle;

	waitUntil { Sleep 0.1; (isNull (findDisplay 95000)) };	
	_maxTime = 5;
	_success = ['ABORT', _maxTime, [false, false], true] call createTimer;

	if (!_success) exitWith {
		waitUntil { Sleep 0.1; (isNull (findDisplay 94000)) };
		GW_CURRENTVEHICLE call destroyInstantly;
	};

	// Reopen the hud if its closed
	GW_HUD_ACTIVE = false;
	GW_HUD_LOCK = false;

	GW_CURRENTRACE_START = serverTime;

	GW_CURRENTVEHICLE call compileAttached;

	GW_CURRENTVEHICLE say "electronTrigger";

	GW_HUD_ACTIVE = false;
	GW_HUD_LOCK = false;
};

// By default destroy everything just in case
GW_CURRENTVEHICLE call destroyAndClear;
