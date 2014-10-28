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
GW_STATS_ORDER = ["kills", "deaths", "destroyed", "mileage", "moneyEarned", "timeAlive", "deploys"];
GW_INVULNERABLE = true;
GW_DEPLOYLIST = [];
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
GW_LIFT_ACTIVE = false;
GW_PAINT_ACTIVE = false;
GW_LMBDOWN = false;
GW_LINEFFECT_ARRAY = [];
GW_LINEEFFECT_COLOR = colorRed;
GW_TARGETICON_ARRAY = [];
GW_WARNINGICON_ARRAY = [];
GW_TAGLIST = [];

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

// Ui
call compile preprocessfile "client\ui\display\display.sqf";
call compile preprocessFile 'client\ui\compile.sqf';
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

// HUD Functions
createAlert = compile preprocessFile "client\ui\hud\alert.sqf";
createTween = compile preprocessFile "client\ui\hud\tween.sqf";
createMessage = compile preprocessFile "client\ui\dialogs\message.sqf";
createTimer = compile preprocessFile "client\ui\dialogs\timer.sqf";

// Zone
deployVehicle = compile preprocessFile 'client\zones\deploy.sqf';
parachuteVehicle = compile preprocessFile 'client\zones\parachute_vehicle.sqf';
checkInZone = compile preprocessFile 'client\zones\check_in_zone.sqf';

// Persistance Functions
paintVehicle = compile preprocessFile 'client\customization\paint_vehicle.sqf';
liftVehicle = compile preprocessFile 'client\objects\lift_vehicle.sqf';
requestVehicle = compile preprocessFile  'client\persistance\request.sqf';
registerVehicle = compile preprocessFile  'client\persistance\add.sqf';
saveVehicle = compile preprocessFile  'client\persistance\save.sqf';
listFunctions = compile preprocessFile  'client\persistance\library.sqf';
listVehicles = compile preprocessFile  'client\persistance\list.sqf';

// Setup Functions
setupLocalVehicleHandlers = compile preprocessFile "client\vehicles\handlers\local_handlers.sqf";
setupLocalObjectHandlers = compile preprocessFile "client\objects\handlers\local_handlers.sqf";
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

// Module Functions
smokeBomb = compile preprocessFile "client\vehicles\attachments\smoke_bomb.sqf";
verticalThruster = compile preprocessFile "client\vehicles\attachments\thruster.sqf";
nitroBoost = compile preprocessFile "client\vehicles\attachments\nitro_boost.sqf";
ejectSystem = compile preprocessFile "client\vehicles\attachments\eject_system.sqf";
emergencyRepair = compile preprocessFile "client\vehicles\attachments\emergency_repair.sqf";
empDevice = compile preprocessFile "client\vehicles\attachments\emp_device.sqf";
selfDestruct = compile preprocessFile "client\vehicles\attachments\self_destruct.sqf";
ejectSystem = compile preprocessFile "client\vehicles\attachments\eject_system.sqf";
oilSlick = compile preprocessFile "client\vehicles\attachments\oil_slick.sqf";
dropCaltrops = compile preprocessFile "client\vehicles\attachments\caltrops.sqf";
dropMines = compile preprocessFile 'client\vehicles\attachments\mines.sqf';
dropExplosives = compile preprocessFile "client\vehicles\attachments\explosives.sqf";
shieldGenerator = compile preprocessFile "client\vehicles\attachments\shield_generator.sqf";
cloakingDevice = compile preprocessFile "client\vehicles\attachments\cloak.sqf";
magneticCoil = compile preprocessFile "client\vehicles\attachments\magnetic_coil.sqf";
statusMonitor = compile preprocessFile "client\vehicles\status_monitor.sqf";

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

// Vehicle Functions
markAsKilledBy = compile preprocessFile "client\functions\markAsKilledBy.sqf";
markIntersects = compile preprocessFile "client\functions\markIntersects.sqf";
markNearby = compile preprocessFile "client\functions\markNearby.sqf";
checkMark = compile preprocessFile "client\functions\checkMark.sqf";
destroyIntersects = compile preprocessFile "client\functions\destroyIntersects.sqf";
burnIntersects = compile preprocessFile "client\functions\burnIntersects.sqf";
popIntersects = compile preprocessFile "client\functions\popIntersects.sqf";
slowDown = compile preprocessFile "client\functions\slowDown.sqf";
flipVehicle = compile preprocessFile "client\functions\flipVehicle.sqf";

// MP Functions
logStatKill = compile preprocessFile "client\functions\logStatKill.sqf";
playSoundAll = compile preprocessFile "client\functions\playSoundAll.sqf";

pubVar_fnc_status = compile preprocessFile "client\functions\pubvar_status.sqf";
"pubVar_status" addPublicVariableEventHandler {(_this select 1) call pubVar_fnc_status};

pubVar_fnc_systemChat = compile preprocessFile "client\functions\pubvar_systemchat.sqf";
"pubVar_systemChat" addPublicVariableEventHandler {(_this select 1) call pubVar_fnc_systemChat};

clientCompileComplete = true;