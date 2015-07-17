_owner = [_this, 0, objNull, [objNull]] call filterParam;
_points = [_this, 1, [], [[]]] call filterParam;
_settings = [_this, 2, _defaults, [[]]] call filterParam;

if (count _points == 0 && !isNull _owner) exitWith {
	pubVar_systemChat = 'Couldnt create race, bad configuration or checkpoints provided.';
	systemchat pubVar_systemChat;
    (owner _owner) publicVariableClient "pubVar_systemChat";
};

// Sync points to all clients
