//
//
//
//		Server Initialization
//
//
//

[] call spawnObjects;
[] call initPaint;
[] call initSupply;
[] call generateBoundary;
[] call spawnExplosiveBarrels;

serverSetupComplete = compileFinal "true";
publicVariable "serverSetupComplete";

