//
//      Name: handleContactVehicle
//      Return: None
//

private ['_veh'];

_veh = _this select 0; 

if (!local _veh) exitWith {};

[_veh] spawn checkTyres; 
[_veh, player] call checkEject;

// This is to ensure vehicles dont get stuck in the ground when landing at speed
// Most commonly it occurs on the go kart due to the wheels being especially small
if ( (typeOf _veh == "C_Kart_01_F" || !isNil {_veh getVariable "newSpawn"} ) && player == (driver _veh)) then {

	_prevPos = _veh getVariable ['prevPos', [0,0,0]];
	_prevAlt = _prevPos select 2;
	_currentAlt = (getPos _veh) select 2;

	if (_prevAlt > 5 || _currentAlt < 0) then {

		[_veh] call flipVehicle;
	};
	
};

_special = _veh getVariable ["special", []];

if ('FRK' in _special) then {	
    [_veh] spawn vehicleForks;
};

