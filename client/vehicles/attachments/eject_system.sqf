//
//      Name: ejectSystem
//      Desc: Launches player from vehicle with a parachute
//      Return: None
//

private ["_vehicle", "_player", "_newPos"];

_vehicle = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_player = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _vehicle || isNull _player) exitWith {};
if (!local _vehicle) exitWith {};

_player = _this select 1;

if (_player == (vehicle _player)) then {} else {
	_player action ["eject", _vehicle];
};

["EJECTING!", 3, ejectIcon, colorRed, "default"] spawn createAlert;

_newPos = (ASLtoATL getPosASL _vehicle);
_newPos set[2, (_newPos select 2) + 5];
_player setPosATL _newPos;

playSound3D ["a3\sounds_f\weapons\Mortar\mortar_05.wss", _vehicle, false, getPosATL (_vehicle), 2, 1, 100];

[
	[
		_vehicle,
		1
	],
	"dustCircle"
] call BIS_fnc_MP;

waitUntil { _player == (vehicle _player) };	
removeBackPack player;

_rndY = (random 1) - 0.5;
_rndX = (random 1) - 0.5;
_rndZ = (random 60) + 80;

_player switchMove "stand";
_player setVelocity [_rndX,_rndY, _rndZ];
_player addBackpack "B_Parachute";

removeAllActions _player;

true