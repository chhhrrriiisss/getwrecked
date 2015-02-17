//
//      Name: handleContactVehicle
//      Return: None
//

private ['_veh'];

_veh = _this select 0; 

// If we're in the safe zone prevent flying away
if (GW_CURRENTZONE == "workshopZone") then {

	// Apply velocity to vehicle
	if (local _veh) then {
		
		_veh setVelocity [0,0,0];

	} else {

		[       
			[
				_veh,
				[0,0,0]
			],
			"setVelocityLocal",
			_veh,
			false 
		] call BIS_fnc_MP;  

	};
	
};

if (!local _veh) exitWith {};

[_veh] spawn checkTyres; 

// This is to ensure vehicles dont get stuck in the ground when landing at speed
// Most commonly it occurs on the go kart due to the wheels being especially small

if (isNil "GW_LAST_CONTACT") then { 
	GW_LAST_CONTACT = time;
};



if ( (typeOf _veh == "C_Kart_01_F" || !isNil {_veh getVariable "newSpawn"} ) && player == (driver _veh) && (time - GW_LAST_CONTACT > 0.3) ) then {
	GW_LAST_CONTACT = time;

	_prevPos = _veh getVariable ['prevPos', [0,0,0]];
	_prevAlt = _prevPos select 2;
	_currentAlt = (getPos _veh) select 2;

	if (_prevAlt > 2 || _currentAlt < 0) then {
		_vel = velocity _veh;
		_normal = surfaceNormal (ASLtoATL getPosASL _veh);
		_veh setVectorUp _normal;
		_vel set[2, (_vel select 2) + 1];
		_veh setVelocity _vel;
		[_veh, true, false] call flipVehicle;		
	};
	
};

_special = _veh getVariable ["special", []];

if ('FRK' in _special) then {	
    [_veh] spawn vehicleForks;
};


