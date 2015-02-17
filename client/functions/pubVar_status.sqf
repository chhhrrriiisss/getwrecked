//
//      Name: pubVar_status
//      Desc: Handles status packets sent from the server for various functions
//      Return: None
//

_status = if (isNil { _this select 0 }) then { -1 } else { (_this select 0) };
_value = if (isNil { _this select  1}) then { [] } else { (_this select 1) };

if (_status == -1) exitWith {};

// Warning Local
if (_status == 0) exitWith {
	systemChat _value;
};

// Successfully loaded vehicle
if (_status == 1) exitWith {
	
	// Got it, well done!
	if (isNil "GW_PREVIEW_VEHICLE") then {

		GW_PREVIEW_VEHICLE = _value select 0;
		_timer = _value select 1;
		_currentTime = time;

		// Re-target the preview camera to the newly loaded vehicle
		if (GW_PREVIEW_CAM_ACTIVE) then { GW_PREVIEW_CAM_TARGET = GW_PREVIEW_VEHICLE; };

		[GW_PREVIEW_VEHICLE] call setupLocalVehicle;	
		
		_finalTime = (time - _currentTime) + _timer;
		systemChat format["Setup completed in %1.", _finalTime];

		if (GW_WAITLOAD) then { GW_WAITLOAD = false; };

    } else {
    	//Arrived, but a bit too late
    	if (GW_WAITLOAD) then {  GW_WAITLOAD = false; };
	};	
};

// Fail Load Vehicle
if (_status == 2) exitWith {
	systemChat format["Critical error while loading [ %1 ]", (_value select 0)];
};

// Successfully hit vehicle
if (_status == 3) exitWith {
	// systemChat 'Hit a vehicle!';
};


