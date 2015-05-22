//
//      Name: assignKill
//      Desc: Handles stat and money to client from successful logKill on server
//      Return: None
//

private ['_money', '_vehicle'];

_money = [_this,0, 0, [0]] call filterParam;
_vehicleName = [_this,1, "", [""]] call filterParam;

[_money] call receiveMoney;
['moneyEarned', _vehicleName, _money] call logStat;   

if (_vehicleName isEqualTo "") exitWith {};
['kill', _vehicleName, 1, true] call logStat;

_vehicle = [_vehicleName] call findVehicle;

// If the vehicle is still alive assign wanted cash
if (isNull _vehicle) exitWith {};
if (!alive _vehicle) exitWith {};

_wantedValue = _vehicle getVariable ["GW_WantedValue", 0];
_wantedValue = _wantedValue + floor (_money * 0.5);
_vehicle setVariable ["GW_WantedValue", _wantedValue];


