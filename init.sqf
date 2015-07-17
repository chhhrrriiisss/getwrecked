//
//     Get Wrecked
//     Vehicle Combat Sandbox by Sli
//
//     getwrecked.info
//     @GetWreckedA3
//     
//     This mod and its content (excluding those already attributed therein) are under a CC-BY-NC-ND 4.0 License
//     Attribution-NonCommercial-NoDerivatives 4.0 International
//     Permission must be sought from the Author for its commercial use, any modification or use of a non-public release obtained via the mission cache
//     

//TEST

X_Server = false;
X_Client = false;
X_JIP = false;

// Used to determine if saved vehicles are out-of-date
GW_VERSION = 82;

if (isServer) then { X_Server = true };
if (!isDedicated) then { X_Client = true };
if (isNull player) then { X_JIP = true };

// Get the mission directory
MISSION_ROOT = call {
    private "_arr";
    _arr = toArray str missionConfigFile;
    _arr resize (count _arr - 15);
    toString _arr
};

// Global Variables / Functions
call compile preprocessFile "global\compile.sqf";
[] execVM "briefing.sqf";

hint "v0.8.2c RC7";

99999 cutText [localize "str_gw_loading", "BLACK", 0.01]; 

// Zone boundaries
[] call parseZones;

if (X_Client || X_JIP) then {
   
   [] spawn {  

        call compile preprocessFile "client\compile.sqf";  
        waitUntil {!isNull player};               
        [] execVM 'client\init.sqf'; 

    };

};

if (isServer) then {      

    call compile preprocessFile "server\compile.sqf";   
    [] execVM 'server\init.sqf'; 

};


