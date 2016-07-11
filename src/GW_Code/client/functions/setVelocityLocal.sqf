//
//      Name: setVelocityLocal
//      Desc: Executed remotely to set velocity on target vehicle
//      Return: None
//

private ['_source', '_destination', '_ignore'];
params ['_vehicle', '_velocity'];

if (isNull _vehicle || count _velocity == 0) exitWith {};
if (!local _vehicle) exitWith {};
if (!alive _vehicle) exitWith {};
if ((_velocity distance [0,0,0]) <= 0) exitWith {};

// Prevent incoming network spam of velocity updates
if (isNil "GW_LAST_VELOCITY_UPDATE") then { GW_LAST_VELOCITY_UPDATE = time - 3; };
if (time - GW_LAST_VELOCITY_UPDATE < 0.3) exitWith {};
GW_LAST_VELOCITY_UPDATE = time;

_vehicle setVelocity _velocity;