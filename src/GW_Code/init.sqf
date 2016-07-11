GW_Server = false;
GW_Client = false;
GW_JIP = false;

// Used to determine if saved vehicles are out-of-date
GW_VERSION = 86.46;
 
if (isServer) then { GW_Server = true; };
if (!isDedicated) then { GW_Client = true; };
if (isNull player) then { GW_JIP = true; };

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

hint "v0.8.6h";

99999 cutText [localize "str_gw_loading", "BLACK", 0.01]; 

if (GW_Client || GW_JIP) then {
   
   [] spawn {  

        call compile preprocessFile "client\compile.sqf";  
        waitUntil {!isNull player && !isNil "clientCompileComplete"};               
        [] execVM 'client\init.sqf';

    };

};

if (GW_Server) then {      

	[] spawn {

	    call compile preprocessFile "server\compile.sqf";   
	    waitUntil {!isNil "serverCompileComplete"};      
	    [] execVM 'server\init.sqf';

	};

};


