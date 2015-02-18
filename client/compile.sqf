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
	["PARC", ""]
];

GW_STATS_ORDER = ["kills", "deaths", "destroyed", "mileage", "moneyEarned", "timeAlive", "deploys"];
GW_INVULNERABLE = true;
GW_DEPLOYLIST = [];
GW_LOCKEDTARGETS = [];
GW_LASTMESSAGELOGGED = time;
GW_DEBUG = false;
GW_BUY_ACTIVE = false;
GW_NEW_ACTIVE = false;
GW_INVENTORY_ACTIVE = false;
GW_DEATH_CAMERA_ACTIVE = false;
GW_PREVIEW_CAM_ACTIVE = false;
GW_SETTINGS_ACTIVE = false;
GW_SPAWN_ACTIVE = false;
GW_DEPLOY_ACTIVE = false;
GW_TIMER_ACTIVE = false;
GW_DIALOG_ACTIVE = false;
GW_HUD_ACTIVE = false;
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

// Player
playerInit = compile preprocessFile 'client\player_init.sqf';
playerKilled = compile preprocessFile 'client\player_killed.sqf';
playerSpawn = compile preprocessFile 'client\player_spawn.sqf';
playerRespawn = compile preprocessFile 'client\player_respawn.sqf';
cameraPreview = compile preprocessFile 'client\ui\cameras\preview_camera.sqf';
deathCamera = compile preprocessFile "client\ui\cameras\death_camera.sqf";
previewCamera = compile preprocessFile "client\ui\cameras\preview_camera.sqf";
setPlayerTexture = compile preprocessFile 'client\functions\setPlayerTexture.sqf';
call compile preprocessfile "client\key_binds.sqf";

// UI
call compile preprocessFile 'client\ui\compile.sqf';
drawMap = compile preprocessfile "client\ui\display\map.sqf";
drawDisplay = compile preprocessfile "client\ui\display\display.sqf";
drawHud = compile preprocessFile "client\ui\hud\hud.sqf";
vehicleTag = compile preprocessFile 'client\ui\display\vehicle_tag.sqf';
targetLockOn = compile preprocessFile 'client\ui\display\lockon.sqf';
targetCursor = compile preprocessFile 'client\ui\display\target.sqf';
mouseHandler = compile preprocessFile 'client\ui\display\mouse_handler.sqf';
settingsMenu = compile preprocessFile "client\ui\dialogs\settings.sqf";
newMenu = compile preprocessFile "client\ui\dialogs\new.sqf";
buyMenu = compile preprocessFile "client\ui\dialogs\buy.sqf";
inventoryMenu = compile preprocessFile "client\ui\dialogs\inventory.sqf";
spawnMenu = compile preprocessFile "client\ui\menus\spawn.sqf";
previewMenu = compile preprocessFile "client\ui\menus\preview.sqf";
drawServiceIcon = compile preprocessFile "client\functions\drawServiceIcon.sqf";

// HUD Functions
createAlert = compile preprocessFile "client\ui\hud\alert.sqf";
createNotification = compile preprocessFile "client\ui\hud\notification.sqf";
createHalo = compile preprocessFile "client\ui\hud\halo.sqf";
createTween = compile preprocessFile "client\ui\hud\tween.sqf";
createMessage = compile preprocessFile "client\ui\dialogs\message.sqf";
createTimer = compile preprocessFile "client\ui\dialogs\timer.sqf";

// Zone
deployVehicle = compile preprocessFile 'client\zones\deploy.sqf';
servicePoint = compile preprocessFile 'client\zones\vehicle_point.sqf';
nitroPad =  compile preprocessFile 'client\zones\nitro_pad.sqf';

// Persistance Functions
paintVehicle = compile preprocessFile 'client\customization\paint_vehicle.sqf';
liftVehicle = compile preprocessFile 'client\objects\lift_vehicle.sqf';
requestVehicle = compile preprocessFile  'client\persistance\request.sqf';
registerVehicle = compile preprocessFile  'client\persistance\add.sqf';
saveVehicle = compile preprocessFile  'client\persistance\save.sqf';
listFunctions = compile preprocessFile  'client\persistance\library.sqf';
listVehicles = compile preprocessFile  'client\persistance\list.sqf';

// Setup Functions
setupLocalVehicle = compile preprocessFile "client\vehicles\local_vehicle_setup.sqf";

// Economy Functions
call compile preprocessFile 'client\economy\functions.sqf';
getCost = compile preprocessFile  'client\economy\cost.sqf';

// Stat Functions
logStat = compile preprocessFile 'client\stats.sqf';

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

