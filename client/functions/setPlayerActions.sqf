_unit = _this;

_unit addAction[liftVehicleFormat, {

	[([player, 8] call validNearby), (_this select 0)] spawn liftVehicle;

}, [], 0, false, false, "", "( (GW_CURRENTZONE == 'workshopZone') && !GW_EDITING && (vehicle player) == player && (!isNil { [_target, 7, true] call validNearby }) && !GW_LIFT_ACTIVE && !(GW_PAINT_ACTIVE) )"];		

// Open the box inventory
_unit addAction[settingsVehicleFormat, {

	[([player, 8] call validNearby), (_this select 0)] spawn settingsMenu;

}, [], 0, false, false, "", "( !GW_EDITING && (vehicle player) == player && (!isNil { [_target, 7, true] call validNearby }) && !GW_LIFT_ACTIVE && !(GW_PAINT_ACTIVE) )"];		