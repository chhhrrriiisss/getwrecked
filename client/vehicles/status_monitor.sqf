//
//      Name: statusMonitor
//      Desc: Handles status effects (none visual) while in a vehicle
//      Return: None
//

private ['_vehicle', '_status'];

_vehicle = _this select 0;
_status = _vehicle getVariable ["status", []];
_special = _vehicle getVariable ["special", []];

// Do we need to eject?
[_vehicle, player] spawn checkEject;

// Every 2 minutes, give sponsorship money
if (isNil "GW_LASTPAYCHECK") then {  GW_LASTPAYCHECK = time; };
if (time - GW_LASTPAYCHECK > 120) then {

    GW_LASTPAYCHECK = time;
    _wantedValue = _vehicle getVariable ["GW_WantedValue", 0]; 
    _totalValue = 100 + (_wantedValue);
    _totalValue call changeBalance;
    _totalValueString = [_totalValue] call numberToCurrency;
    systemchat format['You earned $%1. Next payment in two minutes.', _totalValueString];
    ['moneyEarned', _vehicle, _totalValue] spawn logStat;   
    _wantedValue = _wantedValue + 50;
    _vehicle setVariable ["GW_WantedValue", _wantedValue];
    _vehicle say3D "money";

};

// Every 3 seconds, record position, ignoring while in parachute
_remainder = round (time) % 3;

if (_remainder == 0 && (typeOf _vehicle != "Steerable_Parachute_F")) then {
   
    _prevPos = _vehicle getVariable ['prevPos', nil];
    _currentPos = ASLtoATL getPosASL _vehicle;

    // If there's position data stored and we're not at the workshop
    if (!isNil "_prevPos") then {
        _distanceTravelled = _prevPos distance _currentPos;   
        if (_distanceTravelled > 3) then {       
            ['mileage', _vehicle, _distanceTravelled] spawn logStat;   
        };
    };

    if (isNil "GW_LASTPOSCHECK") then {        
        GW_LASTPOSCHECK = time;
    };   

    _timeAlive = (time - GW_LASTPOSCHECK);
    if (_timeAlive > 0) then {
        ['timeAlive', _vehicle, _timeAlive] spawn logStat;   
    };      

    GW_LASTPOSCHECK = time; 
   
    _vehicle setVariable ['prevPos', _currentPos];
    player setVariable ['prevPos', _currentPos];
    player setVariable ['prevVeh', _vehicle];

};

// No status, reinflate tyres 
if (count _status <= 0) exitWith {
    _vehicle sethit ["wheel_1_1_steering", 0];
    _vehicle sethit ["wheel_1_2_steering", 0];
    _vehicle sethit ["wheel_2_1_steering", 0];
    _vehicle sethit ["wheel_2_2_steering", 0];
};

// Give a little bit of fuel if it looks like we're out
if (fuel _vehicle < 0.01) then {
    _vehicle setFuel 0.01;
};

switch (true) do {     

     case ("disabled" in _status): {

        _vehicle sethit ["wheel_1_1_steering", 1];
        _vehicle sethit ["wheel_1_2_steering", 1];
        _vehicle sethit ["wheel_2_1_steering", 1];
        _vehicle sethit ["wheel_2_2_steering", 1];

        [_vehicle, 0] spawn slowDown;                 

    };

    case ("tyresPopped" in _status): {

        _vehicle sethit ["wheel_1_1_steering", 1];
        _vehicle sethit ["wheel_1_2_steering", 1];
        _vehicle sethit ["wheel_2_1_steering", 1];
        _vehicle sethit ["wheel_2_2_steering", 1];

        [_vehicle, 0.97] spawn slowDown;                 

    };

    case ("invulnerable" in _status): {

        _invState = getDammage _vehicle;        
        _vehicle setDammage _invState;
        
    };

    case ("fire" in _status): {   

        // Put out fire if we drive in water
        if (surfaceIsWater (getPosASL _vehicle)) then {

            [       
                [
                    _vehicle,
                    ['fire']
                ],
                "removeVehicleStatus",
                _vehicle,
                false 
            ] call BIS_fnc_MP;   

        } else {                                         
      
            _dmg = getDammage _vehicle;
            _rnd = (random 4) + 8;
            _rnd = (_rnd / 10000) * FIRE_DMG_SCALE;
            _newDmg = _dmg + _rnd;
            _vehicle setDammage _newDmg;

        };
    };

    case ("emp" in _status): { 

        [_vehicle, 0.5] spawn slowDown;   

    }; 
    
};