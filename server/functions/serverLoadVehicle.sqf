//
//      Name: serverLoadVehicle
//      Desc: Handles a load request for a vehicle from client
//      Return: None
//

private ['_unit', '_pcid', '_data'];

// Spawn it so we can handle lots of them
_u = [_this,0, objNull, [objNull]] call BIS_fnc_param;	
_t = [_this,1, [], [[]]] call BIS_fnc_param;	
_d = [_this,2, [], [[]]] call BIS_fnc_param;	

if (isNull _u) exitWith {
	diag_log "Load vehicle requested from null source.";
};

_pcid = owner _u;

// In case of bad packet, abort!
if (count _t == 0 || count _d == 0) exitWith {
	diag_log "Cant load vehicle with bad data or target.";
	pubVar_status = [2, ["Bad data or location", ""]]; 
	_pcid publicVariableClient "pubVar_status";
};

// Everything's ok, reassure the client
pubVar_systemChat = "Recieved request.";
_pcid publicVariableClient "pubVar_systemChat";

[_pcid, (_this select 1), (_this select 2)] call loadVehicle;


