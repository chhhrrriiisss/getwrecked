_wantedValue = GW_CURRENTVEHICLE getVariable ["GW_WantedValue", 0]; 
_totalValue = GW_IN_ZONE_VALUE + (_wantedValue);
_totalValue call changeBalance;
_totalValueString = [_totalValue] call numberToCurrency;
systemchat format['You earned $%1. Next payment in two minutes.', _totalValueString];
['moneyEarned', GW_CURRENTVEHICLE, _totalValue] call logStat;   
_wantedValue = _wantedValue + 50;
GW_CURRENTVEHICLE setVariable ["GW_WantedValue", _wantedValue];
GW_CURRENTVEHICLE say3D "money";