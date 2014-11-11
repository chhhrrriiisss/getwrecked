//
//
//
//		Server Initialization
//
//
//

_startTime = time;

[] call spawnObjects;
[] call initPaint;
[] call initSupply;
[] call generateBoundary;
[] call spawnExplosiveBarrels;

serverSetupComplete = compileFinal "true";
publicVariable "serverSetupComplete";

_endTime = time;
_str =  format['Server setup completed in %1s.', (_endTime - _startTime)];
diag_log _str;
systemchat _str;