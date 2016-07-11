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
		
	// Abort if not alive
    if (!alive player) exitWith { true };

	// Auto close inventories
	disableSerialization;
    if (!isNull (findDisplay 602)) then  { 
    	closeDialog 602; 
    };

    // Abort if player loop not currently active
    if (isNil "GW_PLAYER_LOOP") exitWith {};

 	// If any of these menus are active, forget about drawing anything else
	if (GW_DEPLOY_ACTIVE || GW_SPAWN_ACTIVE || GW_SETTINGS_ACTIVE || GW_TIMER_ACTIVE || GW_TITLE_ACTIVE || GW_LOBBY_ACTIVE) exitWith {};

	if (isNil "GW_CURRENTZONE") exitWith {};

	call drawIcons;	  		

	// Player target cursor
	if (GW_INVEHICLE && GW_ISDRIVER && !GW_TIMER_ACTIVE && GW_CURRENTZONE != "workshopZone") then { 
		call targetCursor; 
	};		

	// If theres no nearby targets, no point going any further
	_targets = if (GW_DEBUG) then { (GW_CURRENTPOS nearEntities [["Car", "Man", "Tank"], 1000]) } else { ([GW_CURRENTZONE, {true}, false] call findAllInZone) };
	if (count _targets == 0) exitWith {};	
	
	[_targets] call drawTags;

	if (GW_CURRENTZONE == "workshopZone") exitWith {};	

	// Try to lock on to those targets if we have lock ons
	if (GW_INVEHICLE && GW_ISDRIVER && GW_HASLOCKONS && !GW_NEWSPAWN) then {
		_targets call targetLockOn;
	};

	true

}];

true