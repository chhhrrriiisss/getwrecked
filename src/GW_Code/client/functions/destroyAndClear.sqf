(driver _this) setDammage 1;
_this call destroyInstantly;
waitUntil { !alive _this };
{ deleteVehicle _x; } foreach attachedObjects _this;
deleteVehicle _this;


