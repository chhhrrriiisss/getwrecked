//
//      Name: logKill
//      Desc: Handles a successful kill message recieved from client
//      Return: None
//

private["_type", "_key", "_value"];

_victim = [_this,0,"",[""]] call bis_fnc_param;
_killer = [_this,1,"",[""]] call bis_fnc_param;
_value = [_this,2,0,[0]] call bis_fnc_param;

if (_victim == "" || _killer == "") exitWith {};

if (isNil "GW_MESSAGELOGGED") then { GW_MESSAGELOGGED = time - 5; };
if (time < (GW_MESSAGELOGGED + 3)) exitWith {};
GW_MESSAGELOGGED = time;
                
_string = format["%1 was destroyed by %2", _victim, _killer];
GW_SERVER_LASTKILL = format['%1/%2', _victim, _killer];

// Log the message on all clients
diag_log _string;
systemChat _string;	

pubVar_systemChat = _string;
publicVariable "pubVar_systemChat";

// Give the killer his cash if we can find him
_target = [_killer] call findUnit;

if (!isNil "_target") then {

    [       
        [
            _value
        ],
        "receiveMoney",
        _target,
        false 
    ] call BIS_fnc_MP;  
    
};	