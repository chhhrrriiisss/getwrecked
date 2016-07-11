//
//
//
//      Client Function Compile & Configuration
//
//
//

// Primary Colours
colorGreen = [0.24,0.65,0,1];
colorRed = [0.99,0.14,0.09,1];
colorOrange = [0.906,0.651,0.137,1];
colorBlue = [0.14,0.76,0.94,1];
colorYellow = [0.99,0.85,0.23,1];
colorInvisible = [0.99,0.14,0.09,0];
colorWhite = [1,1,1,1];

// Variables
GW_BINDS_ORDER = [ 
	["HORN", ""], 
	["UNFL", ""], 
	["EPLD", ""], 
	["LOCK", ""],
	["OILS", ""],
	["DCLK", ""],
	["PARC", ""],
	["TELP", ""]
];

// List of weapons that are fired when left clicking
GW_FIREABLE_WEAPONS = [
	'HMG',
	'MOR',
	'GMG',
	'MIS',
	'RPG',
	'LSR',
	'RLG',
	'FLM',
	'HAR',
	'GUD',
	'LMG',
	'RPD'
];

// Returns correct icon for weapon tag
getWeaponIcon = {
	if (_this in ["HMG", "RLG", "LSR", "LMG"]) exitWith { hmgTargetIcon };
	if (_this in ["RPG", "MIS", "GUD", "FLM", "RPD"]) exitWith { rpgTargetIcon };
	if (_this in ["MOR", "GMG", "HAR"]) exitWith { rangeTargetIcon };
	noTargetIcon
};

GW_VEHICLE_STATUS = [];
GW_CURRENTPOS = [0,0,0];
GW_IGNORE_DEATH_CAMERA = false;
GW_INVEHICLE = false;
GW_ISDRIVER = false;
GW_STATS_ORDER = ["kill", "death", "destroyed", "mileage", "moneyEarned", "timeAlive", "deploy", "disabled", "outofbounds", "racewin"];
GW_INVULNERABLE = true;
GW_DEPLOYLIST = [];
GW_LOCKEDTARGETS = [];
GW_CHECKPOINTS = [];
GW_CHECKPOINTS_COMPLETED = [];
GW_LASTMESSAGELOGGED = time;
GW_DEBUG = false;
GW_BUY_ACTIVE = false;
GW_NEW_ACTIVE = false;
GW_INVENTORY_ACTIVE = false;
GW_DEATH_CAMERA_ACTIVE = false;
GW_FLYBY_ACTIVE = false;
GW_PREVIEW_CAM_ACTIVE = false;
GW_GENERATOR_ACTIVE = false;
GW_RACE_GENERATOR_ACTIVE = false;
GW_SETTINGS_ACTIVE = false;
GW_LOBBY_ACTIVE = false;
GW_SPAWN_ACTIVE = false;
GW_DEPLOY_ACTIVE = false;
GW_TIMER_ACTIVE = false;
GW_SPECTATOR_ACTIVE = false;
GW_TITLE_ACTIVE = false;
GW_LOADING_ACTIVE = false;
GW_DIALOG_ACTIVE = false;
GW_GUIDED_ACTIVE = false;
GW_TAG_ACTIVE = false;
GW_HUD_ACTIVE = false;
GW_HUD_LOCK = false;
GW_MELEE_ACTIVE = false;
GW_SHARED_ACTIVE = [];
GW_CURRENTVEHICLE = (vehicle player);
GW_CURRENTZONE = nil;
GW_CURRENTZONE_DATA = [];
GW_WAITFIRE = false;
GW_WAITUSE = false;
GW_WAITLIST = [];
GW_WAITEDIT = false;   
GW_WAITALERT = false;
GW_WAITSAVE = false;
GW_WAITLOAD = false;
GW_WAITCOMPILE = false;
GW_SHAREARRAY = [];
GW_EDITING = false;
GW_HOLD_ROTATE = false;
GW_LIFT_ACTIVE = false;
GW_PAINT_ACTIVE = false;
GW_LMBDOWN = false;
GW_LINEFFECT_ARRAY = [];
GW_LINEEFFECT_COLOR = colorRed;
GW_TARGETICON_ARRAY = [];
GW_WARNINGICON_ARRAY = [];
GW_TAGLIST = [];
GW_ANIMCOUNT = 0;
GW_LASTTICK = 0;

