//
//      Name: init_areas.sqf
//      Desc: Add vehicle service actions to terminals
//      Return: None
//

// Get the mission directory
MISSION_ROOT = call {
    private "_arr";
    _arr = toArray str missionConfigFile;
    _arr resize (count _arr - 15);
    toString _arr
};

// String formats
createVehFormat = "<img size='3' color='#ffffff' shadow='0' image='" + MISSION_ROOT + "client\images\icons\menus\create.paa' align='left' /> <t size='1.1' shadow='0' align='left'>CREATE  </t>";
spawnInFormat = "<img size='3' color='#ffffff' shadow='0' image='" + MISSION_ROOT + "client\images\icons\menus\spawnin.paa' align='left' /> <t size='1.1' shadow='0' align='left'>DEPLOY  </t>";
clearPadFormat = "<img size='3' color='#ffffff' shadow='0' image='" + MISSION_ROOT + "client\images\icons\menus\clear.paa' align='left' /> <t size='1.1' shadow='0' align='left'>CLEAR  </t>";
savePadFormat = "<img size='3' color='#ffffff' shadow='0' image='" + MISSION_ROOT + "client\images\icons\menus\save.paa' align='left' /> <t size='1.1' shadow='0' align='left'>SAVE  </t>";
loadPadFormat = "<img size='3' color='#ffffff' shadow='0' image='" + MISSION_ROOT + "client\images\icons\menus\load.paa' align='left' /> <t size='1.1' shadow='0' align='left'>LOAD  </t>";

_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_pad = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _obj || isNull _pad) exitWith { diag_log 'Error initializing vehicle terminal.'; };

_obj addEventHandler['handleDamage', { false }];

// New Vehicle
_obj addAction[createVehFormat, { 
	[(_this select 3)] spawn newMenu;
}, _pad, 9, false, false, "", "( !GW_EDITING && ((player distance _target) < 12) )"];

// Save Vehicle
_obj addAction[savePadFormat, {
	[''] spawn saveVehicle;
}, _pad, 8, false, false, "", "( !GW_EDITING && ((player distance _target) < 12) )"];

// Deploy/Spawn
_obj addAction[spawnInFormat, { 
	[(_this select 3), (_this select 1)] spawn spawnMenu;
}, _pad,7, false, false, "", "( !GW_EDITING && ((player distance _target) < 12) )"];

// Load Vehicle
_obj addAction[loadPadFormat, {
	[(_this select 3)] spawn previewMenu;
}, _pad, 6, false, false, "", "( !GW_EDITING && ((player distance _target) < 12) )"];

// Clear pad
_obj addAction[clearPadFormat, {
	[(_this select 3)] spawn clearPad;
}, _pad, 5, false, false, "", "( !GW_EDITING && ((player distance _target) < 12) )"];

