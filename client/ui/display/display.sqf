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
		_totalString = format["[   DEBUG MODE   ] \n\n Time: %1\n Zone: %2\n Player: %3\n FPS: %4\n FPSMIN: %5\n", time, GW_CURRENTZONE, name player, [diag_fps, 0] call roundTo, [diag_fpsMIN, 0] call roundTo];
		{	_totalString = format['%1 \n %2: %3', _totalString, (_x select 0), (_x select 1)];	false	} count GW_DEBUG_ARRAY > 0;

		hintSilent _totalString;
	};

	// Auto close inventories
	disableSerialization;
    if (!isNull (findDisplay 602)) then  { closeDialog 602; };

	// Get all the conditions we need
	GW_CURRENTVEHICLE = (vehicle player);
	GW_INVEHICLE = !(player == GW_CURRENTVEHICLE);
	GW_ISDRIVER = (player == (driver (GW_CURRENTVEHICLE)));		
	GW_VEHICLE_STATUS = GW_CURRENTVEHICLE getVariable ["status", []];
	GW_VEHICLE_SPECIAL = GW_CURRENTVEHICLE getVariable ["special", []];

	GW_HASLOCKONS = GW_CURRENTVEHICLE getVariable ["lockOns", false];
	GW_HASMELEE = GW_CURRENTVEHICLE call hasMelee;
	GW_NEWSPAWN = GW_CURRENTVEHICLE getVariable ["newSpawn", false];

	_currentDir = direction player;
	_currentPos = getPosASL player;

	call drawIcons;
	  
 	// If any of these menus are active, forget about drawing anything else
	if (GW_DEPLOY_ACTIVE || GW_SPAWN_ACTIVE || GW_SETTINGS_ACTIVE) exitWith {};
	if (isNil "GW_CURRENTZONE") exitWith {};

	// If there's no nearby targets, no point going any further
	_targets = if (GW_DEBUG) then { ((ASLtoATL visiblePositionASL GW_CURRENTVEHICLE) nearEntities [["Car", "Man", "Tank"], 1000]) } else { ([GW_CURRENTZONE] call findAllInZone) };	
	if (count _targets == 0) exitWith {};	

	call drawTags;

	if (GW_CURRENTZONE == "workshopZone") exitWith {};

	call statusMonitor;

	// Player target marker
	if (GW_INVEHICLE && GW_ISDRIVER && !GW_TIMER_ACTIVE) then { call targetCursor; };		

	// Try to lock on to those targets if we have lock ons
	if (GW_INVEHICLE && GW_ISDRIVER && GW_HASLOCKONS && !GW_NEWSPAWN) then {
		_targets call targetLockOn;
	};

	
	
		
}];