GW_clientFunctions = [

	['playerInit', 'client\'],
	['playerSpawn', 'client\'],
	['playerKilled', 'client\'],
	['playerRespawn', 'client\'],
	['playerLoop', 'client\'],
	['triggerLazyUpdate', nil],
	['previewCamera', 'client\ui\cameras\'],
	['deathCamera', 'client\ui\cameras\'],
	['orbitCamera', 'client\ui\cameras\'],

	['setPlayerTexture', nil],

	['drawTags', 'client\ui\display\'],
	['drawIcons', 'client\ui\display\'],
	['drawMap', 'client\ui\display\'],
	['drawDisplay', 'client\ui\display\'],
	['vehicleTag', 'client\ui\display\'],
	['targetLockOn', 'client\ui\display\'],
	['targetCursor', 'client\ui\display\'],
	['mouseHandler', 'client\ui\display\'],

	['drawHud', 'client\ui\display\'],
	['drawServiceIcon', nil],

	['settingsMenu', 'client\ui\dialogs\'],
	['newMenu', 'client\ui\dialogs\'],
	['raceLobby', 'client\ui\dialogs\'],
	['buyMenu', 'client\ui\dialogs\'],
	['inventoryMenu', 'client\ui\dialogs\'],
	['spawnMenu', 'client\ui\menus\'],
	['previewMenu', 'client\ui\menus\'],

	['createAlert', 'client\ui\hud\'],
	['createPowerup', 'client\ui\hud\'],
	['createNotification', 'client\ui\hud\'],
	['createHalo', 'client\ui\hud\'],
	['createTween', 'client\ui\hud\'],
	['createHint', 'client\ui\dialogs\'],

	['createMessage', 'client\ui\dialogs\'],
	['createTimer', 'client\ui\dialogs\'],
	['createTitle', 'client\ui\dialogs\'],

	['calculateTotalDistance', nil],
	['estimateRaceTime', nil],
	['createCheckpoint', 'client\zones\'],

	['isIndirect', nil]

	// ['buildZoneBoundary', nil],
	// ['cacheZoneBoundary', nil],
	// ['removeZoneBoundary', nil]

];

// Batch compile all functions
[GW_clientFunctions, 'client\functions\', GW_DEV_BUILD] call functionCompiler;

// Key bind functions
call compile preprocessfile "client\key_binds.sqf";

// Compile UI Specific functions
call compile preprocessFile 'client\ui\compile.sqf';


// Zone
preVehicleDeploy = compile preprocessFile 'client\zones\preVehicleDeploy.sqf';
initVehicleDeploy = compile preprocessFile 'client\zones\initVehicleDeploy.sqf';
deployBattle = compile preprocessFile 'client\zones\deploy_battle.sqf';
deployRace = compile preprocessFile 'client\zones\deploy_race.sqf';
raceCheckpoints = compile preprocessFile 'client\zones\race_checkpoints.sqf';
servicePoint = compile preprocessFile 'client\zones\vehicle_point.sqf';
nitroPad =  compile preprocessFile 'client\zones\nitro_pad.sqf';
flamePad = compile preprocessFile 'client\zones\flame_pad.sqf';

// Persistance Functions
paintVehicle = compile preprocessFile 'client\customization\paint_vehicle.sqf';
liftVehicle = compile preprocessFile 'client\objects\lift_vehicle.sqf';
requestVehicle = compile preprocessFile  'client\persistance\request.sqf';

registerVehicle = compile preprocessFile  'client\persistance\add.sqf';
saveVehicle = compile preprocessFile  'client\persistance\save.sqf';
listFunctions = compile preprocessFile  'client\persistance\library.sqf';
listVehicles = compile preprocessFile  'client\persistance\list.sqf';
getVehicleLibrary = compile preprocessFile 'client\persistance\getVehicleLibrary.sqf';
getVehicleData = compile preprocessFile 'client\persistance\getVehicleData.sqf';
setVehicleData = compile preprocessFile 'client\persistance\setVehicleData.sqf';
toggleHidden = compile preprocessFile 'client\functions\toggleHidden.sqf';
createDefaultRaces = compile preprocessFile 'client\persistance\defaultRaces.sqf';

// Global keybind functions
listGlobalBinds = compile preprocessFile 'client\persistance\listGlobalBinds.sqf';
setGlobalBind = compile preprocessFile 'client\persistance\setGlobalBind.sqf';
getGlobalBind = compile preprocessFile 'client\persistance\getGlobalBind.sqf';

// Setup Functions
setupLocalVehicle = compile preprocessFile "client\vehicles\local_vehicle_setup.sqf";

// Economy Functions
call compile preprocessFile 'client\economy\functions.sqf';
getCost = compile preprocessFile  'client\economy\cost.sqf';

// Stat Functions
logStat = compile preprocessFile 'client\functions\logStat.sqf';
getStat = compile preprocessFile 'client\functions\getStat.sqf';

// Object Functions
call compile preprocessFile "client\objects\actions.sqf";
rotateObj = compile preprocessFile "client\objects\rotate.sqf";
dropObj = compile preprocessFile "client\objects\drop.sqf";
attachObj = compile preprocessFile "client\objects\attach.sqf";
detachObj = compile preprocessFile "client\objects\detach.sqf";
moveObj = compile preprocessFile "client\objects\move.sqf";
grabObj = compile preprocessFile "client\objects\grab.sqf";
snapObj = compile preprocessFile 'client\objects\snap.sqf';	
tiltObj = compile preprocessFile 'client\objects\tilt.sqf';	
tagObj = compile preprocessFile 'client\objects\tag.sqf';	
findSnapPoint = compile preprocessFile "client\functions\findSnapPoint.sqf";
checkNearbyActions = compile preprocessFile "client\functions\checkNearbyActions.sqf";	
setPlayerActions = compile preprocessFile "client\functions\setPlayerActions.sqf";	
checkNearbyOwnership = compile preprocessFile "client\functions\checkNearbyOwnership.sqf";	

// Vehicle Functions
fireAttached = compile preprocessFile "client\vehicles\fire_attached.sqf";
useAttached = compile preprocessFile "client\vehicles\use_attached.sqf";
meleeAttached = compile preprocessFile "client\vehicles\melee_attached.sqf";

// Weapon Functions
fireRail = compile preprocessFile "client\vehicles\weapons\railgun.sqf";
fireLaser = compile preprocessFile "client\vehicles\weapons\laser.sqf";
fireMortar = compile preprocessFile "client\vehicles\weapons\mortar.sqf";
fireRpg = compile preprocessFile "client\vehicles\weapons\rpg.sqf";
fireHmg = compile preprocessFile "client\vehicles\weapons\hmg.sqf";
fireGmg = compile preprocessFile "client\vehicles\weapons\gmg.sqf";
fireLockOn = compile preprocessFile "client\vehicles\weapons\lockon_missile.sqf";
fireGuided = compile preprocessFile "client\vehicles\weapons\guided_missile.sqf";
fireFlamethrower = compile preprocessFile "client\vehicles\weapons\flamethrower.sqf";
fireHarpoon = compile preprocessFile "client\vehicles\weapons\harpoon.sqf";
fireLmg = compile preprocessFile "client\vehicles\weapons\lmg.sqf";
firePod = compile preprocessFile "client\vehicles\weapons\rocketPod.sqf";

meleeFork = compile preprocessFile "client\vehicles\melee\fork.sqf";
meleeRam = compile preprocessFile "client\vehicles\melee\ram.sqf";
meleeHook = compile preprocessFile "client\vehicles\melee\hook.sqf";
meleePylon = compile preprocessFile "client\vehicles\melee\pylon.sqf";


vehicleForks = compile preprocessFile "client\vehicles\attachments\vehicle_forks.sqf";
attachVehicleTo = compile preprocessFile "client\functions\attachVehicleTo.sqf";
createCollision = compile preprocessFile 'client\functions\createCollision.sqf';
collisionCheck = compile preprocessFile 'client\functions\collisionCheck.sqf';

// statusMonitor = compile preprocessFile "client\vehicles\status_monitor.sqf";
simulationManager = compile preprocessFile "client\simulation_manager.sqf";

// Effects
thrusterEffect = compile preprocessFile "client\effects\thruster.sqf";
shieldEffect = compile preprocessFile "client\effects\shield.sqf";
laserLine = compile preprocessFile "client\effects\laser_line.sqf";
empCircle = compile preprocessFile "client\effects\emp_circle.sqf";
dustCircle = compile preprocessFile "client\effects\dust_circle.sqf";
burnEffect = compile preprocessFile "client\effects\burn.sqf";
mortarImpact = compile preprocessFile "client\effects\mortar_impact.sqf";
smokeEffect = compile preprocessFile "client\effects\smoke.sqf";
cloakEffect = compile preprocessFile "client\effects\cloak.sqf";
magnetEffect = compile preprocessFile "client\effects\magnet.sqf";
sparkEffect = compile preprocessFile "client\effects\spark.sqf";
napalmEffect = compile preprocessFile "client\effects\napalm.sqf";
nitroEffect = compile preprocessFile "client\effects\nitro.sqf";
muzzleEffect = compile preprocessFile "client\effects\muzzle.sqf";
flameEffect = compile preprocessFile "client\effects\flame.sqf";
infernoEffect = compile preprocessFile "client\effects\inferno.sqf";
nukeEffect = compile preprocessFile "client\effects\nuke.sqf";
shockwaveEffect = compile preprocessFile "client\effects\shockwave.sqf";
forkEffect = compile preprocessFile "client\effects\fork.sqf";
magnetizeEffect = compile preprocessFile "client\effects\magnetize.sqf";
impactEffect = compile preprocessFile "client\effects\impact.sqf";
teleportTo = compile preprocessFile "client\effects\teleportTo.sqf";

effectIsVisible = compile preprocessFile "client\functions\effectIsVisible.sqf";

// Zone Functions
returnToZone =  compile preprocessFile "client\functions\returnToZone.sqf";
setCurrentZone = compile preprocessFile "client\functions\setCurrentZone.sqf";	


// Sponsorship
giveSponsor = compile preprocessFile "client\functions\giveSponsor.sqf";	

// UI
generateStatsList = compile preprocessFile "client\functions\generateStatsList.sqf";
addToTagList = compile preprocessFile "client\functions\addToTagList.sqf";	
removeFromTagList = compile preprocessFile "client\functions\removeFromTagList.sqf";	
checkScope = compile preprocessFile "client\functions\checkScope.sqf";

// Utility
validNearby = compile preprocessFile "client\functions\validNearby.sqf";
cropString = compile preprocessFile "client\functions\cropString.sqf";
debugLine = compile preprocessFile "client\functions\debugLine.sqf";
renderLine = compile preprocessFile "client\functions\renderLine.sqf";
renderFOV = compile preprocessFile "client\functions\renderFOV.sqf";
checkTimeout = compile preprocessFile "client\functions\checkTimeout.sqf";
createTimeout = compile preprocessFile "client\functions\createTimeout.sqf";
codeToKey = compile preprocessFile "client\functions\codeToKey.sqf";
cleanDeployList = compile preprocessFile "client\functions\cleanDeployList.sqf";
getZoom = compile preprocessFile "client\functions\getZoom.sqf";
setVariance = compile preprocessFile "client\functions\setVariance.sqf";
setVelocityLocal = compile preprocessFile "client\functions\setVelocityLocal.sqf";
inString = compile preprocessFile "client\functions\inString.sqf";
generateName = compile preprocessFile "client\functions\generateName.sqf";
vehicleReadyCheck = compile preprocessFile "client\functions\vehicleReadyCheck.sqf";

// Vehicle Functions
markAsKilledBy = compile preprocessFile "client\functions\markAsKilledBy.sqf";
markIntersects = compile preprocessFile "client\functions\markIntersects.sqf";
markNearby = compile preprocessFile "client\functions\markNearby.sqf";
checkMark = compile preprocessFile "client\functions\checkMark.sqf";
damageIntersects = compile preprocessFile "client\functions\damageIntersects.sqf";
burnIntersects = compile preprocessFile "client\functions\burnIntersects.sqf";
destroyInstantly = compile preprocessFile "client\functions\destroyInstantly.sqf";
destroyAndClear = compile preprocessFile "client\functions\destroyAndClear.sqf";
shredTyres = compile preprocessFile "client\functions\shredTyres.sqf";
setVehicleOnFire = compile preprocessFile "client\functions\setVehicleOnFire.sqf";
slowDown = compile preprocessFile "client\functions\slowDown.sqf";
flipVehicle = compile preprocessFile "client\functions\flipVehicle.sqf";
tauntVehicle = compile preprocessFile "client\functions\tauntVehicle.sqf";
detonateTargets = compile preprocessFile "client\functions\detonateTargets.sqf";
toggleLockOn = compile preprocessFile "client\functions\toggleLockOn.sqf";
assignKill = compile preprocessFile "client\functions\assignKill.sqf";
activateTeleport = compile preprocessFile "client\functions\activateTeleport.sqf";

// MP Functions
playSoundAll = compile preprocessFile "client\functions\playSoundAll.sqf";

pubVar_fnc_status = compile preprocessFile "client\functions\pubvar_status.sqf";
"pubVar_status" addPublicVariableEventHandler {(_this select 1) call pubVar_fnc_status};

pubVar_fnc_systemChat = compile preprocessFile "client\functions\pubvar_systemchat.sqf";
"pubVar_systemChat" addPublicVariableEventHandler {(_this select 1) call pubVar_fnc_systemChat};

pubVar_fnc_globalTitle = compile preprocessFile "client\functions\pubVar_globalTitle.sqf";
"pubVar_globalTitle" addPublicVariableEventHandler {_this call pubVar_fnc_globalTitle};

// MP Functions
pubVar_fnc_setHidden = compile preprocessFile "client\functions\pubVar_setHidden.sqf";
"pubVar_setHidden" addPublicVariableEventHandler { (_this select 1) call pubVar_fnc_setHidden };


// Chat command interceptor
[] call compile preProcessFilelineNumbers "client\commands\init.sqf";

// Keycodes
keyCodes = [

	['ESC', 1],
	['F1', 59],
	['F2', 60],
	['F3', 61],
	['F4', 62],
	['F5', 63],
	['F6', 64],
	['F7', 65],
	['F8', 66],
	['F9', 67],
	['F10', 68],
	['F11', 87],
	['F12', 88],
	['Print', 183],
	['Scroll', 70],
	['Pause', 197],
	['^', 41],
	['1', 2],
	['2', 3],
	['3', 4],
	['4', 5],
	['5', 6],
	['6', 7],
	['7', 8],
	['8', 9],
	['9', 10],
	['0', 11],
	['ß', 12],
	['´', 13],
	['Ü', 26],
	['Ö', 39],
	['Ä', 40],
	['#', 43],
	['<', 86],
	[',', 51],
	['.', 52],
	['-', 53],
	['POS1', 199],
	['Tab', 15],
	['Enter', 28],
	['Del', 211],
	['Backspace', 14],
	['Insert', 210],
	['End', 207],
	['PgUP', 201],
	['PgDown', 209],
	['Caps', 58],
	['A', 30],
	['B', 48],
	['C', 46],
	['D', 32],
	['E', 18],
	['F', 33],
	['G', 34],
	['H', 35],
	['I', 23],
	['J', 36],
	['K', 37],
	['L', 38],
	['M', 50],
	['N', 49],
	['O', 24],
	['P', 25],
	['Q', 16],
	['U', 22],
	['R', 19],
	['S', 31],
	['T', 20],
	['V', 47],
	['W', 17],
	['X', 45],
	['Y', 21],
	['Z', 44],
	['LShift', 42],
	['RShift', 54],
	['Up', 200],
	['Down', 208],
	['Left', 203],
	['Right', 205],
	['Num 0', 82],
	['Num 1', 79],
	['Num 2', 80],
	['Num 3', 81],
	['Num 4', 75],
	['Num 5', 76],
	['Num 6', 77],
	['Num 7', 71],
	['Num 8', 72],
	['Num 9', 73],
	['Num +', 78],
	['NUM', 69],
	['Num /', 181],
	['Num *', 55],
	['Num -', 74],
	['Num Enter', 156],
	['L Ctrl', 29],
	['R Ctrl', 157],
	['L Win', 220],
	['R Win', 219],
	['L Alt', 56],
	['Space', 57],
	['R Alt', 184],
	['App ', 221]

];

clientInit = compile preprocessFile "server\init.sqf";

clientCompileComplete = true;