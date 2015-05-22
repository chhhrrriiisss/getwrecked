//
//      Name: setPlayerActions
//      Desc: Primary actions attached to player
//      Return: None
//

_unit = _this;

// Lift vehicle
_unit addAction[liftVehicleFormat, {

	[([(_this select 0), 8] call validNearby), (_this select 0)] spawn liftVehicle;

}, [], 0, false, false, "", "( (GW_CURRENTZONE == 'workshopZone') && !GW_EDITING && (vehicle player) == player && (!isNil { [_target, 8, 90] call validNearby }) && !GW_LIFT_ACTIVE && !(GW_PAINT_ACTIVE) && !GW_TAG_ACTIVE )"];		


// Show changes to vehicle
_unit addAction[showVehicleFormat, {	
	([(_this select 0), 8, true] call validNearby) call toggleHidden;
}, [], 0, false, false, "", "( (GW_CURRENTZONE == 'workshopZone') && 

	{
		_nearby = [_target, 8, 180] call validNearby; 
		if (isNil '_nearby') exitWith { false };
		_isHidden = _nearby getVariable ['GW_HIDDEN', false];
		if (!_isHidden) exitWith { false };
		true
	}

&& !GW_EDITING && (vehicle player) == player && (!isNil { [_target, 8, 90] call validNearby }) && !GW_LIFT_ACTIVE && !(GW_PAINT_ACTIVE) && !GW_TAG_ACTIVE )"];	

// Hide changes to vehicle
_unit addAction[hideVehicleFormat, {	
	([(_this select 0), 8, true] call validNearby) call toggleHidden;
}, [], 0, false, false, "", "( (GW_CURRENTZONE == 'workshopZone') && 

	{
		_nearby = [_target, 8, 180] call validNearby; 
		if (isNil '_nearby') exitWith { false };
		_isHidden = _nearby getVariable ['GW_HIDDEN', false];
		if (_isHidden) exitWith { false };
		true		
	}

&& !GW_EDITING && (vehicle player) == player && (!isNil { [_target, 8, 90] call validNearby }) && !GW_LIFT_ACTIVE && !(GW_PAINT_ACTIVE) && !GW_TAG_ACTIVE )"];	

// Open the settings
_unit addAction[settingsVehicleFormat, {

	[([(_this select 0), 8, 180] call validNearby), (_this select 0)] spawn settingsMenu;

}, [], 0, false, false, "", "( !GW_EDITING && (vehicle player) == player && (!isNil { [_target, 8, 90] call validNearby }) && !GW_LIFT_ACTIVE && !(GW_PAINT_ACTIVE) && !GW_TAG_ACTIVE )"];		
