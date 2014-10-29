//
//     Get Wrecked
//     Vehicle Combat Sandbox by Sli
//
//     chrisnic.github.io/getwrecked
//     
//     This mod and its content (excluding those already attributed therein) are under a CC-BY-NC-ND 4.0 License
//     Attribution-NonCommercial-NoDerivatives 4.0 International
//     Permission must be sought from the Author for its commercial use or any modification
//     

X_Server = false;
X_Client = false;
X_JIP = false;

// Used to determine if saved vehicles are out-of-date
GW_VERSION = 76;

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

hint "v0.7.6 RC4";

99999 cutText ["Loading...", "BLACK", 0.01]; 

// Zone boundaries
[] call parseZones;

if (isServer) then {      

    call compile preprocessFile "server\compile.sqf";   
    [] execVM 'server\init.sqf'; 

};

if (X_Client || X_JIP) then {
   
   [] spawn {  

        call compile preprocessFile "client\compile.sqf";  

        waitUntil {!isNull player};     
        waitUntil {(getPlayerUID player) != ""};   
                 
        [] execVM 'client\init.sqf'; 

    };

};

