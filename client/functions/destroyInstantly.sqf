//
//      Name: destroyInstantly
//      Desc: Blows up a vehicle and it's crew/ejected passengers
//      Return: None
//

private ['_v'];

_v = _this;

_v setDammage 1;

_this spawn {
	
	_timeout = time + 0.25;

	// Wait until the vehicle is actually dead
	waitUntil{ Sleep 0.05; (!alive _this || time > _timeout) };

	// Kill all crew and nearby players
	{ _x setDammage 1; false } count (crew _this) > 0;
	{ _x setDammage 1; false }count ((ASLtoATL getPosASL _this) nearEntities ["Man", 3]) > 0;

};