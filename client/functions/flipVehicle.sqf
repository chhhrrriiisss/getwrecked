//
//      Name: flipVehicle
//      Desc: Restores vehicle position in the event it is upside down or cant move
//      Return: None
//

private ['_vehicle', '_dir', '_pos', '_alt', '_vel'];

_vehicle = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _vehicle) exitWith {};

_dir = getDir _vehicle;
_pos = (ASLtoATL getPosASL _vehicle);
_alt = _pos select 2;
_vel = [0,0,0] distance (velocity _vehicle);

if (_vel > 1) exitWith {}; // Going too fast
if (_alt > 30) exitWith {}; // Going too high

_pos set[2,1];
_vehicle setDir _dir;
_vehicle setPosATL _pos;