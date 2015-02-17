//
//      Name: assignKill
//      Desc: Handles stat and money to client from successful logKill on server
//      Return: None
//

_money = _this select 0;
_inVehicle = false;

_v = if (player == (vehicle player)) then {	
	(player getVariable ["prevVeh", nil])
} else {
	(vehicle player)
};

[_money] call receiveMoney;

if (isNil "_v") exitWith {};

// If the vehicle is still alive assign wanted cash
if (player != _v && alive _v) then {

	_wantedValue = _v getVariable ["GW_WantedValue", 0];
	_wantedValue = _wantedValue + (_money * 0.25);
	_v setVariable ["GW_WantedValue", _wantedValue];

};

['kill', (vehicle player), 1, true] call logStat;