// Module Functions
smokeBomb = compile preprocessFile "client\vehicles\attachments\smoke_bomb.sqf";
verticalThruster = compile preprocessFile "client\vehicles\attachments\thruster.sqf";
nitroBoost = compile preprocessFile "client\vehicles\attachments\nitro_boost.sqf";
emergencyRepair = compile preprocessFile "client\vehicles\attachments\emergency_repair.sqf";
empDevice = compile preprocessFile "client\vehicles\attachments\emp_device.sqf";
selfDestruct = compile preprocessFile "client\vehicles\attachments\self_destruct.sqf";
emergencyParachute = compile preprocessFile "client\vehicles\attachments\emergency_parachute.sqf";
oilSlick = compile preprocessFile "client\vehicles\attachments\oil_slick.sqf";
dropCaltrops = compile preprocessFile "client\vehicles\attachments\caltrops.sqf";
dropMines = compile preprocessFile 'client\vehicles\attachments\mines.sqf';
dropExplosives = compile preprocessFile "client\vehicles\attachments\explosives.sqf";
dropJammer = compile preprocessFile "client\vehicles\attachments\frequency_jammer.sqf";
shieldGenerator = compile preprocessFile "client\vehicles\attachments\shield_generator.sqf";
cloakingDevice = compile preprocessFile "client\vehicles\attachments\cloak.sqf";
magneticCoil = compile preprocessFile "client\vehicles\attachments\magnetic_coil.sqf";
vehicleForks = compile preprocessFile "client\vehicles\attachments\vehicle_forks.sqf";
attachVehicleTo = compile preprocessFile "client\functions\attachVehicleTo.sqf";

statusMonitor = compile preprocessFile "client\vehicles\status_monitor.sqf";
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
nitroEffect = compile preprocessFile "client\effects\nitro.sqf";
muzzleEffect = compile preprocessFile "client\effects\muzzle.sqf";
flameEffect = compile preprocessFile "client\effects\flame.sqf";
nukeEffect = compile preprocessFile "client\effects\nuke.sqf";
shockwaveEffect = compile preprocessFile "client\effects\shockwave.sqf";

// Zone Functions
returnToZone =  compile preprocessFile "client\functions\returnToZone.sqf";
setCurrentZone = compile preprocessFile "client\functions\setCurrentZone.sqf";	


// UI
generateStatsList = compile preprocessFile "client\functions\generateStatsList.sqf";
addToTagList = compile preprocessFile "client\functions\addToTagList.sqf";	
removeFromTagList = compile preprocessFile "client\functions\removeFromTagList.sqf";	
checkScope = compile preprocessFile "client\functions\checkScope.sqf";

// Utility
validNearby = compile preprocessFile "client\functions\validNearby.sqf";
cropString = compile preprocessFile "client\functions\cropString.sqf";
debugLine = compile preprocessFile "client\functions\debugLine.sqf";
checkTimeout = compile preprocessFile "client\functions\checkTimeout.sqf";
createTimeout = compile preprocessFile "client\functions\createTimeout.sqf";
codeToKey = compile preprocessFile "client\functions\codeToKey.sqf";
cleanDeployList = compile preprocessFile "client\functions\cleanDeployList.sqf";
getZoom = compile preprocessFile "client\functions\getZoom.sqf";
setVariance = compile preprocessFile "client\functions\setVariance.sqf";
setVelocityLocal = compile preprocessFile "client\functions\setVelocityLocal.sqf";
inString =  compile preprocessFile "client\functions\inString.sqf";

// Vehicle Functions
markAsKilledBy = compile preprocessFile "client\functions\markAsKilledBy.sqf";
markIntersects = compile preprocessFile "client\functions\markIntersects.sqf";
markNearby = compile preprocessFile "client\functions\markNearby.sqf";
checkMark = compile preprocessFile "client\functions\checkMark.sqf";
damageIntersects = compile preprocessFile "client\functions\damageIntersects.sqf";
burnIntersects = compile preprocessFile "client\functions\burnIntersects.sqf";
destroyInstantly = compile preprocessFile "client\functions\destroyInstantly.sqf";
popIntersects = compile preprocessFile "client\functions\popIntersects.sqf";
setVehicleOnFire = compile preprocessFile "client\functions\setVehicleOnFire.sqf";
slowDown = compile preprocessFile "client\functions\slowDown.sqf";
flipVehicle = compile preprocessFile "client\functions\flipVehicle.sqf";
tauntVehicle = compile preprocessFile "client\functions\tauntVehicle.sqf";
detonateTargets = compile preprocessFile "client\functions\detonateTargets.sqf";
toggleLockOn = compile preprocessFile "client\functions\toggleLockOn.sqf";
assignKill = compile preprocessFile "client\functions\assignKill.sqf";

// MP Functions
logStatKill = compile preprocessFile "client\functions\logStatKill.sqf";
playSoundAll = compile preprocessFile "client\functions\playSoundAll.sqf";

pubVar_fnc_status = compile preprocessFile "client\functions\pubvar_status.sqf";
"pubVar_status" addPublicVariableEventHandler {(_this select 1) call pubVar_fnc_status};

pubVar_fnc_systemChat = compile preprocessFile "client\functions\pubvar_systemchat.sqf";
"pubVar_systemChat" addPublicVariableEventHandler {(_this select 1) call pubVar_fnc_systemChat};

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
	['R Ctrl', 29],
	['L Ctrl', 157],
	['L Win', 220],
	['R Win', 219],
	['L Alt', 56],
	['Space', 57],
	['R Alt', 184],
	['App ', 221]

];

clientCompileComplete = true;